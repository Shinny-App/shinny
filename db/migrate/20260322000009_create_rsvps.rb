class CreateRsvps < ActiveRecord::Migration[8.1]
  def change
    create_table :rsvps do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.integer :response, null: false
      t.datetime :responded_at, null: false

      t.timestamps
    end

    add_index :rsvps, [ :user_id, :game_id ], unique: true
  end
end
