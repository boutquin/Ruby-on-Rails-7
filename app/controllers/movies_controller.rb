# The MoviesController handles HTTP requests related to movie resources.
# It provides actions for listing, displaying, creating, updating, and deleting movies.
# This controller follows RESTful conventions, mapping HTTP verbs to controller actions.
class MoviesController < ApplicationController
  # ============================================================================
  # Actions
  # ============================================================================

  # GET /movies
  # The index action retrieves all released movies from the database
  # and assigns them to an instance variable for use in the index view.
  # This action is used to display a list of movies to the user.
  def index
    # Fetch all movies that have been released.
    # The 'released' scope is defined in the Movie model and returns movies where 'released_on' is in the past.
    # The movies are ordered by the 'released_on' date in descending order (most recent first).
    @movies = Movie.released
  end

  # GET /movies/:id
  # The show action retrieves a single movie based on the ID parameter
  # and assigns it to an instance variable for use in the show view.
  # This action displays detailed information about a specific movie.
  def show
    # Find the movie by its ID, which is obtained from the URL parameters.
    # 'params[:id]' retrieves the :id parameter from the request.
    # 'Movie.find' raises an ActiveRecord::RecordNotFound exception if the movie is not found,
    # which by default renders a 404 error page.
    @movie = Movie.find(params[:id])
  end

  # GET /movies/new
  # The new action initializes a new movie object and assigns it to an instance variable.
  # This is used in the 'new' view to render a form for creating a new movie.
  def new
    # Instantiate a new, unsaved Movie object.
    # This object is used by the form helper methods in the view to generate the form fields.
    @movie = Movie.new
  end

  # POST /movies
  # The create action attempts to create a new movie record with the parameters submitted from the 'new' form.
  # If the movie is saved successfully, it redirects to the movie's show page with a success message.
  # If not, it re-renders the 'new' form with error messages.
  def create
    # Instantiate a new Movie object with the permitted parameters from the form.
    @movie = Movie.new(movie_params)

    # Attempt to save the new movie to the database.
    if @movie.save
      # If the save is successful, redirect to the show action (movie's detail page).
      # The 'notice' option sets a flash message that will be displayed to the user on the redirected page.
      redirect_to @movie, notice: "Movie created successfully."
    else
      # If the save fails due to validation errors, re-render the 'new' template.
      # The 'status: :unprocessable_entity' sets the HTTP response status code to 422,
      # indicating that the server understands the content type and syntax of the request but was unable to process the contained instructions.
      render :new, status: :unprocessable_entity
    end
  end

  # GET /movies/:id/edit
  # The edit action retrieves the movie to be edited based on the ID parameter
  # and assigns it to an instance variable for use in the 'edit' view.
  # This action is used to display a form for editing an existing movie.
  def edit
    # Find the movie by its ID.
    # This movie object will be used to populate the form fields in the 'edit' view.
    @movie = Movie.find(params[:id])
  end

  # PATCH/PUT /movies/:id
  # The update action updates an existing movie record with the parameters submitted from the 'edit' form.
  # If the update is successful, it redirects to the movie's show page with a success message.
  # If not, it re-renders the 'edit' form with error messages.
  def update
    # Find the movie by its ID.
    @movie = Movie.find(params[:id])

    # Attempt to update the movie with the permitted parameters.
    if @movie.update(movie_params)
      # If the update is successful, redirect to the show action with a success notice.
      redirect_to @movie, notice: "Movie updated successfully."
    else
      # If the update fails due to validation errors, re-render the 'edit' template.
      # The 'status: :unprocessable_entity' sets the HTTP response status code to 422.
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /movies/:id
  # The destroy action deletes an existing movie record from the database.
  # After deletion, it redirects to the movies index page with a success message.
  def destroy
    # Find the movie by its ID.
    @movie = Movie.find(params[:id])

    # Delete the movie record from the database.
    @movie.destroy

    # Set a flash notice to inform the user that the movie was deleted successfully.
    flash[:notice] = "Movie deleted successfully."

    # Redirect to the movies index page.
    # The 'status: :see_other' sets the HTTP response status code to 303,
    # indicating that the resource has been replaced and the client should perform a GET request to the new URL.
    redirect_to movies_url, status: :see_other
  end

  # ============================================================================
  # Private Methods
  # ============================================================================

  # The 'private' keyword marks all subsequent methods as private.
  # Private methods are internal helper methods and cannot be accessed externally (e.g., via a URL).
  private

  # The 'movie_params' method uses strong parameters to whitelist attributes that can be mass-assigned.
  # This is a security feature to prevent mass assignment vulnerabilities,
  # where a malicious user could submit extra parameters to manipulate model attributes not intended for editing.
  def movie_params
    # Require that the 'params' hash contains a 'movie' key.
    # Permit only the specified attributes to be used for mass assignment.
    # Any additional parameters submitted will be ignored.
    params.require(:movie)
          .permit(:title, :description, :rating, :released_on, :total_gross,
                  :director, :duration, :image_file_name)
  end
end
