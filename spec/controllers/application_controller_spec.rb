require File.expand_path('../../spec_helper', __FILE__)

describe ApplicationController do
  controller do
    def index
      render :text => 'index'
    end
    def create
      redirect_back_or '/'
    end
  end

  describe '#store_location' do
    it 'stores GET request' do
      get 'index', :id => 'test'
      expect(session[:previous_url]).to eq('/anonymous?id=test')
    end
    it 'skips POST request' do
      post 'create'
      expect(session[:previous_url]).to be_nil
    end
  end
  describe '#redirect_back_or' do
    context 'session previous_url is not set' do
      it 'redirect to specified default url' do
        post 'create'
        expect(page).to redirect_to('/')
      end
    end
    context 'session previous_url is set' do
      before { session[:previous_url] = '/back' }
      it 'redirect to previous url' do
        post 'create'
        expect(page).to redirect_to('/back')
      end
      it 'clears previous url in session' do
        post 'create'
        expect(session[:previous_url]).to be_nil
      end
    end
  end

  describe '#user_path' do
    controller do
      def show
        @user_path = user_path(params[:id])
        render :text => @user_path
      end
    end

    it 'generates /bob for string "bob"' do
      get 'show', :id => 'bob'
      assigns[:user_path].should == '/bob'
    end
    it 'generates /bob for user with login "bob"' do
      user = build(:user, :login => 'bob')
      get 'show', :id => user
      assigns[:user_path].should == '/bob'
    end
    it 'generates /u/events for user with login "events"' do
      user = build(:user, :login => 'events')
      get 'show', :id => user
      assigns[:user_path].should == '/u/events'
    end
  end
end
