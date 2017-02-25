require "rack-flash"

class SongsController < ApplicationController

	 enable :sessions
  	 use Rack::Flash

	get '/songs' do
		@songs = Song.all
		erb :"/songs/index"
	end

	get '/songs/new' do
		erb :"/songs/new"
	end

	post '/songs' do
		@song = Song.create(name: params["song"]["name"])

		#This originally had a long if/else statement based on params
		#Then I remembered #find_or_create_by exists
		@song.artist = Artist.find_or_create_by(name: params["song"]["artist"]["name"])
		@song.artist.songs << @song

		params["song"]["genre_ids"].each do |p|
			@genre = Genre.find(p)
			@song.genres << @genre
		end

		@song.save
		flash[:message] = "Successfully created song."
		redirect to "/songs/#{@song.slug}"
	end

	get '/songs/:slug' do
		@song = Song.find_by_slug(params[:slug])
		erb :"/songs/show"
	end

	get '/songs/:slug/edit' do
		@song = Song.find_by_slug(params[:slug])
		erb :'/songs/edit'
	end

	post '/songs/:slug' do
		@song = Song.find(params["song"]["id"])
		#Finds song by id, because if I find_by song name...
		#It tries to find a song with a name that doesn't exist in the database
		#@song.id is definted in a hidden value in edit.erb
		@song.update(name: params["song"]["name"])

		@song.artist = Artist.find_or_create_by(name: params["song"]["artist"]["name"])
		@song.artist.songs << @song

		params["song"]["genre_ids"].each do |p|
			@genre = Genre.find(p)
			@song.genres << @genre
		end

		@song.save
		flash[:message] = "Successfully updated song."
		redirect to "/songs/#{@song.slug}"
	end



end
