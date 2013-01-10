class CreateEventUserships < ActiveRecord::Migration
  def change
    create_table :event_userships do |t|
      t.integer :event_id
      t.integer :user_id

      t.timestamps
    end

    add_index :event_userships, :event_id
    add_index :event_userships, :user_id
  end
end
