# coding: utf-8
require 'nokogiri'
require 'open-uri'
require 'scrapifier/support'

module Scrapifier
  # Methods which will be included into the String class.
  module Methods
    include Scrapifier::Support

    # Get metadata from an URI using the screen scraping technique.
    #
    # Example:
    #   >> 'Wow! What an awesome site: http://adtangerine.com!'.scrapify
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
    #   options: (Hash)
    #     - which: (Integer)
    #         Which URI in the String will be used. It starts from 0 to N.
    #     - images: (Symbol or Array)
    #         Image extensions which are allowed to be returned as result.
    def scrapify(options = {})
      uri, meta = find_uri(options[:which]), {}
      return meta if uri.nil?

      if !(uri =~ sf_regex(:image))
        meta = sf_eval_uri(uri, options[:images])
      elsif !sf_check_img_ext(uri, options[:images]).empty?
        %i(title description uri images).each { |k| meta[k] = uri }
      end

      meta
    end

    # Find URIs in the String.
    #
    # Example:
    #   >> 'Wow! What an awesome site: http://adtangerine.com!'.find_uri
    #   => 'http://adtangerine.com'
    #   >> 'Very cool: http://adtangerine.com and www.twitflink.com'.find_uri 1
    #   => 'www.twitflink.com'
    # Arguments:
    #   which: (Integer)
    #     - Which URI in the String: first (0), second (1) and so on.
    def find_uri(which = 0)
      which = scan(sf_regex(:uri))[which.to_i][0]
      which =~ sf_regex(:protocol) ? which : "http://#{which}"
    rescue NoMethodError
      nil
    end
  end
end
