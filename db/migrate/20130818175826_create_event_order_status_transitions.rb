class CreateEventOrderStatusTransitions < ActiveRecord::Migration
  def change
    create_table :event_order_status_transitions do |t|
      t.references :event_order, index: true
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
    end
  end
end
