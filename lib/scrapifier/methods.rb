# coding: utf-8
require 'nokogiri'
require 'open-uri'
require 'scrapifier/support'

module Scrapifier
  module Methods
    include Scrapifier::Support

    def scrapify(options = {})
      meta, url = {}, matched_url(options[:which])

      # Checks first wheter the URL is requesting an image
      if url =~ SF_REGEXES[:img]
         meta[:title]  = meta[:description] = meta[:url] = url
         meta[:images] = check_ext(url, [:jpg]) # unless !options[:allow_gif] and url =~ /\.gif$/i
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

    private
      def matched_url(which = 0)
        which ||= which.to_i
        self.scan(SF_REGEXES[:url])[which][0] rescue nil
      end

      def check_ext(images, allowed = [])
        # images
      end
  end
end
