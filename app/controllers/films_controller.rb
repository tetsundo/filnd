class FilmsController < ApplicationController
	require 'uri'
	require 'net/http'
	require 'json'

	def search
	  @year = params[:year]
	  @genre = params[:genre]
	  if @year != nil
		uri = URI.parse("https://api.themoviedb.org/3/discover/movie?certification_country=JA&primary_release_year=#{@year}&with_genres=#{@genre}&sort_by=vote_average.desc&api_key=1f561d8e34d516d682a4d6c713fc7072")
		json = Net::HTTP.get(uri) #NET::HTTPを利用してAPOを叩く
		@results = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換
        @films = @results['results']
      else
        uri = URI.parse("https://api.themoviedb.org/3/trending/movie/week?api_key=1f561d8e34d516d682a4d6c713fc7072")
	    json = Net::HTTP.get(uri) #NET::HTTPを利用してAPOを叩く
	    @results = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換
	    @films = @results['results']
	  end
	end
	def lists
	  @genre = params[:genre]
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
	  if @genre != nil
	  	 @lists = movies.select{|x|  x["genre_ids"].include?(@genre.to_i)}
	  end
	  	list = @lists.sample # 任意のものを一つ選ぶ
	  	binding.pry
		# listの詳細情報を取得する
		uri = URI.parse("https://api.themoviedb.org/3/movie/#{list['id']}?api_key=1f561d8e34d516d682a4d6c713fc7072&append_to_response=videos")
		json = Net::HTTP.get(uri) #NET::HTTPを利用してAPOを叩く
	    results = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換
	    video = results['videos']['results'][0]
	  binding.pry
	end
	def casts
	  uri = URI.parse("https://api.themoviedb.org/3/movie/#{params[:id]}?api_key=1f561d8e34d516d682a4d6c713fc7072&append_to_response=videos,credits")
	  json = Net::HTTP.get(uri) #NET::HTTPを利用してAPOを叩く
	  @results = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換
	  @video = @results['videos']['results'][0]
	  @casts = @results['credits']['cast']
	end

	def trends
	  @genre = params[:genre]
	  uri = URI.parse("https://api.themoviedb.org/3/trending/movie/week?api_key=1f561d8e34d516d682a4d6c713fc7072")
	  json = Net::HTTP.get(uri) #NET::HTTPを利用してAPOを叩く
	  @results = JSON.parse(json) #返ってきたjsonデータをrubyの配列に変換
	  @trends = @results['results']
	end
end
