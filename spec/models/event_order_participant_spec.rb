# -*- coding: utf-8 -*-
require 'spec_helper'

describe EventOrderParticipant do
  let(:user) { create(:user, :confirmed) }
  let(:event) { create(:event, user: user) }
  let(:order) { create(:order_with_items, event: event) }

  describe 'create' do
    subject { order.create_participant }
    describe 'checkin_code' do
      its(:checkin_code) { should_not be_blank }
    end
    describe 'notification' do
      describe 'by sms' do
        before do
          event.update_attribute :start_time, Time.zone.local(2013, 8, 18, 15, 30, 20)
          EventOrderParticipant.stub(:random_code).and_return('123456')
        end
        it 'should be send' do
          ChinaSMS.should_receive(:to).with(order.user.phone, I18n.t('sms.event.order.checkin_code', event_title: event.title,  checkin_code: '123456', event_start_time: '8月18日 15:30'))
          subject
        end
      end
    end
  end
end
