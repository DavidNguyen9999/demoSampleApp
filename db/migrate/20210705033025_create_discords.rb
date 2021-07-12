class CreateDiscords < ActiveRecord::Migration[6.1]
  def change
    create_table :discords do |t|
      t.string :discord_url
      t.integer :recipient_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
