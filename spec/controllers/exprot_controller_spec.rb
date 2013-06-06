require 'spec_helper'

describe ExportController do

  describe "GET 'index'" do
    let(:user) { login_user }
    let(:event) { create(:event, user: user) }

    it "renders the export index" do
      get 'index', :event_id => event.id
      response.should render_template('index')
    end
  end

end
