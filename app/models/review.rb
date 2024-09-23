# The Review class represents a user's review of a movie within the application.
# It inherits from ApplicationRecord, which provides it with all the functionalities of Active Record models.
# Active Record is the Object-Relational Mapping (ORM) layer supplied by Rails to facilitate database interactions.
class Review < ApplicationRecord
  # Establish a 'belongs_to' association with the Movie model.
  # This indicates a one-to-many relationship where each Review is associated with one Movie,
  # but a Movie can have many Reviews.
  #
  # The 'belongs_to :movie' line adds several methods to the Review model to simplify interactions:
  # - `movie`: Returns the Movie object associated with this Review.
  # - `movie=`: Assigns this Review to a different Movie.
  # - `build_movie(attributes = {})`: Instantiates a new Movie associated with this Review (unsaved).
  # - `create_movie(attributes = {})`: Creates and saves a new Movie associated with this Review.
  #
  # This association also expects that the 'reviews' database table has a 'movie_id' integer column.
  # The 'movie_id' column is a foreign key that references the 'id' column in the 'movies' table.
  # This foreign key establishes the link between a Review and its associated Movie.
  #
  # By default, the association is required (i.e., a Review must belong to a Movie).
  # If you want to make the association optional (e.g., allow Reviews without a Movie),
  # you can specify `optional: true`:
  #   belongs_to :movie, optional: true
  #
  # Additional options can be provided to customize the association:
  # - `class_name`: Specify the associated model's class name if it's different from the symbol.
  # - `foreign_key`: Specify a custom foreign key if it's not the default of 'movie_id'.
  # - `inverse_of`: Optimize queries by specifying the inverse association.
  belongs_to :movie

  # ============================================================================
  # Additional Validations, Associations, and Methods
  # ============================================================================

  # Validations ensure that the data stored in the database meets certain criteria.
  # For example, you might want to ensure that a Review has content and a rating.

  # Validate that the 'content' attribute is present (not blank).
  # This prevents saving a Review without any content.
  # validates :content, presence: true

  # Validate that the 'rating' attribute is present and is an integer between 1 and 5.
  # This ensures that the rating is within an acceptable range.
  # validates :rating,
  #           presence: true,
  #           numericality: {
  #             only_integer: true,
  #             greater_than_or_equal_to: 1,
  #             less_than_or_equal_to: 5
  #           }

  # If your application has a User model and Reviews are submitted by users,
  # you might add an association to the User model:
  # belongs_to :user

  # You can also add scopes to simplify querying reviews.
  # For example, a scope to get all reviews with a certain rating:
  # scope :with_rating, ->(rating) { where(rating: rating) }

  # ============================================================================
  # Example Usage
  # ============================================================================

  # Creating a new Review associated with a Movie:
  # movie = Movie.find(1)
  # review = movie.reviews.build(content: "Great movie!", rating: 5)
  # review.save

  # Accessing the associated Movie from a Review:
  # review = Review.find(1)
  # movie = review.movie

  # ============================================================================
  # Database Schema Expectations
  # ============================================================================

  # The 'reviews' table is expected to have the following columns:
  # - id: integer, primary key, not null
  # - movie_id: integer, foreign key referencing movies.id, not null
  # - content: text (or string, depending on requirements)
  # - rating: integer
  # - created_at: datetime, not null
  # - updated_at: datetime, not null

  # A migration to create the 'reviews' table might look like this:
  #
  # class CreateReviews < ActiveRecord::Migration[6.0]
  #   def change
  #     create_table :reviews do |t|
  #       t.references :movie, null: false, foreign_key: true
  #       t.text :content
  #       t.integer :rating
  #
  #       t.timestamps
  #     end
  #   end
  # end

  # ============================================================================
  # Notes and Best Practices
  # ============================================================================

  # - Ensure that the 'movie_id' foreign key is indexed in the database for performance.
  # - Consider adding database-level constraints for data integrity (e.g., NOT NULL constraints).
  # - Use validations to enforce data correctness before saving records to the database.
  # - Utilize associations to simplify queries and data manipulation.

  # Remember to adjust and expand this model based on the specific needs of your application.
  # For example, you may need to handle user authentication, prevent duplicate reviews,
  # or implement features like upvoting/downvoting reviews.
end
