# coding: utf-8
require 'nokogiri'
require 'open-uri'
require 'scrapifier/support'

module Scrapifier
  module Methods
    include Scrapifier::Support
    
    def scrapify(options = {})
      meta, url = {}, _matched_url(options[:which])
      
      if url =~ SF_REGEXES[:img]
         meta[:title] = meta[:description] = meta[:url] = url
        # meta[:image] = url unless !options[:allow_gif] and url =~ /\.gif$/i
      elsif !url.nil?
        opened_url   = open('http://adtangerine.com')
        doc          = Nokogiri::HTML(opened_url.read)  
        doc.encoding = 'utf-8'
        meta = doc
      end
      
      meta
    end

    def _matched_url(which = 0)
      which ||= which.to_i
      self.scan(SF_REGEXES[:url])[which][0] rescue nil
    end

  end
end
