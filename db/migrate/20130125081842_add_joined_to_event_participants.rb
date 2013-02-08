class AddJoinedToEventParticipants < ActiveRecord::Migration
  def change
    add_column :event_participants, :joined, :boolean, :null => false, :default => false
  end
end
