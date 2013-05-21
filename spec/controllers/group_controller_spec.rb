require 'spec_helper'

describe GroupController do

  describe "GET 'show'" do
    let(:event) { create :event }
    it "returns http success" do
      get 'event', :slug => event.group.slug
      response.should be_success
    end
  end

  describe "GET 'followers'" do
    let(:event) { create :event }
    it "returns http success" do
      get 'event', :slug => event.group.slug
      response.should be_success
    end
  end

end
