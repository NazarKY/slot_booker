class CreateSlot < ActiveRecord::Migration[7.0]
  def change
    create_table :slots, id: false do |t|
      t.string :uuid, primary_key: true
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.string :user_email
      t.integer :status, default: 0

      t.timestamps

      t.index :uuid, unique: true
    end
  end
end
