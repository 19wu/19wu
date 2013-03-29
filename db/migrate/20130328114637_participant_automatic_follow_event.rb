class ParticipantAutomaticFollowEvent < ActiveRecord::Migration
  def up
    Event.all.each do |event|
      group = event.group
      event.participated_users.each do |user|
        user.follow group
      end
    end
  end

  def down
  end
end
