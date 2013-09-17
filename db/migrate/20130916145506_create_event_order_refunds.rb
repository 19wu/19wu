class CreateEventOrderRefunds < ActiveRecord::Migration
  def change
    create_table :event_order_refunds do |t|
      t.integer :order_id, null: false
      t.integer :amount_in_cents, null: false
      t.string :reason
      t.string :status, null: false, limit: 16

      t.timestamps
    end
  end
end
