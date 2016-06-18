require "twitter"

class TweetController < ApplicationController
  def input
  end

  def show
    # DB初期化
    # Word.delete_all
    # Tweet.delete_all

    if Word.count == 0
      uid_max = 0
    else
      uid_max = Word.maximum('uid')
    end

    uid = uid_max + 1

    user = params["q"]

    # client = Twitter::REST::Client.new do |config|
    #   config.consumer_key        = "8DLtV8xehV2S7jXjwHCN5a56B"
    #   config.consumer_secret     = "MvvQRKSn2TnglCF4E0NDWcQynzkdfrP2f8pamuG0ZYbkrmVoCx"
    #   config.access_token        = "250649547-hf8OjfuC2cyY9KEgyjmKMuWnH2jrHedy6KvKjEdH"
    #   config.access_token_secret = "p6Eqdangk13dFbYDfPdW8Yym1DvKInMQ2h2Bl5BE49n5B"
    # end


    nm = Natto::MeCab.new(dicdir: "/usr/local/lib/mecab/dic/mecab-ipadic-neologd")
    # nm = Natto::MeCab.new(dicdir: "/usr/local/lib/mecab/dic/mecab-ipadic-neologd",node_format: '%m,%f[1],%f[7]')
    # nm = Natto::MeCab.new('-F%m,\s%f[0],\s%s \n')

    # @tweets = client.get_all_tweets(user)
    # @tweets = timeline(user)
    tweets = get_1000_tweets(user)

    tweets.each do |tweet|

      # 正規表現
      target = tweet.text.dup
      target = target.gsub(/https?:\/\/[\S]+/,"")
      target = target.gsub(/\@\.+\s/,"")
      target = target.gsub(/amp/,"")

      nm.parse(target) do |text|
        if text.feature.include?("固有名詞")
          yomi = text.feature.dup.slice(/(.*,){6}/,1)
          yomi = yomi.delete(",")

          if yomi != "*"
            Word.create(
              uid: uid,
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
        uid: uid,
        tweet_id: tweet.id,
        text: tweet.text
      )
    end # tweet end

    all_word = Word.where(uid: uid)
    all_word.each do |w|
      w.is_used = false
      w.save
    end

    @goal = []
    def set_word(temp,no,uid)
      white_count = White.where(temp_id:temp).count
      if no < white_count
        kana_length = White.find_by(temp_id:temp, no: no).length
        words = Word.where(uid:uid, length:kana_length, is_used: false)

        words.each do |word|
          # 条件
          condition = false
          relations = Relation.where(temp_id:temp, no2:no)
          if relations == []
            condition = true
          else
            condition = true
            relations.each do |relation|

              if word.kana[relation.index2] != @goal[relation.no1].kana[relation.index1]
                condition = false
              end
            end
          end

          if condition
            @goal.push(word)
            word.is_used = true
            word.save
            if set_word(temp,no+1,uid)
              return true
            else
              pop_word = @goal.pop
              pop_word.is_used = false
              pop_word.save
            end
          end
        end

        return false # not match

      else # no else
        return true
      end # no end

    end # def set_word end

    temp = 2
    if set_word(temp,0,uid)
      @goal.each do |goal|
        puts goal.kana
        puts Tweet.find_by(tweet_id:goal.tweet_id).text
      end

      Word.where(uid:uid).delete_all
      Tweet.where(uid:uid).delete_all
    else
      Word.where(uid:uid).delete_all
      Tweet.where(uid:uid).delete_all

      redirect_to :action => "error"
    end
  end # def show end

  def answer
  end

  def error
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
