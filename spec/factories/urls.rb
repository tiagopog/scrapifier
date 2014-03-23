module Factories
  private
    def urls
      {
        misc: [
          'http://adtangerine.com',
          'https://rubygems.org/gems/string_awesome',
          'www.twitflink.com'
        ],
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
        img_regexes: {
          all: /(^http{1}[s]?:\/\/([w]{3}\.)?.+\.(jpg|jpeg|png|gif)(\?.+)?$)/i,
          jpg: /(^http{1}[s]?:\/\/([w]{3}\.)?.+\.(jpg|jpeg)(\?.+)?$)/i,
          png: /(^http{1}[s]?:\/\/([w]{3}\.)?.+\.(png)(\?.+)?$)/i,
          gif: /(^http{1}[s]?:\/\/([w]{3}\.)?.+\.(gif)(\?.+)?$)/i
        }
      }
    end
end