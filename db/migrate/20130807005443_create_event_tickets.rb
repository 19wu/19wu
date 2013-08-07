class CreateEventTickets < ActiveRecord::Migration
  def change
    create_table :event_tickets do |t|
      t.string :name
      t.float :price
      t.string :description
      t.integer :event_id

      t.timestamps
    end
  end
end
