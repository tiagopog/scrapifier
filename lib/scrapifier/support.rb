module Scrapifier
  module Support
    SF_REGEXES = {
      url:      /\b((((ht|f)tp[s]?:\/\/)|([a-z0-9]+\.))+(?<!@)([a-z0-9\_\-]+)(\.[a-z]+)+([\?\/\:][a-z0-9_=%&@\?\.\/\-\:\#\(\)]+)?\/?)/i,
      protocol: /((ht|f)tp[s]?)/i,
      img:      /(^http{1}[s]?:\/\/([w]{3}\.)?.+\.(jpg|jpeg|png|gif)(\?.+)?$)/i
    }
  end
end