class AddFieldsToMovies < ActiveRecord::Migration[7.2]
  def change
    add_column :movies, :description, :text
    add_column :movies, :released_on, :date
  end
end
