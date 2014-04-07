# coding: utf-8
require 'nokogiri'
require 'open-uri'
require 'scrapifier/support'

module Scrapifier
  module Methods
    include Scrapifier::Support

    # Gets meta data from an URI using the screen scraping technique.
    # 
    # Example:
    #   >> 'Wow! What an awesome site: http://adtangerine.com!'.scrapify
    #   => {
    #        :title => "AdTangerine | Advertising Platform for Social Media",
    #        :description => "AdTangerine is an advertising platform that uses the tangerine as a virtual currency...",
    #        :images => ["http://adtangerine.com/assets/logo_adt_og.png", "http://adtangerine.com/assets/logo_adt_og.png],
    #        :uri => "http://adtangerine.com"
    #      }
    # Arguments:
    #   options: (Hash)
    #     - which: (Integer) Indicates which URI in the String will be used. It starts from 0 to N.
    #     - images: (Symbol or Array) Indicates the image extensions which are allowed to be returned as result.

    def scrapify(options = {})
      meta, uri = {}, find_uri(options[:which])
      
      begin
        if uri.nil?
          raise  
        elsif uri =~ sf_regex(:image)
          uri = (sf_check_img_ext(uri, options[:images])[0] rescue [])
          raise if uri.empty?
          [:title, :description, :uri, :images].each { |key| meta[key] = uri }
        else
          doc          = Nokogiri::HTML(open(uri).read)  
          doc.encoding = 'utf-8'
          
          [:title, :description].each do |key| 
            meta[key] = (doc.xpath(sf_paths[key])[0].text rescue '-')
          end

          meta[:images] = sf_fix_imgs(doc.xpath(sf_paths[:image]), uri, options[:images])
          meta[:uri]    = uri
        end
      rescue 
        meta = {}
      end

      meta
    end

    # Looks for URIs in the String.
    # 
    # Example:
    #   >> 'Wow! What an awesome site: http://adtangerine.com!'.find_uri
    #   => 'http://adtangerine.com'
    #   >> 'Wow! What an awesome sites: http://adtangerine.com and www.twitflink.com'.find_uri 1
    #   => 'www.twitflink.com'
    # Arguments:
    #   which: (Integer)
    #     - Which URI in the String: first (0), second (1) and so on.
    
    def find_uri(which = 0)
      which ||= which.to_i
      which = self.scan(sf_regex(:uri))[which][0] rescue nil
      (which.nil? or which =~ sf_regex(:protocol)) ? which : 'http://' << which
    end
  end
end
