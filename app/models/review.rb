# The Review class represents a user's review of a movie within the application.
# It inherits from ApplicationRecord, which provides it with all the functionalities of Active Record models.
# Active Record is the Object-Relational Mapping (ORM) layer supplied by Rails to facilitate database interactions.
# This class includes associations, validations, and constants related to reviews.

class Review < ApplicationRecord
  # ============================================================================
  # Associations
  # ============================================================================

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
  # Validations
  # ============================================================================

  # Validate that the 'name' attribute is present (not blank).
  # This ensures that a Review cannot be saved without a name, which might represent the reviewer's name.
  # The 'presence: true' option specifies that the 'name' attribute must be present.
  #
  # Error Handling:
  # - If the 'name' is blank or nil, the review will not be saved.
  # - An error message will be added to the 'errors' collection of the model.
  # - The default error message is "can't be blank".
  validates :name, presence: true

  # Validate that the 'comment' attribute has a minimum length.
  # This ensures that reviews have substantive content and are not too short.
  #
  # Options:
  # - 'length: { minimum: 4 }':
  #   - Specifies that the 'comment' must be at least 4 characters long.
  #   - Prevents saving comments that are too brief to be meaningful.
  #
  # Error Handling:
  # - If the 'comment' is shorter than 4 characters, the review will not be saved.
  # - An error message will be added to the 'errors' collection of the model.
  # - The default error message is "is too short (minimum is 4 characters)".
  validates :comment, length: { minimum: 4 }

  # ============================================================================
  # Constants
  # ============================================================================

  # Define a constant array of valid star ratings.
  # These represent the possible ratings a user can give to a movie in their review.
  # The star ratings range from 1 to 5, with 1 being the lowest and 5 being the highest.
  # This constant is used in the validation of the 'stars' attribute.
  STARS = [ 1, 2, 3, 4, 5 ]

  # ============================================================================
  # Validations (Continued)
  # ============================================================================

  # Validate that the 'stars' attribute is included in the predefined list of valid star ratings.
  # This ensures that users can only assign a rating between 1 and 5 stars.
  #
  # Options:
  # - 'in: STARS':
  #   - Specifies that the 'stars' value must be included in the STARS constant array.
  # - 'message: "must be between 1 and 5"':
  #   - Provides a custom error message when the validation fails.
  #   - Helps users understand the acceptable range of values.
  #
  # Error Handling:
  # - If the 'stars' value is not in the STARS array, the review will not be saved.
  # - An error message will be added to the 'errors' collection of the model.
  #
  # Examples:
  # - Valid 'stars' values: 1, 2, 3, 4, 5
  # - Invalid 'stars' values: 0, 6, nil, 3.5
  validates :stars, inclusion: {
    in: STARS,
    message: "must be between 1 and 5"
  }

  # Alternatively, you can use numericality validation to ensure 'stars' is an integer within a range:
  #
  # validates :stars,
  #           numericality: {
  #             only_integer: true,
  #             greater_than_or_equal_to: 1,
  #             less_than_or_equal_to: 5,
  #             message: "must be an integer between 1 and 5"
  #           }

  # ============================================================================
  # Additional Notes and Best Practices
  # ============================================================================

  # - Ensure that the 'reviews' table in the database has the necessary columns:
  #   - 'id': integer, primary key, not null
  #   - 'movie_id': integer, foreign key referencing 'movies.id', not null
  #   - 'name': string or text, not null
  #   - 'comment': text, not null
  #   - 'stars': integer, not null
  #   - 'created_at' and 'updated_at': datetime, managed by Rails, not null
  #
  # - Consider adding database-level constraints to enforce data integrity, such as 'NOT NULL' constraints and foreign key constraints.
  # - Index the 'movie_id' column in the 'reviews' table to improve query performance when fetching reviews for a movie.
  #
  # - If your application has a User model and you want to associate reviews with registered users, you might add:
  #   belongs_to :user
  #   - This would require additional setup, including a 'user_id' column in the 'reviews' table.
  #
  # - For the 'comment' validation, you might also want to set an upper limit on the length to prevent excessively long comments:
  #   validates :comment, length: { minimum: 4, maximum: 500 }
  #
  # - To improve user experience, provide meaningful error messages and consider using internationalization (i18n) for localization.
  #
  # - Write unit tests to verify that validations work as expected, ensuring that valid reviews are saved and invalid ones are rejected.
  #
  # ============================================================================
  # Example Usage
  # ============================================================================

  # Creating a new Review associated with a Movie:
  # movie = Movie.find(1)
  # review = movie.reviews.build(name: "John Doe", comment: "Great movie!", stars: 5)
  # review.save
  #
  # Accessing the associated Movie from a Review:
  # review = Review.find(1)
  # movie = review.movie
  #
  # Fetching all Reviews for a Movie:
  # movie.reviews.each do |review|
  #   puts "#{review.name} rated #{review.stars} stars: #{review.comment}"
  # end
end
