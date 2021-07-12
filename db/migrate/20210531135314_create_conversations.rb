class CreateConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|
      t.integer :recipient_id
      t.integer :sender_id
      t.integer :chatable_id
      t.string :chatable_type

      t.timestamps
    end
    add_index :conversations, :recipient_id
    add_index :conversations, :sender_id
  end
end
