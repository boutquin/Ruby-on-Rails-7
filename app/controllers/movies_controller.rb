class MoviesController < ApplicationController
  def index
    # Connect to the database and get all the movies
    @movies = Movie.all
  end
end
