class SongsController < ApplicationController

	get '/songs' do
		@songs = Song.all
		erb :"/songs/index"
	end

	get '/songs/new' do
		erb :"/songs/new"
	end

	post '/songs' do
		@song = Song.create(name: params["song"]["name"])

		if Artist.all.include?(Artist.find_by(name: params["song"]["artist"]["name"]))
			@song.artist = Artist.find_by(name: params["song"]["artist"]["name"])
			@song.artist.songs << @song
		else
			@song.artist = Artist.create(name: params["song"]["artist"]["name"])
			@song.artist.songs << @song
		end

		params["song"]["genre_ids"].each do |p|
			@genre = Genre.find(p)
			@song.genres << @genre
		end

		@song.save
		redirect to "/songs/#{@song.slug}"
	end

	get '/songs/:slug' do
		@song = Song.find_by_slug(params[:slug])
		erb :"/songs/show"
	end
end
