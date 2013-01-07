class AddLocationGuideToEvents < ActiveRecord::Migration
  def change
    add_column :events, :location_guide, :text
  end
end
