# The User class represents a user in the application.
# It inherits from ApplicationRecord, which provides it with all the functionalities
# of Active Record models. Active Record facilitates the mapping between User objects
# and the corresponding database records. This class includes functionalities for
# authentication, validation, and managing user data.

class User < ApplicationRecord
  # ============================================================================
  # Validations
  # ============================================================================

  # Include the has_secure_password method to enable secure password handling.
  # This method adds functionalities to set and authenticate against a BCrypt password.
  # It requires a password_digest attribute in the model to store the hashed password.
  has_secure_password

  # Validate that the username attribute is present and meets specific criteria.
  # This validation ensures that:
  # - The username cannot be nil or empty (presence: true).
  # - The username must match the defined format, allowing only alphanumeric characters.
  # - The uniqueness constraint ensures that no two users can have the same username,
  #   and the check is case insensitive (e.g., 'User' and 'user' are considered the same).
  validates :username, presence: true,
                       format: { with: /\A[A-Z0-9]+\z/i },
                       uniqueness: { case_sensitive: false }

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

  # ============================================================================
  # Callbacks
  # ============================================================================

  # Callback that is triggered before creating a new user record.
  # This calls the `generate_uuid_v7` method defined in ApplicationRecord,
  # ensuring that each new user receives a unique UUID as their identifier
  # prior to being saved in the database. This is crucial for maintaining
  # the uniqueness and integrity of user identifiers in the application.
  before_create :generate_uuid_v7

  # ============================================================================
  # Instance Methods
  # ============================================================================

  # Additional instance methods can be defined here to encapsulate behavior
  # specific to user records. For example, methods for user-related actions,
  # profile management, or authorization checks.

  # ============================================================================
  # Class Methods
  # ============================================================================

  # Additional class methods can be defined here for querying or manipulating
  # collections of user records. This can include methods for user authentication,
  # user search functionalities, or batch operations.
end
