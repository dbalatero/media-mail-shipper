#!/usr/bin/env ruby

require 'easypost'
require 'json'
require 'pry'

EasyPost.api_key = ENV.fetch('EASYPOST_API_KEY')

from_address = JSON.parse(File.read("./from_address.json"))
from_address = from_address.reduce({}) do |address, (key, value)|
  address[key.to_sym] = value
  address
end

def read_value(prompt, default = nil)
  print "#{prompt} "
  print "(#{default}) " if default
  print "> "

  value = STDIN.gets.strip
  value = nil if value == ""

  value || default
end

address = {}
address[:name] = read_value("Name?")
address[:street1] = read_value("Street?")
address[:street2] = read_value("Street 2?")
address[:city] = read_value("City?")
address[:state] = read_value("State?")
address[:zip] = read_value("Zip?")
address[:country] = read_value("Country?", "US")
address[:phone] = read_value("Phone?")

weight = read_value("Weight (lbs)? ", "1.0")

from_address = EasyPost::Address.create(from_address)
to_address = EasyPost::Address.create(address)

parcel = EasyPost::Parcel.create(
  width: 12.5,
  length: 12.5,
  height: 0.75,
  weight: weight.to_f
)

# customs_item = EasyPost::CustomsItem.create(
#   description: 'EasyPost T-shirts',
#   quantity: 2,
#   value: 23.56,
#   weight: 33,
#   origin_country: 'us',
#   hs_tariff_number: 123456
# )
# customs_info = EasyPost::CustomsInfo.create(
#   integrated_form_type: 'form_2976',
#   customs_certify: true,
#   customs_signer: 'Dr. Pepper',
#   contents_type: 'gift',
#   contents_explanation: '', # only required when contents_type: 'other'
#   eel_pfc: 'NOEEI 30.37(a)',
#   non_delivery_option: 'abandon',
#   restriction_type: 'none',
#   restriction_comments: '',
#   customs_items: [customs_item]
# )

shipment = EasyPost::Shipment.create(
  to_address: to_address,
  from_address: from_address,
  parcel: parcel,
  options: {
    special_rates_eligibility: "USPS.MEDIAMAIL"
  },
  # customs_info: customs_info
)

media_rate = shipment[:rates].detect do |rate|
  rate[:service] == "MediaMail"
end

abort "No MEDIA MAIL rate" unless media_rate

sleep 1

shipment.buy(rate: media_rate)
puts "Bought label: #{shipment.postage_label.label_url}"
