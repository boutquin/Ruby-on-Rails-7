# The MoviesHelper module provides utility methods that can be used in views related to movies.
# Helpers in Rails are designed to keep view templates clean and maintainable by abstracting complex logic.
# This module contains methods for formatting movie-related data for display purposes.

module MoviesHelper
  # ============================================================================
  # Method: total_gross
  # ----------------------------------------------------------------------------
  # Purpose:
  # - Formats the total gross earnings of a movie for display in the views.
  # - Determines if a movie is a 'flop' based on its total gross earnings.
  # - Returns a human-readable string representing the movie's financial performance.
  #
  # Parameters:
  # - movie: An instance of the Movie model.
  #
  # Returns:
  # - If the movie is a flop, returns the string "Flop!".
  # - If the movie is not a flop, returns the formatted total gross earnings as currency.
  #
  # Usage:
  # - Called from views to display the total gross in a user-friendly format.
  #
  # Dependencies:
  # - Relies on the 'flop?' instance method defined in the Movie model.
  # - Uses the 'number_to_currency' helper method provided by ActionView::Helpers::NumberHelper.
  # - The 'precision: 0' option removes decimal places from the currency formatting.
  #
  # Example:
  # - If movie.total_gross = 300_000_000, returns "$300,000,000".
  # - If movie.total_gross = 100_000_000 and movie.flop? returns true, returns "Flop!".
  def total_gross(movie)
    # Check if the movie is considered a flop based on its total gross earnings.
    if movie.flop?
      # If the movie is a flop, return the string "Flop!".
      "Flop!"
    else
      # If the movie is not a flop, format the total gross earnings as currency.
      # 'number_to_currency' formats the number into a currency string.
      # 'precision: 0' means no decimal places will be shown.
      number_to_currency(movie.total_gross, precision: 0)
    end
  end

  # ============================================================================
  # Method: year_of
  # ----------------------------------------------------------------------------
  # Purpose:
  # - Extracts and formats the release year of a movie for display in the views.
  # - Handles cases where the release date may be nil (not available).
  #
  # Parameters:
  # - movie: An instance of the Movie model.
  #
  # Returns:
  # - If the movie's 'released_on' date is nil, returns "N/A".
  # - If the movie's 'released_on' date is present, returns the year as an integer.
  #
  # Usage:
  # - Called from views to display the release year of a movie.
  #
  # Example:
  # - If movie.released_on = Date.new(2020, 5, 15), returns 2020.
  # - If movie.released_on = nil, returns "N/A".
  def year_of(movie)
    # Check if the 'released_on' attribute of the movie is nil (no release date).
    if movie.released_on.nil?
      # If the release date is nil, return "N/A" to indicate that the release year is not available.
      "N/A"
    else
      # If the release date is present, extract the year component.
      # 'released_on.year' returns the year as an integer.
      movie.released_on.year
    end
  end
end
