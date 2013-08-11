module UserHelper
  def init_user
    options = {
      'user.id'    => current_user.id,
      'user.name'  => current_user.name,
      'user.phone' => current_user.phone
    }
    options.to_ng_init
  end
end
