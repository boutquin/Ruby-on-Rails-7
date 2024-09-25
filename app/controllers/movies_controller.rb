# The MoviesController class is responsible for managing all HTTP requests related to movie resources.
# It provides a set of actions to list, display, create, update, and delete movie records.
# This controller adheres to RESTful conventions, mapping HTTP verbs (GET, POST, PATCH, DELETE) to their corresponding controller actions.
class MoviesController < ApplicationController
  # ============================================================================
  # Before Actions
  # ============================================================================
  # The before_action callbacks are executed before the specified actions in the controller.
  # These are used to enforce authentication and authorization for various actions.

  # Require users to be signed in for all actions except 'index' (listing movies) and 'show' (displaying a single movie).
  before_action :require_signin, except: [ :index, :show ]

  # Ensure that the current user has admin privileges for all actions except 'index' and 'show'.
  before_action :require_admin, except: [ :index, :show ]

  # ============================================================================
  # Actions
  # ============================================================================

  # ============================================================================
  # Index Action
  # ============================================================================
  # This action retrieves all released movies from the database and assigns them
  # to the instance variable @movies, which is then available for use in the index view.
  #
  # This action is typically used to display a list of all available movies to users.
  #
  # Returns:
  # - @movies: An ActiveRecord collection of Movie objects representing all released movies.
  def index
    @movies = Movie.released
  end

  # ============================================================================
  # Show Action
  # ============================================================================
  # This action retrieves a single movie based on the ID parameter provided in the URL
  # and assigns it to the instance variable @movie for use in the show view.
  #
  # This action displays detailed information about a specific movie.
  #
  # Raises:
  # - ActiveRecord::RecordNotFound if no movie is found with the given ID.
  #
  # Returns:
  # - @movie: An instance of Movie representing the movie with the specified ID.
  def show
    @movie = Movie.find(params[:id])
  end

  # ============================================================================
  # New Action
  # ============================================================================
  # This action initializes a new movie object and assigns it to @movie.
  # This object is used in the 'new' view to render a form for creating a new movie.
  #
  # Returns:
  # - @movie: A new instance of Movie, which is empty and ready for input.
  def new
    @movie = Movie.new
  end

  # ============================================================================
  # Create Action
  # ============================================================================
  # This action attempts to create a new movie record with the parameters submitted
  # from the 'new' form. If the movie is saved successfully, it redirects to the
  # movie's show page with a success message. If not, it re-renders the 'new' form
  # with error messages for user feedback.
  #
  # Returns:
  # - Redirects to the movie's show page if successful.
  # - Renders the 'new' template with validation errors if unsuccessful.
  def create
    @movie = Movie.new(movie_params)

    # Attempt to save the new movie to the database.
    if @movie.save
      # If the save is successful, redirect to the show action (movie's detail page).
      redirect_to @movie, notice: "Movie created successfully."
    else
      # If the save fails due to validation errors, re-render the 'new' template.
      render :new, status: :unprocessable_entity
    end
  end

  # ============================================================================
  # Edit Action
  # ============================================================================
  # This action retrieves the movie to be edited based on the ID parameter
  # and assigns it to the instance variable @movie for use in the 'edit' view.
  #
  # This action is used to display a form for editing an existing movie.
  #
  # Returns:
  # - @movie: An instance of Movie representing the movie being edited.
  def edit
    @movie = Movie.find(params[:id])
  end

  # ============================================================================
  # Update Action
  # ============================================================================
  # This action updates an existing movie record with the parameters submitted
  # from the 'edit' form. If the update is successful, it redirects to the movie's
  # show page with a success message. If not, it re-renders the 'edit' form with
  # error messages.
  #
  # Returns:
  # - Redirects to the movie's show page if the update is successful.
  # - Renders the 'edit' template with validation errors if unsuccessful.
  def update
    @movie = Movie.find(params[:id])

    # Attempt to update the movie with the permitted parameters.
    if @movie.update(movie_params)
      # If the update is successful, redirect to the show action with a success notice.
      redirect_to @movie, notice: "Movie updated successfully."
    else
      # If the update fails due to validation errors, re-render the 'edit' template.
      render :edit, status: :unprocessable_entity
    end
  end

  # ============================================================================
  # Destroy Action
  # ============================================================================
  # This action deletes an existing movie record from the database. After deletion,
  # it redirects to the movies index page with a success message.
  #
  # Returns:
  # - Redirects to the movies index page after deletion.
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    # Redirect to the movies index page with a success alert.
    redirect_to movies_url, status: :see_other,
        alert: "Movie successfully deleted!"
  end

  # ============================================================================
  # Private Methods
  # ============================================================================

  # The 'private' keyword marks all subsequent methods as private.
  # Private methods are internal helper methods and cannot be accessed externally (e.g., via a URL).
  private

  # ============================================================================
  # Movie Parameters Method
  # ============================================================================
  # This method filters the parameters submitted to the create and update actions
  # to ensure only permitted attributes are allowed. This is a security measure
  # to prevent mass assignment vulnerabilities, where a malicious user could
  # submit extra parameters to manipulate model attributes not intended for editing.
  #
  # Returns:
  # - A hash of permitted parameters for movie creation and updates, including:
  #   - :title
  #   - :description
  #   - :rating
  #   - :released_on
  #   - :total_gross
  #   - :director
  #   - :duration
  #   - :image_file_name
  def movie_params
    params.require(:movie)
          .permit(:title, :description, :rating, :released_on, :total_gross,
                  :director, :duration, :image_file_name)
  end
end
