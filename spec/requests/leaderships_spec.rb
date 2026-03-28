require "rails_helper"

RSpec.describe "Leaderships", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:leader) { create(:user, :leader) }
  let(:employee) { create(:user) }

  describe "GET /leadership" do
    context "as admin" do
      it "returns http success" do
        sign_in(admin)
        get leadership_path
        expect(response).to have_http_status(:success)
      end
    end

    context "as non-admin" do
      it "redirects to root" do
        sign_in(create(:user))
        get leadership_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /leadership" do
    context "as admin" do
      it "creates a leadership" do
        sign_in(admin)
        expect {
          post leadership_create_path, params: { leadership: { leader_email: leader.email_address, employee_email: employee.email_address } }
        }.to change { Leadership.count }.by(1)
        expect(response).to redirect_to(leadership_path)
      end

      it "rejects same leader and employee" do
        sign_in(admin)
        post leadership_create_path, params: { leadership: { leader_email: leader.email_address, employee_email: leader.email_address } }
        expect(response).to redirect_to(leadership_path)
        expect(flash[:alert]).to be_present
      end

      it "rejects non-existent leader" do
        sign_in(admin)
        post leadership_create_path, params: { leadership: { leader_email: "nobody@example.com", employee_email: employee.email_address } }
        expect(flash[:alert]).to include("not found")
      end
    end

    context "as non-admin" do
      it "redirects to root" do
        sign_in(create(:user))
        post leadership_create_path, params: { leadership: { leader_email: leader.email_address, employee_email: employee.email_address } }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /leadership" do
    let!(:leadership) { create(:leadership, leader: leader, employee: employee) }

    context "as admin" do
      it "destroys the leadership" do
        sign_in(admin)
        expect {
          delete leadership_destroy_path(leadership.id)
        }.to change { Leadership.count }.by(-1)
      end
    end

    context "as non-admin" do
      it "redirects to root" do
        sign_in(create(:user))
        expect {
          delete leadership_destroy_path(leadership.id)
        }.not_to change { Leadership.count }
      end
    end
  end
end
