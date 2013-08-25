class CreateSequences < ActiveRecord::Migration
  def change
    create_table :sequences do |t|
      t.date :date     , null: false
      t.integer :number, null: false, default: 0

      t.timestamps
    end
  end
end
