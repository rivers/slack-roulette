class CreateAccessTokens < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :token,   null: false
      t.string :scope,   null: false
      t.string :team_id, null: false
      t.string :name,    null: false

      t.timestamps null: false

      t.index :team_id, unique: true
    end
  end
end
