# Require the 'uuid7' library to use UUID version 7 for generating unique identifiers.
# UUID version 7 is a time-based UUID that incorporates a timestamp as part of its structure,
# making it suitable for scenarios where chronological ordering of identifiers is important.
require "uuid7"

# Define the ApplicationRecord class, which inherits from ActiveRecord::Base.
# This serves as the base class for all models in the application.
# By using a primary abstract class, Rails will not create a corresponding table for this class.
# Instead, it allows other models to inherit from it, sharing common behavior and functionality.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  private

    # Define a private method named `generate_uuid_v7`.
    # This method is responsible for generating a UUID version 7 for the record.
    # It ensures that a unique identifier is assigned to the `id` attribute of the model
    # only if it has not already been set. This is particularly useful for creating new records
    # where a UUID is required as the primary key.

    def generate_uuid_v7
      # The self.id ||= UUID7.generate statement assigns a new UUID only if self.id is currently nil or false.
      # This lazy assignment is crucial for maintaining the integrity of the ID field,
      # ensuring that it is populated with a unique identifier only once during the object's lifecycle.
      self.id ||= UUID7.generate
    end
end
