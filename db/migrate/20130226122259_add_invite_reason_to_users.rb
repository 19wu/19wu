class AddInviteReasonToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invite_reason, :string
  end
end
