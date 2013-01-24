class EventObserver < ActiveRecord::Observer
  def before_create(event)
    save_group event
  end

  def before_update(event)
    group = event.group
    group.destroy if group and group.slug != event.slug and group.events.size <= 1
    save_group event
  end

  private
  def save_group(event)
    group = event.user.groups.where(:slug => event.slug).first_or_create!
    event.group = group
  end
end
