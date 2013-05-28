require 'spec_helper'

describe AutocompleteController do

  describe "GET 'users'" do
    let(:user) { login_user }
    it "returns http success" do
      get 'users', login: user.login
      response.should be_success
      JSON.parse(response.body).should eql [user.login]
    end
  end

end
