module Factories
  private
    def sf_samples
      {
        misc: {
          http:  'http://adtangerine.com',
          https: 'https://rubygems.org/gems/string_awesome',
          ftp:   'ftp://ftpserver.com',
          www:   'www.twitflink.com'
        },
        images: {
          jpg: [
            'http://jlcauvin.com/wp-content/uploads/2013/09/heisenberg-breaking-bad.jpg',
            'https://www.foobar.com/awesome_image.jpeg?foo=bar&bar=foo',
            'http://foobar.com.br/nice-image.jpg'
          ],
          png: [
            'http://www.faniq.com/images/blog/58389e481aee9c5abbf49ff0a263f3ca.png',
            'https://foobar.br/awesome_image.png',
            'https://bar.foobar.br/foo/var/image.png?foo=bar',
          ],
          gif: [
            'http://31.media.tumblr.com/6eec77e355fe50bae424291fd8c58622/tumblr_me7ucl8kO61rf089no1_500.gif',
            'http://foobar.com/ugly_image.gif',
            'https://bar.foobar.br/foo/var/stop_using.gif?foo=bar'
          ]
        },
        regexes: {
          image: {
            all: /(^http{1}[s]?:\/\/([w]{3}\.)?.+\.(jpg|jpeg|png|gif)(\?.+)?$)/i,
            jpg: /(^http{1}[s]?:\/\/([w]{3}\.)?.+\.(jpg|jpeg)(\?.+)?$)/i,
            png: /(^http{1}[s]?:\/\/([w]{3}\.)?.+\.(png)(\?.+)?$)/i,
            gif: /(^http{1}[s]?:\/\/([w]{3}\.)?.+\.(gif)(\?.+)?$)/i
          },
          uri:      /\b((((ht|f)tp[s]?:\/\/)|([a-z0-9]+\.))+(?<!@)([a-z0-9\_\-]+)(\.[a-z]+)+([\?\/\:][a-z0-9_=%&@\?\.\/\-\:\#\(\)]+)?\/?)/i,
          protocol: /((ht|f)tp[s]?)/i
        }
      }
    end
end