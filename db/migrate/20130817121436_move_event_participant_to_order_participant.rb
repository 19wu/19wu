# -*- coding: utf-8 -*-
class MoveEventParticipantToOrderParticipant < ActiveRecord::Migration
  class EventParticipant < ActiveRecord::Base # faux model
    belongs_to :event
    belongs_to :user
  end

  module ChinaSMS; def to(*params); end; end # don't send sms
  class OrderMailer; def self.delay; self; end; end # and don't send email
  class OrderMailer; def self.method_missing(*a); end; end

  def up
    EventParticipant.all.each do |participant|
      event = participant.event
      ticket = event.tickets.first_or_create name: '门票', price: 0
      order = event.orders.create user: participant.user, items_attributes: [{ticket: ticket, quantity: 1}]
      if participant.joined
        order.participant.update_attribute :checkin_at, participant.updated_at
      end
    end
    drop_table :event_participants
  end

  def down
    create_table :event_participants do |t|
      t.integer :event_id
      t.integer :user_id
      t.boolean :joined, null: false, default: false

      t.timestamps
    end
    add_index :event_participants, :event_id
    add_index :event_participants, :user_id

    EventOrderParticipant.all.each do |participant|
      EventParticipant.create event: participant.event, user: participant.user, joined: !!participant.joined?
    end
  end
end
