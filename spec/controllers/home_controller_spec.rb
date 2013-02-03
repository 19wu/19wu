require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    login_user
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "POST content_preview" do
    it "returns http response" do
      post 'content_preview', :content => "# test"
      response.should be_success
      JSON.parse(response.body)["result"].should == "<h1>test</h1>"
    end
  end

end
