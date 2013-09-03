# -*- coding: utf-8 -*-
require 'spec_helper'

describe EventOrderParticipant do
  let(:user) { create(:user, :confirmed) }
  let(:event) { create(:event, user: user) }
  let(:order) { create(:order_with_items, event: event) }
  let(:participant) { order.create_participant }
  let(:trade_no) { '2013080841700373' }

  describe 'create' do
    subject { participant }
    describe 'checkin_code' do
      its(:checkin_code) { should_not be_blank }
    end
    describe 'notification' do
      before do
        event.update_attribute :start_time, Time.zone.local(2013, 8, 18, 15, 30, 20)
        EventOrderParticipant.stub(:random_code).and_return('123456')
      end
      describe 'by email' do
        let(:mail) { double('mail') }
        context 'event is not finished' do
          it 'should be send' do
            mail.should_receive(:deliver)
            OrderMailer.should_receive(:notify_user_checkin_code).and_return(mail)
            subject
          end
        end
        context 'event is finished' do
          before do
            Timecop.travel(2013, 8, 28, 15, 30, 20)
            event.update_attribute :end_time, Time.zone.local(2013, 8, 18, 15, 30, 20)
          end
          after { Timecop.return }
          it 'should not be send' do
            OrderMailer.should_not_receive(:notify_user_checkin_code)
            subject
          end
        end
      end
      describe 'by sms' do
        context 'event is not finished' do
          it 'should be send' do
            ChinaSMS.should_receive(:to).with(order.user.phone, I18n.t('sms.event.order.checkin_code', event_title: event.title,  checkin_code: '123456', event_start_time: '8月18日 15:30'))
            subject
          end
        end
        context 'event is finished' do
          before do
            Timecop.travel(2013, 8, 28, 15, 30, 20)
            event.update_attribute :end_time, Time.zone.local(2013, 8, 18, 15, 30, 20)
          end
          after { Timecop.return }
          it 'should not be send' do
            ChinaSMS.should_not_receive(:to)
            subject
          end
        end
      end
    end
  end

  describe 'checkin' do
    let(:participant) { order.participant.reload }
    before { order.pay! trade_no }
    context 'valid code' do
      it 'should not raise error' do
        expect{participant.checkin!}.not_to raise_error
      end
    end
    context 'used code' do
      before { participant.checkin! }
      it 'should raise error' do
        expect{participant.checkin!}.to raise_error ActiveRecord::RecordInvalid
      end
    end
    context 'with request_pending order' do
      before do
        event.update_attributes start_time: 10.days.since, end_time: 10.days.since
        order.request_refund!
      end
      it 'should raise error' do
        expect{participant.checkin!}.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end
end
