class MovePhoneToUsers < ActiveRecord::Migration
  def up
    add_column :users, :phone, :string
    User.all.each do |user|
      user.phone = user.profile.phone
      user.save
    end
    remove_column :profiles, :phone
  end

  def down
    add_column :profiles, :phone, :string
    Profile.all.each do |profile|
      profile.phone = profile.user.phone
      profile.save
    end
    remove_column :users, :phone
  end
end
