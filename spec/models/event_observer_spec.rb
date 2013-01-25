require 'spec_helper'

describe EventObserver do
  context 'save' do
    subject { create :event }
    its(:group) { should_not be_nil }
  end
  context 'update' do
    subject { create :event }
    describe 'orgin group' do
      context 'has not events' do
        it 'should be destroy' do
          subject
          expect do
            subject.update_attributes! :slug => 'rubyconf'
          end.not_to change{Group.count}
        end
      end
      context 'still has events' do
        before { create :event, user: subject.user }
        it 'should not be destroy' do
          expect do
            subject.update_attributes! :slug => 'rubyconf'
          end.to change{Group.count}.by(1)
        end
      end
    end
  end
end
