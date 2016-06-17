namespace :make_puzzle do

  desc "パズルを生成する"
  task puzzle: :environment do
    all_word = Word.all
    all_word.each do |w|
      w.is_used = false
    end

    @goal = []
    def set_word(temp,no)
      white_count = White.where(temp_id:temp).count
      if no < white_count
        kana_length = White.find_by(temp_id:temp, no: no).length
        words = Word.where(length:kana_length, is_used: false)

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
            if set_word(temp,no+1)
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

    end # def end

    set_word(2,0)
    @goal.each do |goal|
      puts goal.kana
      puts Tweet.find_by(tweet_id:goal.tweet_id).text
    end


  end


end
