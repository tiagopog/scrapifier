module Factories
  private
    def urls
      {
        misc: {
          http:  'http://adtangerine.com',
          https: 'https://rubygems.org/gems/string_awesome',
          ftp:   'ftp://ftpserver.com',
          www:   'www.twitflink.com'
        },
        images: {
          jpg: [
            'http://www.foobar.com/image.jpg',
            'https://www.foobar.com/awesome_image.jpg?foo=bar&bar=foo',
            'http://foobar.com.br/nice-image.jpeg'
          ],
          png: [
            'http://www.foobar.com.br/nice-image.png',
            'https://foobar.br/awesome_image.png',
            'https://bar.foobar.br/foo/var/image.png?foo=bar',
          ],
          gif: [
            'http://www.foobar.com/bad-image.gif',
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
          url:      /\b((((ht|f)tp[s]?:\/\/)|([a-z0-9]+\.))+(?<!@)([a-z0-9\_\-]+)(\.[a-z]+)+([\?\/\:][a-z0-9_=%&@\?\.\/\-\:\#\(\)]+)?\/?)/i,
          protocol: /((ht|f)tp[s]?)/i
        }
      }
    end
end