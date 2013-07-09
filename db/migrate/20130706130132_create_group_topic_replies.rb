class CreateGroupTopicReplies < ActiveRecord::Migration
  def change
    create_table :group_topic_replies do |t|
      t.text :body
      t.integer :group_topic_id, null: false
      t.integer :user_id       , null: false

      t.timestamps
    end
    add_index :group_topic_replies, :group_topic_id
  end
end
