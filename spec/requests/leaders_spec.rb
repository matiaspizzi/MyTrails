require "rails_helper"

RSpec.describe "Leaders", type: :request do
  describe "GET /leader_dashboard" do
    context "as leader" do
      it "returns http success" do
        sign_in(create(:user, :leader))
        get leader_dashboard_path
        expect(response).to have_http_status(:success)
      end
    end

    context "as employee" do
      it "redirects with alert" do
        sign_in(create(:user))
        get leader_dashboard_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "as admin" do
      it "redirects with alert" do
        sign_in(create(:user, :admin))
        get leader_dashboard_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        get leader_dashboard_path
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
