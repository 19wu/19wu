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
    context 'when event is show' do
      before do
        helper.should_receive(:user_signed_in?).and_return(false)
        helper.should_receive(:controller_name).and_return('mockup')
        helper.should_receive(:action_name).and_return('event')
      end
      its([:class]) { should include('l-event') }
    end
  end

  describe 'render_user_bar' do
    def render
      helper.render_user_bar
    end

    context 'when user has signed in' do
      before do
        helper.should_receive(:user_signed_in?).with().and_return(true)
      end

      it 'renders signed_in_user_bar' do
        helper.should_receive(:render).with('signed_in_user_bar').once
        render
      end
    end
    context 'when user has not yet signed in' do
      before do
        helper.should_receive(:user_signed_in?).with().and_return(false)
      end

      it 'renders signed_out_user_bar' do
        helper.should_receive(:render).with('signed_out_user_bar').once
        render
      end
    end
  end

  describe 'render_flashes' do
    context 'when it is called twice' do
      it 'only renders flashes once' do
        helper.should_receive(:render).with('flashes').once

        helper.render_flashes
        helper.render_flashes
      end
    end
  end

  describe '#render_password_label_with_forget_link' do
    let(:object) { build :user }
    subject { helper.render_password_label_with_forget_link(object) }

    it { should have_selector('small > a') }
    it { should have_content(object.class.human_attribute_name(:password)) }
    it { should have_content(t('devise.views.links.forget_pass')) }
  end

  describe '#render_settings_tab' do
    context 'current controller_name is registrations' do
      before { helper.stub(:controller_name).and_return('registrations') }

      context 'render account tab' do
        subject { helper.render_settings_tab('account', '/account', 'registrations') }
        it 'adds active class' do
          subject.should have_selector('li.active')
        end
        it 'uses #settings-main as link href' do
          subject.should have_selector('a[href="#settings-main"]')
        end
      end

      context 'render profile tab' do
        subject { helper.render_settings_tab('profile', '/profile', 'profiles') }
        it 'does not add active class' do
          subject.should_not have_selector('li.active')
        end
        it 'uses profile_path as link href' do
          subject.should have_selector('a[href="/profile"]')
        end
      end

    end
  end
end
