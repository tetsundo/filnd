class LinebotController < ApplicationController
	require 'line/bot'	# gem 'line-bot-api'
	# callbackアクションのCSRFトークン認証を無効
	protect_from_forgery :except => [:callback]
	def client
		@client ||= Line::Bot::Client.new { |config|
			config.channel_secret = ENV["e27f25a17366cd741cd7e4ac2e796aaf"]
			config.channel_token = ENV["xZ1EnlRogLOjX6FzTN1WYT7q/pzqzneIR0j/FE1bhZO1dY4VrJj2/Bfha3UsAsLhG58SjXZWJqRO0+Pn/vOwPjXpQL0oQE6z0vhIzx61s69IuIAziobQKdXPj2zKoB6knOejwHxlpv68JzNM/wbXFwdB04t89/1O/w1cDnyilFU="]
		}
	end

	def callback
		body = request.body.read

		signature = request.env['HTTP_X_LINE_SIGNATURE']
		 unless client.validate_signature(body, signature)
		   error 400 do 'Bad Request' end
		 end

		events = client.parse_events_from(body)

		# ここでlineに送られてきたイベントを検出している
		# messageのtext: 指定すると、返信する文字を決定することができる
		# event.message['text']で送られてきたメッセージを取得することができる
		events.each {|event|
		    uri = URI.parse("https://api.themoviedb.org/4/list/97643?api_key=1f561d8e34d516d682a4d6c713fc7072")
		    json = Net::HTTP.get(uri) #NET::HTTPを利用してAPOを叩く
		    results = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換
		    movies = []
		  	results['total_pages'].to_i.times do |f|
		    	uri = URI.parse("https://api.themoviedb.org/4/list/97643?api_key=1f561d8e34d516d682a4d6c713fc7072&page=#{f+1}")
		    	json = Net::HTTP.get(uri) #NET::HTTPを利用してAPOを叩く
		    	results = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換
		    	movies += results['results']
		    end
		    @genre = event.message['text'] #ここでLINEで送った文章を取得
		    genre = Film.genres[@genre]
			lists = movies.select{|x|  x["genre_ids"].include?(genre.to_i)}
			list = lists.sample # 任意のものを一つ選ぶ

			# listの詳細情報を取得する
			uri = URI.parse("https://api.themoviedb.org/3/movie/#{list['id']}?api_key=1f561d8e34d516d682a4d6c713fc7072&append_to_response=videos")
			json = Net::HTTP.get(uri) #NET::HTTPを利用してAPOを叩く
		    results = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換

			# 映画の情報
			video = "https://www.youtube.com/embed/#{results['videos']['results'][0]}" # 映画の予告動画のurlを送る
			movie_title = list['title'] # 映画のタイトル
			movie_score = list['vote_average']

			response = "【タイトル】" + 	movie_title + "\n" + "【ジャンル】" + @genre + "\n"  + video
			case event #case文　caseの値がwhenと一致する時にwhenの中の文章が実行される(switch文みたいなもの)
			when Line::Bot::Event::Message
				case event.type
				when Line::Bot::Event::MessageType::Text
				message = {
				 type: 'text',
				 text: response
				}
				client.reply_message(event['replyToken'], message)
				end
	        end
     	}

     	head :ok
    end

end
