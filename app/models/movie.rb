class Movie < ApplicationRecord
  def flop?
    # Return true if the total_gross is blank or less than 225_000_000
    total_gross.blank? || total_gross < 225_000_000
  end

  def self.released
    # Returns all the movies that have been released
    where("released_on < ?", Time.now).order(released_on: :desc)
  end
end
