class CreateRefundBatches < ActiveRecord::Migration
  def change
    create_table :refund_batches do |t|
      t.string :batch_no, null: false, limit: 24
      t.string :status  , null: false, limit: 16

      t.timestamps
    end
  end
end
