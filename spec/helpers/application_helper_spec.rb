require 'spec_helper'

describe ApplicationHelper do
  describe 'render_close_icon' do
    subject { helper.render_close_icon }

    it { should have_selector('a.close') }
  end

  describe 'flash_class' do
    subject { helper.flash_class(flash_key) }
    context 'when flash key is :notice' do
      let(:flash_key) { :notice }
      it { should == 'alert-success' }
    end
    context 'when flash key is :error' do
      let(:flash_key) { :error }
      it { should == 'alert-error' }
    end
  end

  describe 'body_attributes' do
    subject { helper.body_attributes }
    context 'when user has signed in' do
      before do
        helper.should_receive(:user_signed_in?).with().and_return(true)
      end

      its([:class]) { should include('signed_in') }
    end
    context 'when user has not yet signed in' do
      before do
        helper.should_receive(:user_signed_in?).with().and_return(false)
      end
      its([:class]) { should include('signed_out') }
    end
  end
end
