require 'spec_helper'

describe Sequence do
  before { Timecop.freeze('2013-08-25') }
  after { Timecop.return }
  describe '#get' do
    subject { Sequence.get }
    context 'do not exist record' do
      it { should eql '201308250001' }
    end
    context 'exist record' do
      context 'in the same day' do
        before { create(:sequence, date: Time.zone.today, number: 1) }
        it { should eql '201308250002' }
      end
      context 'in the other day' do
        before { create(:sequence, date: 1.day.ago, number: 1) }
        it { should eql '201308250001' }
      end
    end
  end
end
