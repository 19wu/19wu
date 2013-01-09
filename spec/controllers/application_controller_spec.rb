require File.expand_path('../../spec_helper', __FILE__)

describe ApplicationController do
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
