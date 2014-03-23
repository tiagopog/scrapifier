# coding: utf-8
require 'spec_helper'
include Factories

describe String do
  # Sets a collection of image URLs to be used in the following tests
  let(:images) { urls[:images] }

  # 
  # String#matched_url
  # 

  describe '#matched_url' do
    let(:sample_urls) { urls[:misc] }
    let(:str)         { "Awesome sites: #{sample_urls.join ' and '}" }

    it 'matches the first URL in the String by default' do
      str.send(:matched_url).should eq(sample_urls[0])
    end

    it 'matches the second URL in the String (https)' do
      str.send(:matched_url, 1).should eq(sample_urls[1])
    end

    it 'matches the third URL in the String (www)' do
      str.send(:matched_url, 2).should eq(sample_urls[2])
    end

    context 'when no URL is matched' do
      it 'returns nil' do
        'Lorem ipsum dolor.'.send(:matched_url).should be_nil
      end

      it 'returns nil (no presence of http|https|ftp|www)' do
        'Check this out: google.com'.send(:matched_url).should be_nil
      end
    end 
  end

  # 
  # String#check_ext
  # 

  describe '#check_ext' do
    #before(:all) { images.call }
        
    it 'allows one or two arguments'

    it 'allows a String or Array as the first argument' 

    it 'allows a String, Symbol or Array as the second argument' 

    it 'not allows any kind of String other than URLs (http|https|ftp)'

    it 'allows all the extensions by default'

    it 'always returns an Array'

    it 'returns an Array containing only the allowed extensions'
  end

  # 
  # String#img_regex
  # 

  describe '#img_regex' do
    let(:img_regexes) { urls[:img_regexes] }
        
    context 'when no extensions are defined in the arguments' do
      subject(:regex) { ''.send(:img_regex) }
      
      it 'returns a regex to match all image extensions' do
        regex.should eq(img_regexes[:all])
      end
      
      it 'matches all image extensions' do
        [:jpg, :png, :gif].each { |ext| images[ext][[*0..2].sample].should match(regex) }
      end
    end

    context 'when only jpg|jpeg is allowed' do
      subject(:regex) { ''.send(:img_regex, [:jpg, :jpeg]) }

      it 'returns a regex to match images with this extension' do
        regex.should eq(img_regexes[:jpg])
      end
    end
  end

  # 
  # String#scrapify
  # 

  describe '#scrapify' do
    it %q{returns an empty Hash in case the String doesn't have any URL} do
      'String without any URL.'.scrapify.should eq({})
    end

    it %q{returns an empty Hash in case the URL doesn't match to any website} do
      'Check out this http://someweirdurl.com.br'.scrapify.should eq({})
    end

    it %q{returns the same URL in the :title, :description and :url keys when it's requesting an image} do
      url = 'http://jlcauvin.com/wp-content/uploads/2013/09/heisenberg-breaking-bad.jpg'
      "Say my name: #{url}".scrapify.should include(title: url, description: url, url: url)
    end

    it 'returns only the the allowed extensions when the URL is requesting an image' do      
    end

    it 'returns a Hash containing the page title'
    it 'returns a Hash containing the page description'
    it 'returns a Hash containing the page URL'
    it 'returns a Hash containing the document type'
    it %q{can return the "reply_to" email}
    it %q{can return the page's author}
  end
end
