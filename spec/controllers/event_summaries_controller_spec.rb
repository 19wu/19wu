require 'spec_helper'

describe EventSummariesController do

  describe "GET new" do
    let(:user) { create(:user, :confirmed) }
    let(:event) { create(:event, user: user) }

    it "should render template :new" do
      login_user user
      get :new, event_id: event.id
      expect(response).to render_template(:new)
    end

    it "should set variable @event" do
      login_user user
      get :new, event_id: event.id
      expect(assigns(:event)).to eq(event)
    end

    it "should set variable @summary to a new EventSummary object" do
      login_user user
      get :new, event_id: event.id
      expect(assigns(:summary)).to be_a_new(EventSummary)
    end
  end

  describe "POST create" do
    let(:user) { create(:user, :confirmed) }
    let(:event) { create(:event, user: user) }

    context "with valid input" do
      it "should save event_summary to DB" do
        login_user user
        event_summary_attributes = FactoryGirl.attributes_for(:event_summary, :event => event)
        expect {
          post :create, event_id: event.id, event_summary: event_summary_attributes
        }.to change{ EventSummary.count }.by(1)
      end

      it "should redirect to event show page" do
        login_user user
        event_summary_attributes = FactoryGirl.attributes_for(:event_summary, :event => event)
        post :create, event_id: event.id, event_summary: event_summary_attributes
        expect(response).to redirect_to event_path(event)
      end
    end

    context "with invalid input" do
      it "should not save event_summary to DB" do
        login_user user
        expect {
          post :create, event_id: event.id, event_summary: { content: "test" }
        }.to change{ EventSummary.count }.by(0)
      end

      it "should render new template" do
        login_user user
        post :create, event_id: event.id, event_summary: { content: "test" }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH update" do
    let(:user) { create(:user, :confirmed) }
    let(:event) { create(:event, user: user) }

    context "with valid data" do
      it "should update event summary" do
        login_user user
        summary = create(:event_summary, event: event)
        patch :update, event_id: event.id, event_summary: { content: "12345678900987654321" }
        expect(summary.reload.content).to eq("12345678900987654321")
      end

      it "should redirect to event show page" do
        login_user user
        summary = create(:event_summary, event: event)
        patch :update, event_id: event.id, event_summary: { content: "12345678900987654321" }
        expect(response).to redirect_to event_path(event)
      end
    end

    context "with invalid data" do
      it "should not update event summary" do
        login_user user
        summary = create(:event_summary, event: event)
        patch :update, event_id: event.id, event_summary: { content: "abc" }
        expect(summary.reload.content).to_not eq("abc")
      end

      it "should render :new template" do
        login_user user
        summary = create(:event_summary, event: event)
        patch :update, event_id: event.id, event_summary: { content: "abc" }
        expect(response).to render_template(:new)
      end
    end
  end
end
