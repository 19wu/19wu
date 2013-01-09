require File.expand_path('../../spec_helper', __FILE__)

describe ProfilesController do
  describe '#show' do
    context 'not logged in' do
      before { get 'show' }
      it 'redirects to login page' do
        response.should redirect_to(new_user_session_path)
      end
    end

    context 'logged in' do
      let(:user) { create(:user, :confirmed) }
      before { login_user(user) }
      before { get 'show' }
      it 'renders the page' do
        response.should render_template('show')
      end
      it 'assigns current user profile' do
        assigns[:profile].user.should == user
      end
    end
  end

  describe '#update' do
    context 'not logged in' do
      before { put 'update' }
      it 'redirects to login page' do
        response.should redirect_to(new_user_session_path)
      end
    end

    context 'logged in' do
      let(:user) { create(:user, :confirmed) }
      let(:profile_attributes) {
        attributes_for(:profile, :autofill, :user => user).except(:user)
      }

      before { login_user(user) }
      before { put 'update', :profile => profile_attributes }

      it 'updates current user profile' do
        user.reload.profile.name.should == profile_attributes[:name]
      end
      it 'shows success flash message' do
        flash[:notice].should == I18n.t('flash.profiles.updated')
      end
      it 'redirects to profile setting page' do
        response.should redirect_to(profile_path)
      end
    end
  end
end
