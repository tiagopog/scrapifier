# coding: utf-8
require 'spec_helper'

describe String do
  # 
  # String#scrapify
  # 
  
  describe '#_matched_url' do
    before(:all) do
      @urls = %w(http://adtangerine.com https://rubygems.org/gems/string_awesome www.twitflink.com)
      @str  = "Awesome sites: #{@urls.join ' and '}"
    end

    it 'should match the first URL in the String by default' do
      @str._matched_url.should eq(@urls[0])
    end

    it 'should match the second URL in the String (https)' do
      @str._matched_url(1).should eq(@urls[1])
    end

    it 'should match the third URL in the String (www)' do
      @str._matched_url(2).should eq(@urls[2])
    end

    it 'should returns nil when no URL is matched' do
      'Lorem ipsum dolor.'._matched_url.should be_nil
    end

    it 'should returns nil when no URL (http, https, ftp, www) is matched' do
      'Check this out: google.com'._matched_url.should be_nil
    end
  end

  describe '#scrapify' do
    it %q{should return an empty Hash in case the String doesn't have any URL} do
      'String without any URL.'.scrapify.should eq({})
    end

    it %q{should return an empty Hash in case the URL passed doesn't match to any website} do
      'Check out this http://someweirdurl.com.br'.scrapify.should eq({})
    end
    
    it %q{should return the URL of an image in the resulting Hash's :title, :description and :url keys} do
      url = 'http://jlcauvin.com/wp-content/uploads/2013/09/heisenberg-breaking-bad.jpg'
      "Say my name: #{url}".scrapify.should include(:title => url, description: url, url: url)
    end

    it 'should return only the the allowed extensions when the URL points to an image' do      
    end

    it 'should return a Hash containing the page title'
    it 'should return a Hash containing the page description'
    it 'should return a Hash containing the page URL'
    it 'should return a Hash containing the document type'
    it %q{may return the "reply_to" email}
    it %q{may return the page's author}
  end
end