module EventJoinHelper
  def joined?(event)
    current_user && current_user.joined?(event) ? true : false
  end

  def init_join(event)
    options = {
      'user.joined' => event.has?(current_user) ? true : false,
      labels: t('views.join.state'),
      titles: t('views.join.title')
    }
    options.to_ng_init
  end
end
