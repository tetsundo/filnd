class LinebotController < ApplicationController
  require 'line/bot' # gem 'line-bot-api'
  require 'json'
  require 'oauth'
  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery except: :callback

  def client
    @client ||=
      Line::Bot::Client.new do |config|
        config.channel_secret = ENV['LINE_CHANNEL_SECRET']
        config.channel_token = ENV['LINE_CHANNEL_TOKEN']
      end
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do
        'Bad Request'
      end
    end

    events = client.parse_events_from(body)

    # ここでlineに送られてきたイベントを検出している
    # messageのtext: 指定すると、返信する文字を決定することができる
    # event.message['text']で送られてきたメッセージを取得することができる
    events.each do |event|
      # 自動翻訳API設定
      translate_key = ENV["TRANSLATE_KEY"]
      translate_secret = ENV["TRANSLATE_SECRET"]
      url="https://mt-auto-minhon-mlt.ucri.jgn-x.jp/api/mt/generalNT_ja_en/"
      minnano_user_name="ndo"
      # 認証
      consumer = OAuth::Consumer.new(translate_key, translate_secret)
      endpoint = OAuth::AccessToken.new(consumer)

      #ここでLINEで送った文章を取得。空白はAPI通信の妨げになるので削除
      message = event.message['text'].gsub(' ', '')
      #messageの本文を翻訳APIにかける
      response = endpoint.post(url,{key: translate_key, type: 'json', name: minnano_user_name, text: message})
      results = JSON.parse(response.body)
      @genre = results['resultset']['result']['text']

      uri =
        URI.parse(
          'https://api.themoviedb.org/4/list/98595?api_key=1f561d8e34d516d682a4d6c713fc7072'
        )
      json = Net::HTTP.get(uri)
      results = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換
      movies = []
      if @genre == 'Christmas'
        results['total_pages'].to_i.times do |f|
          uri =
            URI.parse(
              "https://api.themoviedb.org/4/list/98595?api_key=1f561d8e34d516d682a4d6c713fc7072&page=#{
                f + 1
              }"
            )
          json = Net::HTTP.get(uri)
          results = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換
          movies += results['results']
        end
        lists = movies
      else
        results['total_pages'].to_i.times do |f|
          uri =
            URI.parse(
              "https://api.themoviedb.org/4/list/97643?api_key=1f561d8e34d516d682a4d6c713fc7072&page=#{
                f + 1
              }"
            )
          json = Net::HTTP.get(uri)
          results = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換
          movies += results['results']
        end
        genre_id = Film.genres[@genre]
        lists = movies.select { |x| x['genre_ids'].include?(genre_id.to_i) }
      end
      list = lists.sample # 任意のものを一つ選ぶ
      # listの詳細情報を取得する
      uri =
        URI.parse(
          "https://api.themoviedb.org/3/movie/#{
            list['id']
          }?api_key=1f561d8e34d516d682a4d6c713fc7072&append_to_response=videos"
        )
      json = Net::HTTP.get(uri)
      results = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換

      # 映画の情報
      if results['videos']['results'] != nil
        video =
          "https://www.youtube.com/embed/#{
            results['videos']['results'][0]['key']
          }" # 映画の予告動画のurlを送る
      else
        video = '見つかりませんでした'
      end
      movie_title = list['original_title'] # 映画のタイトル
      movie_score = list['vote_average'].to_s

      response =
        '【タイトル】' + movie_title + "\n" + '【ジャンル】' + @genre + "\n" +
          '【スコア】' + movie_score + "\n" + '【Youtube】' + video
      case event #case文　caseの値がwhenと一致する時にwhenの中の文章が実行される(switch文みたいなもの)
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = { type: 'text', text: response }
          client.reply_message(event['replyToken'], message)
        end
      end
    end

    head :ok
  end
end
