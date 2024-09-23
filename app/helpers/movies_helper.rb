module MoviesHelper
  # Provides helper methods for movie-related views.
  # These methods are used to format and display movie attributes in the views.

  # Formats the total gross of a movie for display.
  # If the movie is considered a flop, it returns the string "Flop!".
  # Otherwise, it formats the total gross as a currency string without decimal places.
  #
  # @param movie [Movie] The movie object whose total gross is to be formatted.
  # @return [String] The formatted total gross or "Flop!" if the movie is a flop.
  #
  # Example Usage:
  #   <%= total_gross(@movie) %>
  #   # => "$100,000" or "Flop!"
  #
  # Explanation:
  # - Checks if the movie is a flop by calling 'movie.flop?'.
  # - If it is a flop, returns "Flop!".
  # - If not, uses 'number_to_currency' to format the total gross as a currency string.
  # - 'precision: 0' removes decimal places for a cleaner display.
  def total_gross(movie)
    if movie.flop?
      # The movie is considered a flop based on business logic defined in the model.
      # Returns the string "Flop!" to indicate poor financial performance.
      "Flop!"
    else
      # Formats the total gross as currency without decimal places.
      # 'number_to_currency' is a Rails helper that formats numbers into currency strings.
      number_to_currency(movie.total_gross, precision: 0)
    end
  end

  # Retrieves the release year of the movie.
  # If the movie's release date is not set, it returns "N/A".
  #
  # @param movie [Movie] The movie object whose release year is to be retrieved.
  # @return [Integer, String] The release year or "N/A" if not available.
  #
  # Example Usage:
  #   <%= year_of(@movie) %>
  #   # => 2023 or "N/A"
  #
  # Explanation:
  # - Accesses the 'released_on' attribute, which should be a Date object.
  # - Uses safe navigation operator '&.' to handle nil values.
  # - If 'released_on' is nil, 'movie.released_on&.year' returns nil, and '|| "N/A"' provides a fallback.
  def year_of(movie)
    # Safely retrieves the year from the 'released_on' date or returns "N/A" if unavailable.
    movie.released_on&.year || "N/A"
  end

  # Calculates and formats the average star rating of a movie.
  # If the movie has no reviews, it returns a bold "No reviews" message.
  # Otherwise, it returns the average rating formatted to one decimal place,
  # pluralized with "star" or "stars" as appropriate.
  #
  # @param movie [Movie] The movie object whose average stars are to be calculated.
  # @return [String] The formatted average star rating or "No reviews" message.
  #
  # Example Usage:
  #   <%= average_stars(@movie) %>
  #   # => "4.5 stars" or "<strong>No reviews</strong>"
  #
  # Explanation:
  # - Calls 'movie.average_stars' to get the average rating (assumes method exists in Movie model).
  # - Checks if the average is zero, indicating no reviews.
  # - Uses 'content_tag' to create an HTML <strong> tag with "No reviews".
  # - If there are reviews, formats the average to one decimal place using 'number_with_precision'.
  # - Uses 'pluralize' to add "star" or "stars" based on the average.
  def average_stars(movie)
    if movie.average_stars.zero?
      # No reviews are present; display a bold "No reviews" message.
      # 'content_tag' safely generates HTML content.
      content_tag(:strong, "No reviews")
    else
      # Reviews are present; format the average stars.
      # 'number_with_precision' formats the average to one decimal place.
      # 'pluralize' adds the correct singular or plural form of "star".
      pluralize(number_with_precision(movie.average_stars, precision: 1), "star")
    end
  end
end
