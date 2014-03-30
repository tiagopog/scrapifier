module Scrapifier
  module Support
    private
      # Filters images returning those with the allowed extentions.
      # 
      # Example:
      #   >> check_img_ext('http://source.com/image.gif', :jpg)
      #   => []
      #   >> check_img_ext(['http://source.com/image.gif', 'http://source.com/image.jpg'], [:jpg, :png])
      #   => ['http://source.com/image.jpg']
      # Arguments:
      #   images: (String or Array)
      #     - Images which will be checked.
      #   allowed: (String, Symbol or Array)
      #     - Allowed types of image extension.
      
      def check_img_ext(images, allowed = [])
        if images.is_a?(String)
          images = images.split
        elsif !images.is_a?(Array)
          images = []
        end
        images.select { |i| i =~ sf_regex(:image, allowed) }
      end

      # Selects regexes for URLs, protocols and image extensions.
      # 
      # Example:
      #   >> sf_regex(:url)
      #   => /\b((((ht|f)tp[s]?:\/\/)|([a-z0-9]+\.))+(?<!@)([a-z0-9\_\-]+)(\.[a-z]+)+([\?\/\:][a-z0-9_=%&@\?\.\/\-\:\#\(\)]+)?\/?)/i,
      #   >> sf_regex(:image, :jpg)
      #   => /(^http{1}[s]?:\/\/([w]{3}\.)?.+\.(jpg|jpeg)(\?.+)?$)/i
      # Arguments:
      #   type: (Symbol or String)
      #     - Regex type.
      #   args: (*)
      #     - Anything.

      def sf_regex(type, *args)
        type = type.to_sym unless type.is_a? Symbol
        if type == :image
          img_regex args
        else
          regexes = {
            url:      /\b((((ht|f)tp[s]?:\/\/)|([a-z0-9]+\.))+(?<!@)([a-z0-9\_\-]+)(\.[a-z]+)+([\?\/\:][a-z0-9_=%&@\?\.\/\-\:\#\(\)]+)?\/?)/i,
            protocol: /((ht|f)tp[s]?)/i
          }
          regexes[type]
        end
      end

      # Builds image regexes according to the required extensions.
      # 
      # Example:
      #   >> img_regex
      #   => /(^http{1}[s]?:\/\/([w]{3}\.)?.+\.(jpg|jpeg|png|gif)(\?.+)?$)/i
      #   >> img_regex([:jpg, :png])
      #   => /(^http{1}[s]?:\/\/([w]{3}\.)?.+\.(jpg|png)(\?.+)?$)/i
      # Arguments:
      #   exts: (Array)
      #     - Image extensions which will be included in the regex.
      
      def img_regex(exts = [])
        if exts.nil? or exts.empty?
          exts = %w(jpg jpeg png gif) 
        elsif !exts.is_a? Array
          exts = exts.to_s.split
        end
        eval "/(^http{1}[s]?:\\/\\/([w]{3}\\.)?.+\\.(#{exts.join('|')})(\\?.+)?$)/i"
      end      
  end
end