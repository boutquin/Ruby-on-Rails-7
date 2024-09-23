# The ReviewsController manages HTTP requests related to reviews for movies.
# It handles actions such as listing all reviews for a movie, rendering a form for a new review,
# and creating a review in the database. This controller follows RESTful conventions
# and utilizes nested resources to associate reviews with movies.

class ReviewsController < ApplicationController
  # ============================================================================
  # Filters
  # ============================================================================

  # The 'before_action' callback ensures that the 'set_movie' method is called
  # before executing any action in this controller. This sets up the @movie instance variable,
  # which is necessary for accessing the movie associated with the reviews.
  before_action :set_movie

  # ============================================================================
  # Actions
  # ============================================================================

  # GET /movies/:movie_id/reviews
  # The 'index' action retrieves all reviews associated with a specific movie.
  # It assigns the collection of reviews to an instance variable for use in the index view.
  # This action is used to display all reviews for a given movie.
  def index
    # Accesses the reviews associated with the @movie instance.
    # Uses the 'has_many :reviews' association defined in the Movie model.
    @reviews = @movie.reviews
  end

  # GET /movies/:movie_id/reviews/new
  # The 'new' action initializes a new Review object associated with the specific movie.
  # It is used in the 'new' view to render a form for creating a new review.
  def new
    # Builds a new Review instance linked to @movie.
    # This allows form helpers in the view to generate fields for the review attributes.
    @review = @movie.reviews.new
  end

  # POST /movies/:movie_id/reviews
  # The 'create' action attempts to save a new review to the database.
  # It processes the data submitted from the 'new' review form.
  # If the review is saved successfully, it redirects to the reviews index with a success message.
  # If not, it re-renders the 'new' form with error messages.
  def create
    # Builds a new Review object with the permitted parameters, associating it with @movie.
    # 'review_params' is a private method that whitelists allowed parameters to prevent mass assignment vulnerabilities.
    @review = @movie.reviews.new(review_params)

    # Attempts to save the @review object to the database.
    if @review.save
      # If the save is successful, redirects to the reviews index for the movie.
      # The 'notice' option sets a flash message that will be displayed to the user on the redirected page.
      redirect_to movie_reviews_path(@movie),
                  notice: "Thanks for your review!"
    else
      # If the save fails due to validation errors, re-renders the 'new' template.
      # The 'status: :unprocessable_entity' sets the HTTP response status code to 422,
      # indicating that the server understands the request but was unable to process the contained instructions.
      render :new, status: :unprocessable_entity
    end
  end

  # ============================================================================
  # Private Methods
  # ============================================================================

  # The 'private' keyword marks all subsequent methods as private.
  # Private methods are internal helper methods and cannot be accessed externally (e.g., via a URL).
  private

  # Strong parameters method to whitelist review attributes.
  # This method prevents mass assignment vulnerabilities by only permitting specific parameters.
  def review_params
    # Requires that the 'params' hash contains a 'review' key.
    # Permits only the specified attributes to be used for mass assignment.
    # Any additional parameters submitted will be ignored.
    params.require(:review).permit(:name, :comment, :stars)
  end

  # The 'set_movie' method retrieves the movie based on the 'movie_id' parameter.
  # It is called before each action due to the 'before_action' callback.
  # This method ensures that @movie is available for use in other actions.
  def set_movie
    # Finds the Movie record corresponding to the 'movie_id' parameter in the URL.
    # 'params[:movie_id]' retrieves the :movie_id parameter from the nested route.
    # If the movie is not found, ActiveRecord::RecordNotFound will be raised,
    # resulting in a 404 error page being displayed.
    @movie = Movie.find(params[:movie_id])
  end
end
