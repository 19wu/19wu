# -*- coding: utf-8 -*-
class Sequence < ActiveRecord::Base
  def self.get
    date = Time.zone.today
    transaction do
      sequence = self.lock.where(date: date).first_or_create number: (Rails.env.production? ? 1000 : 0) # 生产环境从1000起计，避免与支付宝集成时 outer_trade_no 冲突
      sequence.increment! :number
      "#{date.to_s(:number)}#{sequence.number.to_s.rjust(4, '0')}" # TODO: exceed?
    end
  end
end
