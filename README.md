# Scrapifier - The Ruby Screen Scraper

A very simple way to extract meta information from URIs using the screen scraping technique.

## Installation

Compatible with Ruby 1.9.3+

Add this line to your application's Gemfile:

    gem 'scrapifier'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scrapifier

## Usage

### String#scrapify

Finds an URI in the String an gets some meta information from it, like the page's title, description, images and the URI. All the data is returned in a well-formatted Hash.

#### Default usage.

``` ruby
'Wow! What an awesome site: http://adtangerine.com!'.scrapify
#=> {
	    :title => "AdTangerine | Advertising Platform for Social Media",
	    :description => "AdTangerine is an advertising platform that uses the tangerine as a virtual currency for advertisers and publishers in order to share content on social networks.",
	    :images => ["http://adtangerine.com/assets/logo_adt_og.png", "http://adtangerine.com/assets/logo_adt_og.png", "http://s3-us-west-2.amazonaws.com/adtangerine-prod/users/avatars/000/000/834/thumb/275747_1118382211_1929809351_n.jpg", "http://adtangerine.com/assets/foobar.gif"],
	    :uri => "http://adtangerine.com"
	  }
```

#### Allow only certain image types.

``` ruby
'Wow! What an awesome site: http://adtangerine.com!'.scrapify images: :jpg
#=> {
	    :title => "AdTangerine | Advertising Platform for Social Media",
	    :description => "AdTangerine is an advertising platform that uses the tangerine as a virtual currency for advertisers and publishers in order to share content on social networks.",
	    :images => ["http://s3-us-west-2.amazonaws.com/adtangerine-prod/users/avatars/000/000/834/thumb/275747_1118382211_1929809351_n.jpg"],
	    :uri => "http://adtangerine.com"
	  }

'Wow! What an awesome site: http://adtangerine.com!'.scrapify images: [:png, :gif]
#=> {
	    :title => "AdTangerine | Advertising Platform for Social Media",
	    :description => "AdTangerine is an advertising platform that uses the tangerine as a virtual currency for advertisers and publishers in order to share content on social networks.",
	    :images => ["http://adtangerine.com/assets/logo_adt_og.png", "http://adtangerine.com/assets/logo_adt_og.png", "http://adtangerine.com/assets/foobar.gif"],
	    :uri => "http://adtangerine.com"
	  }
```

#### Choose which URI you want it to be scraped.

``` ruby
'Check out these awesome sites: http://adtangerine.com and www.twitflink.com'.scrapify which: 1
#=> {
	    :title => "TwitFlink | Find a link!",
	    :description => "TwitFlink is a very simple searching tool that allows people to find out links tweeted by any user from Twitter.",
	     :images => ["http://www.twitflink.com//assets/tf_logo.png", "http://twitflink.com/assets/tf_logo.png"],
	    :uri => "http://www.twitflink.com"
	  }

'Check out these awesome sites: http://adtangerine.com and www.twitflink.com'.scrapify({ which: 0, images: :gif })
#=> {
	    :title => "AdTangerine | Advertising Platform for Social Media",
	    :description => "AdTangerine is an advertising platform that uses the tangerine as a virtual currency for advertisers and publishers in order to share content on social networks.",
	    :images => ["http://adtangerine.com/assets/foobar.gif"],
	    :uri => "http://adtangerine.com"
	  }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
