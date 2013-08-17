class CreateEventOrderParticipants < ActiveRecord::Migration
  def change
    create_table :event_order_participants do |t|
      t.integer :order_id   , null: false
      t.integer :event_id   , null: false
      t.integer :user_id    , null: false
      t.string :checkin_code, null: false, limit: 6
      t.datetime :checkin_at

      t.timestamps
    end
    add_index :event_order_participants, [:event_id, :checkin_code], unique: true
  end
end
