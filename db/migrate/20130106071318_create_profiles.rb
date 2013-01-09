class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :phone
      t.string :website
      t.text :bio
      t.references :user

      t.timestamps
    end
    add_index :profiles, :user_id
  end
end
