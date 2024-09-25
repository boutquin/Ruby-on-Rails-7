# Define the User class, which inherits from ApplicationRecord.
# This class represents a user in the application and includes functionality
# for authentication, validation, and managing user data.
class User < ApplicationRecord
  # Include the has_secure_password method to enable secure password handling.
  # This method adds functionalities to set and authenticate against a BCrypt password.
  # It requires a password_digest attribute in the model to store the hashed password.
  has_secure_password

  # Validate the presence of the name attribute.
  # This ensures that a user cannot be created or updated without a name,
  # enforcing data integrity and improving user experience.
  validates :name, presence: true

  # Validate the presence of the email attribute.
  # Additionally, it checks that the email format is valid according to the regular expression
  # defined in URI::MailTo::EMAIL_REGEXP. This helps in ensuring that users provide a valid email format.
  # The uniqueness validation ensures that no two users can have the same email address,
  # ignoring case sensitivity, to maintain user uniqueness in the system.
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { case_sensitive: false }

  # Validate the password attribute.
  # This rule enforces that the password must be at least 6 characters long.
  # The allow_blank: true option allows users to update their information without requiring
  # a password to be set, which is useful for user updates that don't change the password.
  validates :password, length: { minimum: 6, allow_blank: true }

  # Callback that is triggered before creating a new user record.
  # This calls the `generate_uuid_v7` method defined in ApplicationRecord,
  # ensuring that each new user receives a unique UUID as their identifier
  # prior to being saved in the database. This is crucial for maintaining
  # the uniqueness and integrity of user identifiers in the application.
  before_create :generate_uuid_v7
end
