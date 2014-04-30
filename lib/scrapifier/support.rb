module Scrapifier
  module Support
    module_function

    # Evaluate the URI's HTML document and get its metadata.
    #
    # Example:
    #   >> eval_uri('http://adtangerine.com', [:png])
    #   => {
    #        :title => "AdTangerine | Advertising Platform for Social Media",
    #        :description => "AdTangerine is an advertising platform that...",
    #        :images => [
    #          "http://adtangerine.com/assets/logo_adt_og.png",
    #          "http://adtangerine.com/assets/logo_adt_og.png
    #        ],
    #        :uri => "http://adtangerine.com"
    #      }
    # Arguments:
    #   uri: (String)
    #     - URI.
    #   imgs: (Array)
    #     - Allowed type of images.
    def sf_eval_uri(uri, imgs = [])
      doc = Nokogiri::HTML(open(uri).read)
      doc.encoding, meta = 'utf-8', { uri: uri }

      [:title, :description].each { |k| meta[k] = (doc.xpath(sf_paths[k])[0].text rescue '-') }
      meta[:images] = sf_fix_imgs(doc.xpath(sf_paths[:image]), uri, imgs)

      meta
    rescue SocketError
      {}
    end

    # Filter images returning those with the allowed extentions.
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

    # Select regexes for URIs, protocols and image extensions.
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

    # Build image regexes according to the required extensions.
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

    # Check and return only the valid image URIs.
    # 
    # Example:
    #   >>  sf_fix_imgs(['http://adtangerine.com/image.png', '/assets/image.jpg'], 'http://adtangerine.com', :jpg)
    #   => ['http://adtangerine/assets/image.jpg']
    # Arguments:
    #   imgs: (Array)
    #     - Image URIs got from the HTML doc.
    #   uri: (String)
    #     - Used as basis to the URIs that don't have any protocol/domain set. 
    #   exts: (Symbol or Array)
    #     -  Allowed image extesntions.
    def sf_fix_imgs(imgs, uri, exts = [])
      sf_check_img_ext(imgs.map do |img|
        img = img.to_s 
        img = sf_fix_protocol(img, sf_domain(uri)) unless img =~ sf_regex(:protocol)
        img if (img =~ sf_regex(:image))
      end.compact, exts)
    end

    # Fix image URIs that don't have a protocol/domain set.
    # 
    # Example:
    #   >> sf_fix_protocol('/assets/image.jpg', 'http://adtangerine.com')
    #   => 'http://adtangerine/assets/image.jpg'
    #   >> sf_fix_protocol('//s.ytimg.com/yts/img/youtub_img.png', 'https://youtube.com')
    #   => 'https://s.ytimg.com/yts/img/youtub_img.png'
    # Arguments:
    #   path: (String)
    #     - URI path having no protocol/domain set.
    #   domain: (String)
    #     - Domain that will be prepended into the path.
    def sf_fix_protocol(path, domain)
      if path =~ /^\/\/[^\/]+/
        'http:' << path
      else
         "http://#{domain}#{'/' unless path =~ /^\/[^\/]+/}#{path}" 
      end    
    end

    # Return the URI domain.
    # 
    # Example:
    #   >> sf_domain('http://adtangerine.com')
    #   => 'adtangerine.com'
    # Arguments:
    #   uri: (String)
    #     - URI.
    def sf_domain(uri)
      (uri.split('/')[2] rescue '')
    end
  end
end