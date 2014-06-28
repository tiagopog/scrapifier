# coding: utf-8
module Scrapifier
  # Collection of all XPaths which are used to find
  # the nodes within the parsed HTML doc.
  module XPath
    def sf_title_xpath
      <<-END.gsub(/^\s+\|/, '')
        |//meta[@property="og:title"]/@content|
        |//meta[@name="title"]/@content|
        |//meta[@name="Title"]/@content|
        |//title|//h1
      END
    end

    def sf_desc_xpath
      <<-END.gsub(/^\s+\|/, '')
        |//meta[@property="og:description"]/@content|
        |//meta[@name="description"]/@content|
        |//meta[@name="Description"]/@content|
        |//h1|//h3|//p|//span|//font
      END
    end

    def sf_keywords_xpath
      <<-END.gsub(/^\s+\|/, '')
        |//meta[@name="keywords"]/@content|
        |//meta[@name="Keywords"]/@content|
        |//meta[@property="og:type"]/@content
      END
    end

    def sf_lang_xpath
      <<-END.gsub(/^\s+\|/, '')
        |//html/@lang|
        |//meta[@property="og:locale"]/@content|
        |//meta[@http-equiv="content-language"]/@content
      END
    end

    def sf_encode_xpath
      <<-END.gsub(/^\s+\|/, '')
        |//meta/@charset|
        |//meta[@http-equiv="content-type"]/@content
      END
    end

    def sf_reply_to_xpath
      <<-END.gsub(/^\s+\|/, '')
        |//meta[@name="reply_to"]/@content
      END
    end

    def sf_author_xpath
      <<-END.gsub(/^\s+\|/, '')
        |//meta[@name="author"]/@content|
        |//meta[@name="Author"]/@content|
        |//meta[@name="reply_to"]/@content
      END
    end

    def sf_img_xpath
      <<-END.gsub(/^\s+\|/, '')
        |//meta[@property="og:image"]/@content|
        |//link[@rel="image_src"]/@href|
        |//meta[@itemprop="image"]/@content|
        |//div[@id="logo"]/img/@src|//a[@id="logo"]/img/@src|
        |//div[@class="logo"]/img/@src|//a[@class="logo"]/img/@src|
        |//a//img[@width]/@src|//img[@width]/@src|
        |//a//img[@height]/@src|//img[@height]/@src|
        |//a//img/@src|//span//img/@src|//img/@src
      END
    end
  end
end
