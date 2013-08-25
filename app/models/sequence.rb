class Sequence < ActiveRecord::Base
  def self.get
    date = Time.zone.today
    sequnce = self.lock.where(date: date).first_or_create
    sequnce.increment :number
    "#{date.to_s(:number)}#{sequnce.number.to_s.rjust(4, '0')}" # TODO: exceed?
  end
end
