# coding: utf-8
require 'spec_helper'
include Factories

describe String do
  # Sets a collection of image URLs to be used in the following tests
  let(:images) { urls[:images] }

  # 
  # String#find_url
  # 

  describe '#find_url' do
    let(:sample_urls) { urls[:misc].map { |u| u[1] } }
    let(:str)         { "Awesome sites: #{sample_urls.join ' and '}" }

    it 'matches the first URL in the String by default' do
      str.send(:find_url).should eq(sample_urls[0])
    end

    it 'matches the second URL in the String (https)' do
      str.send(:find_url, 1).should eq(sample_urls[1])
    end

    it 'matches the third URL in the String (www)' do
      str.send(:find_url, 2).should eq(sample_urls[2])
    end

    context 'when no URL is matched' do
      it 'returns nil' do
        'Lorem ipsum dolor.'.send(:find_url).should be_nil
      end

      it 'returns nil (no presence of http|https|ftp|www)' do
        'Check this out: google.com'.send(:find_url).should be_nil
      end
    end 
  end

  # 
  # String#check_img_ext
  # 

  describe '#check_img_ext' do
    let(:img)  { images[:jpg].sample }
    let(:imgs) { images.map { |i| i[1] }.flatten }
    let(:checked) do
      {
        str:   ''.send(:check_img_ext, img),
        array: ''.send(:check_img_ext, imgs), 
        jpg:   ''.send(:check_img_ext, imgs, [:jpg, :jpeg]),
        png:   ''.send(:check_img_ext, imgs, :png),
        gif:   ''.send(:check_img_ext, imgs, 'gif')
      }
    end
    
    context 'when no arument is passed' do
      it { expect { ''.send(:check_img_ext) }.to raise_error(ArgumentError) }
    end

    context 'when only the first argument is defined' do
      it 'allows a String as argument' do
        checked[:str].should have(1).item
      end
      
      it 'allows an Array as argument' do
        checked[:jpg].should have(3).item
      end
      
      it 'allows all the image extensions by default' do
        checked[:array].should have(9).item
      end
    end

    context 'when the two arguments are defined' do
      it 'allows a Symbol as the second argument' do
        checked[:png].should have(3).item
      end

      it 'allows a String as the second argument' do
        checked[:gif].should have(3).item
      end

      it 'allows an Array as the second argument' do
        checked[:jpg].should have(3).item
      end
      
      it 'returns an Array with only image types allowed' do
        checked[:jpg].should have(3).item
        checked[:png].should have(3).item
        checked[:gif].should have(3).item
      end
    end

    context 'when no image is found/allowed' do
      it 'returns an empty Array' do
      end
    end

    it 'always returns an Array' do
      checked.each { |c| c[1].is_a?(Array).should be_true }
    end
  end


  # 
  # String#sf_regex
  # 

  describe '#sf_regex' do
    context 'when it needs a regex to match any kind of URL' do
      subject { ''.send(:sf_regex, :url) }

      it { should match(urls[:misc][:http])  }
      it { should match(urls[:misc][:https]) }
      it { should match(urls[:misc][:ftp])   }
      it { should match(urls[:misc][:www])   }
    end

    context 'when it needs a regex to match only image URLs' do
      subject { ''.send(:sf_regex, :image) }

      it { should match(urls[:images][:jpg].sample) }
      it { should match(urls[:images][:png].sample) }
      it { should match(urls[:images][:gif].sample) }
    end    
  end

  # 
  # String#img_regex
  # 

  describe '#img_regex' do
    let(:img_regexes) { urls[:regexes][:image] }
        
    context 'when no argument is passed' do
      subject(:regex) { ''.send(:img_regex) }
      
      it 'returns a regex that matches all image extensions' do
        regex.should eq(img_regexes[:all])
      end
      
      it 'matches all image extensions' do
        [:jpg, :png, :gif].each { |ext| images[ext].sample.should match(regex) }
      end
    end

    context 'when only jpg|jpeg is allowed' do
      subject(:regex) { ''.send(:img_regex, [:jpg, :jpeg]) }

      it 'returns a regex that matches only jpg|jpeg images' do
        regex.should eq(img_regexes[:jpg])
      end

      it 'matches only the defined extension' do
        regex.should match(images[:jpg].sample)
      end

      it %q{doesn't match any other extension} do
        regex.should_not match(images[:png].sample)
        regex.should_not match(images[:gif].sample)
      end
    end

    context 'when only png is allowed' do
      subject(:regex) { ''.send(:img_regex, :png) }

      it 'returns a regex that matches only png images' do
        regex.should eq(img_regexes[:png])
      end

      it 'matches only the defined extension' do
        regex.should match(images[:png].sample)
      end

      it %q{doesn't match any other extension} do
        regex.should_not match(images[:jpg].sample)
        regex.should_not match(images[:gif].sample)
      end
    end

    context 'when only gif (argh!) is allowed' do
      subject(:regex) { ''.send(:img_regex, :gif) }

      it 'returns a regex that matches only gif images' do
        regex.should eq(img_regexes[:gif])
      end

      it 'matches only the defined extension' do
        regex.should match(images[:gif].sample)
      end

      it %q{doesn't match any other extension} do
        regex.should_not match(images[:jpg].sample)
        regex.should_not match(images[:png].sample)
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
    # it %q{can return the "reply_to" email}
    # it %q{can return the page's author}
  end
end
