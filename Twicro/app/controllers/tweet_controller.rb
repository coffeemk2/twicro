require "twitter"

class TweetController < ApplicationController
  def input
  end

  def show
    user = params["q"]

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "8DLtV8xehV2S7jXjwHCN5a56B"
      config.consumer_secret     = "MvvQRKSn2TnglCF4E0NDWcQynzkdfrP2f8pamuG0ZYbkrmVoCx"
      config.access_token        = "250649547-hf8OjfuC2cyY9KEgyjmKMuWnH2jrHedy6KvKjEdH"
      config.access_token_secret = "p6Eqdangk13dFbYDfPdW8Yym1DvKInMQ2h2Bl5BE49n5B"
    end


    nm = Natto::MeCab.new(dicdir: "/usr/local/lib/mecab/dic/mecab-ipadic-neologd")
    # nm = Natto::MeCab.new(dicdir: "/usr/local/lib/mecab/dic/mecab-ipadic-neologd",node_format: '%m,%f[1],%f[7]')
    # nm = Natto::MeCab.new('-F%m,\s%f[0],\s%s \n')

    def collect_with_max_id(collection=[], max_id=nil, &block)
      response = yield(max_id)
      collection += response
      response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
    end

    def client.get_all_tweets(user)
      collect_with_max_id do |max_id|
        options = {count: 200, include_rts: false, exclude_replies: false}
        options[:max_id] = max_id unless max_id.nil?
        user_timeline(user, options)
      end
    end

    # @tweets = client.get_all_tweets(user)
    @tweets = timeline(user)

    @tweets.each do |tweet|

      # 正規表現
      target = tweet.text.dup
      target = target.gsub(/https?:\/\/[\S]+/,"")
      target = target.gsub(/\@\w+\s/,"")
      target = target.gsub(/amp/,"")

      nm.parse(target) do |text|
        if text.feature.include?("固有名詞")
          yomi = text.feature.dup.slice(/(.*,){6}/,1)
          yomi = yomi.delete(",")
          if(yomi != "*")
            puts yomi
          end
        end
      end
    end

    puts nm.options

  end

  private
    def timeline(user)
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "8DLtV8xehV2S7jXjwHCN5a56B"
        config.consumer_secret     = "MvvQRKSn2TnglCF4E0NDWcQynzkdfrP2f8pamuG0ZYbkrmVoCx"
        config.access_token        = "250649547-hf8OjfuC2cyY9KEgyjmKMuWnH2jrHedy6KvKjEdH"
        config.access_token_secret = "p6Eqdangk13dFbYDfPdW8Yym1DvKInMQ2h2Bl5BE49n5B"
      end
      options = {count: 200, include_rts: false, exclude_replies: false}
      client.user_timeline(user,options)
    end
end
