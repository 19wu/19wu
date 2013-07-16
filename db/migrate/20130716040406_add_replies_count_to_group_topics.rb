class AddRepliesCountToGroupTopics < ActiveRecord::Migration
  class GroupTopic < ActiveRecord::Base;end
  class GroupTopicReply < ActiveRecord::Base;end

  def change
    add_column :group_topics, :replies_count, :integer, :default => 0

    GroupTopic.reset_column_information
    GroupTopic.all.each do |topic|
      topic.update_attribute(:replies_count, GroupTopicReply.where(:group_topic_id => topic.id).count)
    end
  end
end
