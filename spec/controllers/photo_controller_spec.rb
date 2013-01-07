require 'spec_helper'

describe PhotoController do

  describe "POST 'create'" do
    let(:path) { Rails.root.join("spec/factories/data/event/map.png") }
    let(:file) { Rack::Test::UploadedFile.new(path) }
    context 'when user has signed in' do
      login_user
      it 'creates the photo' do
        expect {
          post :create, :file => file
          JSON[response.body][:url].should_not be_blank
        }.to change{Photo.count}.by(1)
      end
    end
    context 'when user has not yet signed in' do
      before { post :create, :file => file }
      it {should redirect_to new_user_session_path }
    end
  end

end
