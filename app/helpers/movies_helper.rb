module MoviesHelper
  # Returns the formatted gross for a movie
  def total_gross(movie)
    if movie.flop?
      "Flop!"
    else
      number_to_currency(movie.total_gross, precision: 0)
    end
  end

  # Returns the formatted release date for a movie
  def year_of(movie)
    if movie.released_on.nil?
      "N/A"
    else
      movie.released_on.year
    end
  end
end
