class CreateGroups < ActiveRecord::Migration
  def up
    create_table :groups do |t|
      t.integer :user_id, :null => false
      t.string :slug, :null => false

      t.timestamps
    end
    add_index :groups, :slug, :unique => true

    add_column :events, :group_id, :integer
    add_index :events, :group_id
    Event.all.each do |event|
      event.update_attributes! :slug => "e#{event.id}"
    end
    change_column :events, :group_id, :integer, :null => false
  end

  def down
    drop_table :groups
    remove_column :events, :group_id
  end
end
