class CreateEventSummaries < ActiveRecord::Migration
  def up
    create_table :event_summaries do |t|
      t.text :content
      t.integer :event_id
      
      t.timestamp
    end
  end

  def down
    drop_table :event_summaries
  end
end
