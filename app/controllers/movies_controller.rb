class MoviesController < ApplicationController
  def index
    # Connect to the database and get all the movies
    @movies = Movie.all
  end

  def show
    # Connect to the database and get the movie with the given ID
    @movie = Movie.find(params[:id])
  end
end
