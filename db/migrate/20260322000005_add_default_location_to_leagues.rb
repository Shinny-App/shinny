class AddDefaultLocationToLeagues < ActiveRecord::Migration[8.1]
  def change
    add_reference :leagues, :default_location, foreign_key: { to_table: :locations }, null: true
  end
end
