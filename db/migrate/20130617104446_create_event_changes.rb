class CreateEventChanges < ActiveRecord::Migration
  def change
    create_table :event_changes do |t|
      t.integer :event_id
      t.string :content

      t.timestamps
    end
    add_index :event_changes, :event_id
  end
end
