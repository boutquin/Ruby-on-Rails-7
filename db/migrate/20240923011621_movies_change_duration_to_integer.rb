class MoviesChangeDurationToInteger < ActiveRecord::Migration[7.2]
  def up
    change_column :movies, :duration, :integer
  end

  def down
    change_column :movies, :duration, :string
  end
end
