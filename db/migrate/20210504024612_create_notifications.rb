class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :notified_by_id
      t.string :event
      t.integer :notificationable_id
      t.string :notificationable_type
      t.boolean :seen, default: false

      t.timestamps
    end
  end
end
