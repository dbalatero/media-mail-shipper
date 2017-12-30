# media-mail-shipper

This is a script that lets you buy postage labels for USPS Media Mail without
using stamps.com. I made this to make my Discogs mailings easier.

## Setup

Clone the repo. In the repo, make a file called `from_address.json`. This will
have:

```
{
  "company": "Your Name",
  "street1": "1234 Fake Street",
  "city": "Seattle",
  "state": "WA",
  "zip": "98102",
  "phone": "206-123-4567"
}
```

Sign up for EasyPost, and then export your API key:

```
export EASYPOST_API_KEY="..."
```

I use `envrc` to manage the ENV variables.

## Running the script

Once you have done setup, just run `./ship.rb` whenever you want to make a 
media label. It will prompt you for the to address on the command line.
