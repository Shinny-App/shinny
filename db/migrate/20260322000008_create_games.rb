class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.references :league, null: false, foreign_key: true
      t.references :home_team, null: false, foreign_key: { to_table: :teams }
      t.references :away_team, null: false, foreign_key: { to_table: :teams }
      t.references :location, null: true, foreign_key: true
      t.datetime :scheduled_at, null: false
      t.integer :home_score
      t.integer :away_score
      t.integer :status, null: false, default: 0
      t.datetime :rsvp_deadline

      t.timestamps
    end
  end
end
