# coding: utf-8
require 'spec_helper'
include Factories

describe String do
  let(:images)  { sf_samples[:images] }
  let(:misc)    { sf_samples[:misc]   }
  let(:regexes) { sf_samples[:regexes] }
  
  # 
  # String#scrapify
  # 

  describe '#scrapify' do
    context 'when no URI is matched in the String' do
      subject { 'String without any URI.'.scrapify }
      
      it { should eq({}) }
    end

    context 'when the website was not found' do
      subject { 'Check out this http://someweirduri.com.br'.scrapify }
      
      it { should eq({}) }
    end

    context 'when an image URI is matched' do
      let(:jpg) { images[:jpg][0] }
      let(:png) { images[:png][0] }
      let(:gif) { images[:gif][0] }
      
      it 'sets the same value for :title, :description and :uri keys' do
        "Say my name: #{jpg}".scrapify.should include(title: jpg, description: jpg, uri: jpg)
      end

      it 'allows all the standard image extensions by default (even GIFs)' do
        "Smile GIF! Oh, wait... #{gif}".scrapify.should include(title: gif, description: gif, uri: gif)
      end
      
      it 'returns an empty Hash if the extension is not allowed' do
        "PNG is awesome! #{png}".scrapify(images: [:jpg]).should eq({})
      end
    end

    context 'when a website URI is matched in the String and a Hash is returned' do
      subject(:hash) { "Look this awesome site #{misc[:http]}".scrapify }
      
      it "includes a field with the site's title" do
        hash[:title].is_a?(String).should be true
        hash[:title].empty?.should be false
      end

      it "includes a field with the site's description" do
        hash[:description].is_a?(String).should be true
        hash[:description].empty?.should be false
      end

      it 'includes a field with the page URI' do
        hash[:uri].is_a?(String).should be true
        hash[:uri].empty?.should be false
        hash[:uri].should eq(misc[:http])
      end

      it "includes a field with image URIs from the site's head/body" do
        unless hash[:images].empty?
          hash[:images].is_a?(Array).should be true
          hash[:images].sample.should match(regexes[:image][:all])
        end
      end
    end
    
    it "includes a field with only the allowed types of image URIs from the site's head/body" do
      image = misc[:http].scrapify(images: :png)[:images].sample
      image.should match(regexes[:image][:png]) unless image.nil?
    end

    it "can choose the URI in the String to be scrapified" do
      hash = "Check out these awesome sites: #{misc[:http]} and #{misc[:www]}".scrapify(which: 1, images: :png)
      [:title, :description, :uri].each do |key|
        hash[key].is_a?(String).should be true
        hash[key].empty?.should be false
      end
      hash[:uri].should eq("http://#{misc[:www]}")
      hash[:images].sample.should match(regexes[:image][:png])
    end
  end

  # 
  # String#find_uri
  # 

  describe '#find_uri' do
    let(:sample_uris) { misc.map { |u| u[1] } }
    let(:str)         { "Awesome sites: #{sample_uris.join ' and '}" }

    it 'matches the first URI in the String by default' do
      str.send(:find_uri).should eq(sample_uris[0])
    end

    it 'matches the second URI in the String (https)' do
      str.send(:find_uri, 1).should eq(sample_uris[1])
    end

    it 'matches the third URI in the String (www)' do
      str.send(:find_uri, 2).should eq(sample_uris[2])
    end

    context 'when no URI is matched' do
      it 'returns nil' do
        'Lorem ipsum dolor.'.send(:find_uri).should be_nil
      end

      it 'returns nil (no presence of http|https|ftp|www)' do
        'Check this out: google.com'.send(:find_uri).should be_nil
      end
    end 
  end

  # 
  # String#sf_check_img_ext
  # 

  describe '#sf_check_img_ext' do
    let(:img)  { images[:jpg].sample }
    let(:imgs) { images.map { |i| i[1] }.flatten }
    let(:checked) do
      {
        str:   ''.send(:sf_check_img_ext, img),
        array: ''.send(:sf_check_img_ext, imgs), 
        jpg:   ''.send(:sf_check_img_ext, imgs, [:jpg]),
        png:   ''.send(:sf_check_img_ext, imgs, :png),
        gif:   ''.send(:sf_check_img_ext, imgs, 'gif')
      }
    end
    
    context 'when no arument is passed' do
      it { expect { ''.send(:sf_check_img_ext) }.to raise_error(ArgumentError) }
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
        [:jpg, :png, :gif].each { |ext| checked[ext].should have(3).item }
      end
    end

    context 'when no image is found/allowed' do
      it 'returns an empty Array' do
      end
    end

    it 'always returns an Array' do
      checked.each { |c| c[1].is_a?(Array).should be true }
    end
  end


  # 
  # String#sf_regex
  # 

  describe '#sf_regex' do
    context 'when it needs a regex to match any kind of URI' do
      subject { ''.send(:sf_regex, :uri) }

      [:http, :https, :ftp, :www].each do |p| 
        it { should match(misc[:http]) }
      end
    end

    context 'when it needs a regex to match only image uris' do
      subject { ''.send(:sf_regex, :image) }

      [:jpg, :png, :gif].each do |ext|
        it { should match(sf_samples[:images][ext].sample) }  
      end
    end    
  end

  # 
  # String#sf_img_regex
  # 

  describe '#sf_img_regex' do
    let(:img_regexes) { regexes[:image] }
        
    context 'when no argument is passed' do
      subject(:regex) { ''.send(:sf_img_regex) }
      
      it 'returns a regex that matches all image extensions' do
        regex.should eq(img_regexes[:all])
      end
      
      it 'matches all image extensions' do
        [:jpg, :png, :gif].each { |ext| images[ext].sample.should match(regex) }
      end
    end

    context 'when only jpg is allowed' do
      subject(:regex) { ''.send(:sf_img_regex, [:jpg]) }

      it 'returns a regex that matches only jpg images' do
        regex.should eq(img_regexes[:jpg])
      end

      it 'matches only the defined extension' do
        regex.should match(images[:jpg].sample)
      end

      it "doesn't match any other extension" do
        [:png, :gif].each { |ext| regex.should_not match(images[ext].sample) }
      end
    end

    context 'when only png is allowed' do
      subject(:regex) { ''.send(:sf_img_regex, :png) }

      it 'returns a regex that matches only png images' do
        regex.should eq(img_regexes[:png])
      end

      it 'matches only the defined extension' do
        regex.should match(images[:png].sample)
      end

      it "doesn't match any other extension" do
        [:jpg, :gif].each { |ext| regex.should_not match(images[ext].sample) }
      end
    end

    context 'when only gif (argh!) is allowed' do
      subject(:regex) { ''.send(:sf_img_regex, :gif) }

      it 'returns a regex that matches only gif images' do
        regex.should eq(img_regexes[:gif])
      end

      it 'matches only the defined extension' do
        regex.should match(images[:gif].sample)
      end

      it "doesn't match any other extension" do
        [:jpg, :png].each { |ext| regex.should_not match(images[ext].sample) }
      end
    end
  end
end
