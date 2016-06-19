namespace :make_puzzle do

  desc "パズルを生成する"
  task puzzle: :environment do
    all_word = Word.all
    all_word.each do |w|
      w.is_used = false
      w.save
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

  desc "初期化とか"
  task answers: :environment do
    temp = 1
    @goal=["トカイ","トクラ","イナカ","ラッカ"]

    @question = []
    @answer = []
    size = Temp.find(temp)
    array = []
    size.width.times{
      array.push("")
    }
    size.height.times{
      @question.push(array.dup)
      @answer.push(array.dup)
    }

    whites = White.where(temp_id:temp)
    whites.each do | white |
      if @question[white.row][white.column] != ""
        @question[white.row][white.column] +=  ","
      end
      @question[white.row][white.column] += white.no.to_s
    end

    blacks = Black.where(temp_id:temp)
    blacks.each do | black |
      @question[black.row][black.column] = "*"
    end

    whites.each do | white |
      count = 0
      white.length.times{
        if white.horizonal
          @answer[white.row][white.column + count] = @goal[white.no][count]
        else
          @answer[white.row + count][white.column] = @goal[white.no][count]
        end
        count += 1
      }
    end

    @hint_v = []
    @hint_h = []

    whites.each do | white |
      if white.horizonal
        @hint_h.push([white.no, Tweet.find_by(tweet_id:@goal[white.no].tweet_id)])
      else
        @hint_v.push([white.no, Tweet.find_by(tweet_id:@goal[white.no].tweet_id)])
      end
    end

    puts @hint_h
    puts "*******"
    puts @hint_v

  end

end
