class CreateLeagues < ActiveRecord::Migration[8.1]
  def change
    create_table :leagues do |t|
      t.string :name, null: false
      t.text :description
      t.integer :league_type, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
