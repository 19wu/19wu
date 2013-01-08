require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    login_user
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end
end
