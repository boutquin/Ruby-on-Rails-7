class Movie < ApplicationRecord
  # Define a constant array of valid movie ratings according to the Motion Picture Association of America (MPAA) guidelines.
  # These ratings are used to validate that the 'rating' attribute contains an acceptable value.
  # Valid ratings include:
  # - "G": General Audiences
  # - "PG": Parental Guidance Suggested
  # - "PG-13": Parents Strongly Cautioned
  # - "R": Restricted
  # - "NC-17": Adults Only
  RATINGS = %w[G PG PG-13 R NC-17]

  # Ensure that essential attributes are present before saving the movie record.
  # This validation prevents saving movies without critical information.
  # Validates the presence of:
  # - 'title': The title of the movie.
  # - 'director': The director of the movie.
  # - 'released_on': The release date of the movie.
  # - 'duration': The duration of the movie in minutes.
  validates_presence_of :title, :director, :released_on, :duration

  # Ensure that each movie title is unique for a given director.
  # This means that the same director cannot have multiple movies with the same title in the database.
  # The 'scope: :director' option specifies that the uniqueness constraint is applied per director.
  validates_uniqueness_of :title, scope: :director

  # Ensure that the 'released_on' attribute follows the 'YYYY-MM-DD' date format.
  # This validation uses a regular expression to match dates in the specified format.
  # It helps prevent invalid date formats from being saved to the database.
  # Regular Expression Breakdown:
  # - \A and \z: Anchor the match to the start and end of the string.
  # - \d{4}: Matches exactly four digits (the year).
  # - -: Matches a literal hyphen.
  # - \d{2}: Matches exactly two digits (the month and day).
  # - The pattern repeats to match the full date format.
  validates_format_of :released_on, with: /\A\d{4}-\d{2}-\d{2}\z/

  # Validate that the 'rating' attribute is included in the predefined list of valid ratings.
  # This ensures that only acceptable movie ratings are saved to the database.
  # The list of valid ratings is defined in the RATINGS constant above.
  validates :rating, inclusion: { in: RATINGS }

  # Validate that 'total_gross' is a number greater than or equal to 0 for released movies.
  # This ensures that released movies have a valid gross earnings value.
  # Options:
  # - greater_than_or_equal_to: Specifies the minimum value (0).
  # - if: :released?: Applies this validation only if the movie is released.
  # - message: Custom error message displayed when the validation fails.
  validates_numericality_of :total_gross,
                            greater_than_or_equal_to: 0,
                            if: :released?,
                            message: "must be greater than or equal to 0 for released movies"

  # Validate that 'total_gross' is exactly 0 for unreleased movies.
  # This prevents assigning gross earnings to movies that have not yet been released.
  # Options:
  # - equal_to: Specifies the exact value that 'total_gross' must be (0).
  # - unless: :released?: Applies this validation only if the movie is not released.
  # - message: Custom error message displayed when the validation fails.
  validates_numericality_of :total_gross,
                            equal_to: 0,
                            unless: :released?,
                            message: "must be 0 for unreleased movies"

  # Validate the format of the 'image_file_name' attribute using a regular expression.
  # This ensures that the filename follows a specific pattern to prevent invalid or potentially harmful filenames.
  # The pattern allows:
  # - Filenames starting with one or more word characters (letters, digits, underscores).
  # - Optional groups of a hyphen or underscore followed by more word characters, allowing multi-word filenames.
  # - A dot followed by 'jpg' or 'png' extension (case-insensitive), ensuring only specific image formats are accepted.
  # This validation helps prevent directory traversal attacks and ensures that only valid image filenames are used.
  # Regular Expression Breakdown:
  # - \A and \z: Anchor the match to the start and end of the string.
  # - [\w]+: Matches one or more word characters.
  # - ([-_][\w]+)*: Matches zero or more groups of a hyphen or underscore followed by one or more word characters.
  # - \.: Matches a literal dot.
  # - (jpg|png): Matches the extensions 'jpg' or 'png'.
  # - /i: Case-insensitive flag.
  validates :image_file_name, format: { with: /\A[\w]+([-_][\w]+)*\.(jpg|png)\z/i }

  # Add a custom validation to check if the specified image file exists in the images directory.
  # This ensures that the 'image_file_name' refers to an actual file, preventing broken image links in the application.
  # The 'image_file_must_exist' method is defined below and will be called during the validation process.
  validate :image_file_must_exist

  # Instance method to determine if the movie is considered a 'flop' based on its total gross earnings.
  # A movie is considered a flop if:
  # - The 'total_gross' is blank (not available).
  # - OR the 'total_gross' is less than $225,000,000.
  # Returns:
  # - true: If the movie is a flop.
  # - false: If the movie is not a flop.
  # Note:
  # - The threshold of $225 million is an arbitrary value that can be adjusted based on business rules.
  def flop?
    total_gross.blank? || total_gross < 225_000_000
  end

  # Instance method to check if the movie has been released.
  # Returns true if the 'released_on' date is less than or equal to the current time.
  # This method is used in validations and can be used elsewhere in the application.
  # It assumes that the movie is considered released if its release date is in the past or today.
  def released?
    released_on <= Time.now
  end

  # Class method to retrieve all movies that have been released.
  # It selects movies where the 'released_on' date is before the current time.
  # The results are ordered by the 'released_on' date in descending order,
  # so the most recently released movies appear first.
  # Usage:
  # - Movie.released: Returns an ActiveRecord::Relation of released movies.
  def self.released
    where("released_on < ?", Time.now).order(released_on: :desc)
  end

  # Define private methods that are not accessible outside this class.
  # Private methods are used internally within the class and are not part of the public API.
  private

  # Custom validation method to verify that the image file exists.
  # This method checks whether the specified image file actually exists in the images directory.
  # It helps prevent references to nonexistent image files, which could lead to broken images in the application.
  # This method is automatically called during the validation phase due to the 'validate' directive above.
  def image_file_must_exist
    # Return early if the 'image_file_name' is blank (nil or empty string).
    # This prevents unnecessary processing and avoids errors when 'image_file_name' is not provided.
    return if image_file_name.blank?

    # Construct the full file path to the image by joining the images directory path with the image filename.
    # The 'images_directory' method provides the path to the images directory.
    file_path = images_directory.join(image_file_name)

    # Check if the file exists at the constructed file path.
    # 'File.exist?' returns true if the file exists and false otherwise.
    unless File.exist?(file_path)
      # If the file does not exist, add an error message to the 'image_file_name' attribute.
      # This will prevent the record from being saved and provide feedback to the user.
      errors.add(:image_file_name, "does not refer to an existing image in the images directory")
    end
  end

  # Helper method to determine the path to the images directory where image files are stored.
  # Adjust the path in this method if your images are stored in a different directory.
  # Centralizing the images directory path in this method makes it easy to update the path if needed.
  # Returns:
  # - A Pathname object representing the absolute path to the images directory.
  # Note:
  # - Using 'Rails.root.join' ensures compatibility across different environments and operating systems.
  def images_directory
    # 'Rails.root' returns the root directory of the Rails application.
    # The 'join' method constructs a path by joining directory names in a platform-independent way.
    # Here, it constructs the path 'app/assets/images' relative to the Rails root.
    Rails.root.join("app", "assets", "images")
  end
end
