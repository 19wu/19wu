class SendCheckinCodeSmsForFreeEvent < ActiveRecord::Migration
  def change
    Event.all.reject{|e| e.finished? or e.started?}.each do |event|
      event.orders.each do |order|
        order.create_participant if order.free? # 正在进行的免费活动补发签到码
      end
    end
  end
end
