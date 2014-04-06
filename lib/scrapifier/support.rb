module Scrapifier
  module Support
    private
      # Filters images returning those with the allowed extentions.
      # 
      # Example:
      #   >> sf_check_img_ext('http://source.com/image.gif', :jpg)
      #   => []
      #   >> sf_check_img_ext(['http://source.com/image.gif', 'http://source.com/image.jpg'], [:jpg, :png])
      #   => ['http://source.com/image.jpg']
      # Arguments:
      #   images: (String or Array)
      #     - Images which will be checked.
      #   allowed: (String, Symbol or Array)
      #     - Allowed types of image extension.
      
      def sf_check_img_ext(images, allowed = [])
        allowed ||= []
        if images.is_a?(String)
          images = images.split
        elsif !images.is_a?(Array)
          images = []
        end
        images.select { |i| i =~ sf_regex(:image, allowed) }
      end

      # Selects regexes for URIs, protocols and image extensions.
      # 
      # Example:
      #   >> sf_regex(:uri)
      #   => /\b((((ht|f)tp[s]?:\/\/)|([a-z0-9]+\.))+(?<!@)([a-z0-9\_\-]+)(\.[a-z]+)+([\?\/\:][a-z0-9_=%&@\?\.\/\-\:\#\(\)]+)?\/?)/i,
      #   >> sf_regex(:image, :jpg)
      #   => /(^http{1}[s]?:\/\/([w]{3}\.)?.+\.(jpg)(\?.+)?$)/i
      # Arguments:
      #   type: (Symbol or String)
      #     - Regex type.
      #   args: (*)
      #     - Anything.

      def sf_regex(type, *args)
        type = type.to_sym unless type.is_a? Symbol
        if type == :image
          sf_img_regex args.flatten
        else
          regexes = {
            uri:      /\b((((ht|f)tp[s]?:\/\/)|([a-z0-9]+\.))+(?<!@)([a-z0-9\_\-]+)(\.[a-z]+)+([\?\/\:][a-z0-9_=%&@\?\.\/\-\:\#\(\)]+)?\/?)/i,
            protocol: /((ht|f)tp[s]?)/i
          }
          regexes[type]
        end
      end

      # Builds image regexes according to the required extensions.
      # 
      # Example:
      #   >> sf_img_regex
      #   => /(^http{1}[s]?:\/\/([w]{3}\.)?.+\.(jpg|jpeg|png|gif)(\?.+)?$)/i
      #   >> sf_img_regex([:jpg, :png])
      #   => /(^http{1}[s]?:\/\/([w]{3}\.)?.+\.(jpg|png)(\?.+)?$)/i
      # Arguments:
      #   exts: (Array)
      #     - Image extensions which will be included in the regex.
      
      def sf_img_regex(exts = [])
        exts = [exts].flatten unless exts.is_a?(Array)
        if exts.nil? or exts.empty?
          exts = %w(jpg jpeg png gif)
        elsif exts.include?(:jpg) and !exts.include?(:jpeg)
          exts.push :jpeg
        end  
        eval "/(^http{1}[s]?:\\/\\/([w]{3}\\.)?.+\\.(#{exts.join('|')})(\\?.+)?$)/i"
      end

      # Collection of paths used to get content from HTML tags via Node#xpath method.
      # See more: http://nokogiri.org/tutorials/searching_a_xml_html_document.html
      #
      # Example:
      #   >> sf_paths[:title]
      #   => '//meta[@property = "og:title"]/@content | //meta[@name = "title"]/@content | //meta[@name = "Title"]/@content | //title | //h1'
  
      def sf_paths
        {
          title:       '//meta[@property = "og:title"]/@content | //meta[@name = "title"]/@content | //meta[@name = "Title"]/@content | //title | //h1',
          description: '//meta[@property = "og:description"]/@content | //meta[@name = "description"]/@content | //meta[@name = "Description"]/@content | //h1 | //h3 | //p | //span | //font',
          image:       '//meta[@property = "og:image"]/@content | //link[@rel = "image_src"]/@href | //meta[@itemprop = "image"]/@content | //div[@id = "logo"]/img/@src | //a[@id = "logo"]/img/@src | //div[@class = "logo"]/img/@src | //a[@class = "logo"]/img/@src | //a//img[@width]/@src | //img[@width]/@src | //a//img[@height]/@src | //img[@height]/@src | //a//img/@src | //span//img/@src' 
        }
      end

      def sf_fix_imgs(imgs, uri, exts = [])
        sf_check_img_ext(imgs.map do |img|
          img = img.to_s 
          img = sf_fix_protocol(img, sf_domain(uri)) unless img =~ sf_regex(:protocol)
          img if (img =~ sf_regex(:image))
        end.compact, exts)
      end

      def sf_fix_protocol(str, domain)
        if str =~ /^\/\/[^\/]+/
          'http:' << str
        else
          "http://#{domain}#{'/' if str =~ /^\/[^\/]+/}#{str}" 
        end    
      end

      def sf_domain(uri)
        (uri.split('/')[2] rescue '')
      end
  end
end