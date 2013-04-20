class CreateFallbackUrls < ActiveRecord::Migration
  def change
    create_table :fallback_urls do |t|
      t.string :origin
      t.string :change_to

      t.timestamps
    end
    add_index :fallback_urls, :origin, unique: true
  end
end
