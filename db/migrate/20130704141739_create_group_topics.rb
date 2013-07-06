class CreateGroupTopics < ActiveRecord::Migration
  def change
    create_table :group_topics do |t|
      t.string :title
      t.text :body
      t.integer :user_id , null: false
      t.integer :group_id, null: false

      t.timestamps
    end
    add_index :group_topics, :group_id
  end
end
