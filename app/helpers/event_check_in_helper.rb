module EventCheckInHelper
  def init_checkin(event)
    options = {}
    if current_user
      options[:outdate] = event.end_time ? event.end_time.past? : event.start_time.to_date.past?
      options[:message] = t("flash.participants.checkin_welcome") if checked_in?(event)
    end
    options.to_ng_init
  end

  def checked_in?(event)
    !!(current_user && current_user.checked_in?(event))
  end
end
