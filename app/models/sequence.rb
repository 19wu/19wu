class Sequence < ActiveRecord::Base
  def self.get
    date = Time.zone.today
    transaction do
      sequence = self.lock.where(date: date).first_or_create
      sequence.increment! :number
      "#{date.to_s(:number)}#{sequence.number.to_s.rjust(4, '0')}" # TODO: exceed?
    end
  end
end
