class CreateAuthenDiscords < ActiveRecord::Migration[6.1]
  def change
    create_table :authen_discords do |t|
      t.string :email
      t.string :provider
      t.string :access_token
      t.string :refresh_token
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
