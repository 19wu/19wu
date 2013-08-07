class CreateEventTickets < ActiveRecord::Migration
  def change
    create_table :event_tickets do |t|
      t.string :name
      t.float :price
      t.string :description
      t.boolean :require_invoice
      t.integer :event_id

      t.timestamps
    end
    add_column :events, :tickets_quantity, :integer
  end
end
