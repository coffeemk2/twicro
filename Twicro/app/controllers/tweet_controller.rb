require "twitter"

class TweetController < ApplicationController
  def input
  end

  def show
    # DB初期化
    Word.delete_all
    Tweet.delete_all

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

    # @tweets = client.get_all_tweets(user)
    # @tweets = timeline(user)
    @tweets = get_1000_tweets(user)

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

          if yomi != "*"
            Word.create(
              surface: text.surface,
              kana: yomi,
              length: yomi.length,
              is_used: false,
              tweet_id: tweet.id
            )
          end # 読みあり end
        end # if 固有名詞 end
      end # parse end

      Tweet.create(
        tweet_id: tweet.id,
        text: tweet.text
      )

    end # tweet end

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

    def get_1000_tweets(user)
      tweets = []
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "8DLtV8xehV2S7jXjwHCN5a56B"
        config.consumer_secret     = "MvvQRKSn2TnglCF4E0NDWcQynzkdfrP2f8pamuG0ZYbkrmVoCx"
        config.access_token        = "250649547-hf8OjfuC2cyY9KEgyjmKMuWnH2jrHedy6KvKjEdH"
        config.access_token_secret = "p6Eqdangk13dFbYDfPdW8Yym1DvKInMQ2h2Bl5BE49n5B"
      end
      options = {count: 200, include_rts: false, exclude_replies: false}
      tweets.push(client.user_timeline(user,options))
      tweets = tweets.flatten
      max_id = tweets.last.id - 1
      4.times{
        options = {count: 200, include_rts: false, exclude_replies: false,max_id: max_id}
        tweets.push(client.user_timeline(user,options))
        tweets = tweets.flatten
        max_id = tweets.last.id - 1
      }
      tweets
    end

end
