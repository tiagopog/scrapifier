module Scrapifier
  module Support
    # TODO: remove this
    SF_REGEXES = {
      url:      /\b((((ht|f)tp[s]?:\/\/)|([a-z0-9]+\.))+(?<!@)([a-z0-9\_\-]+)(\.[a-z]+)+([\?\/\:][a-z0-9_=%&@\?\.\/\-\:\#\(\)]+)?\/?)/i,
      protocol: /((ht|f)tp[s]?)/i,
      img:      /(^http{1}[s]?:\/\/([w]{3}\.)?.+\.(jpg|jpeg|png|gif)(\?.+)?$)/i
    }

    private
      def scpf_regex(type, *args)
        type = type.to_sym unless type.is_a? Symbol
        if type == :img
          img_regex args
        else
          regexes = {
            url:      /\b((((ht|f)tp[s]?:\/\/)|([a-z0-9]+\.))+(?<!@)([a-z0-9\_\-]+)(\.[a-z]+)+([\?\/\:][a-z0-9_=%&@\?\.\/\-\:\#\(\)]+)?\/?)/i,
            protocol: /((ht|f)tp[s]?)/i
          }
          regexes[type]
        end
      end

      def img_regex(exts = [])
        if exts.empty?
          exts = %w(jpg jpeg png gif) 
        elsif !exts.is_a? Array
          exts = exts.to_s.split 
        end
        eval "/(^http{1}[s]?:\\/\\/([w]{3}\\.)?.+\\.(#{exts.join('|')})(\\?.+)?$)/i"
      end      
  end
end