# coding: utf-8
require 'nokogiri'
require 'open-uri'
require 'scrapifier/support'

module Scrapifier
  module Methods
    include Scrapifier::Support

    def scrapify(options = {})
      meta, url = {}, find_url(options[:which])

      # First checks wheter the URL is requesting an image
      if url =~ sf_regex(:image)
         meta[:title]  = meta[:description] = meta[:url] = url
         meta[:images] = check_img_ext(url, [:jpg]) # unless !options[:allow_gif] and url =~ /\.gif$/i
      elsif !url.nil?
        begin
          opened_url   = open(url)
          doc          = Nokogiri::HTML(opened_url.read)  
          doc.encoding = 'utf-8'
          # meta = doc
        rescue 
          meta = {} unless meta.is_a? Hash
        end
      end

      meta
    end

    # Looks for URLs in the String.
    # 
    # Example:
    #   >> 'Wow! What an awesome site: http://adtangerine.com!'.find_url
    #   => 'http://adtangerine.com'
    #   >> 'Wow! What an awesome sites: http://adtangerine.com and www.twitflink.com'.find_url 1
    #   => 'www.twitflink.com'
    # Arguments:
    #   which: (Integer)
    #     - Which URL in the String: first (0), second (1) and so on.
    
    def find_url(which = 0)
      which ||= which.to_i
      self.scan(sf_regex(:url))[which][0] rescue nil
    end
  end
end
