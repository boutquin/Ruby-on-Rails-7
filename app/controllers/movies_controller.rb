class MoviesController < ApplicationController
  def index
    # Connect to the database and get all the released movies
    @movies = Movie.released
  end

  def show
    # Connect to the database and get the movie with the given ID
    @movie = Movie.find(params[:id])
  end

  def new
    # Create a new movie object for the form
    @movie = Movie.new
  end

  def create
    # Create a new movie object with the given parameters
    @movie = Movie.new(movie_params)

    # If the movie is saved to the database, redirect to the movie's show page
    if @movie.save
      # Flash the creation notice message
      flash[:notice] = "Movie created successfully."
      # Redirect to the movie's show page
      redirect_to @movie
    else
      # If the movie is not saved to the database, render the new form again
      render :new
    end
  end

  def edit
    # Connect to the database and get the movie with the given ID
    @movie = Movie.find(params[:id])
  end

  def update
    # Connect to the database and get the movie with the given ID
    @movie = Movie.find(params[:id])

    # Update the movie with the given parameters
    if @movie.update(movie_params)
      # Flash the update notice message
      flash[:notice] = "Movie updated successfully."
      # Redirect to the movie's show page
      redirect_to @movie
      flash[:notice] = "Movie updated successfully."
      # Redirect to the movie's show page
      redirect_to @movie
    else
      render :edit
    end
  end

  def destroy
    # Connect to the database and get the movie with the given ID
    @movie = Movie.find(params[:id])

    # Delete the movie from the database
    @movie.destroy

    # Flash the deletion notice message
    flash[:notice] = "Movie deleted successfully."
    # Redirect to the movies index page with a 303 status code
    redirect_to movies_url, status: :see_other
  end

  # Private methods are only accessible within the class
  # They cannot be called from outside the class or used from a web browser
  private

  def movie_params
    # Permit the specified parameters to be used when creating or updating a movie
    # This ensures that only safe data is saved to the database
    params.require(:movie).
      permit(:title, :description, :rating, :released_on, :total_gross)
  end
end
