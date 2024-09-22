class Movie < ApplicationRecord
  # An array of all the ratings
  RATINGS = %w[G PG PG-13 R NC-17]

  # Validates the presence of title, director, released_on, and duration
  validates_presence_of :title, :director, :released_on, :duration

  # Validates the uniqueness of title and director
  validates_uniqueness_of :title, scope: :director

  # Validates the format of released_on
  validates_format_of :released_on, with: /\A\d{4}-\d{2}-\d{2}\z/

  # Validates the inclusion of rating
  # The rating must be one of the allowed ratings (G, PG, PG-13, R, NC-17)
  # These ratings are stored in the RATINGS constant
  validates :rating, inclusion: { in: RATINGS }

  # Validates the numericality of total_gross
  validates_numericality_of :total_gross, greater_than_or_equal_to: 0, if: :released?
  validates_numericality_of :total_gross, equal_to: 0, unless: :released?

  # Validates the format of image_file_name
  # The format must be JPG or PNG and the filename must not be blank or contain spaces
  validates :image_file_name, format: {
      with: /\w+\.(jpg|png)\z/i,
      message: "must be a JPG or PNG image"
    }

  def flop?
    # Return true if the total_gross is blank or less than 225_000_000
    total_gross.blank? || total_gross < 225_000_000
  end

  def released?
    # Return true if the released_on date is not nil and is in the past
    released_on <= Time.now
  end

  def self.released
    # Returns all the movies that have been released
    where("released_on < ?", Time.now).order(released_on: :desc)
  end
end
