require "rails_helper"

RSpec.describe "Sessions", type: :request do
  describe "GET /sign_in" do
    it "returns http success when unauthenticated" do
      get sign_in_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /sign_in" do
    let(:user) { create(:user, email_address: "test@example.com", password: "password123") }

    it "signs in with valid credentials and redirects" do
      post sign_in_path, params: { email_address: user.email_address, password: "password123" }
      expect(response).to redirect_to(root_path)
    end

    it "rejects invalid credentials" do
      post sign_in_path, params: { email_address: user.email_address, password: "wrong" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /sign_out" do
    it "signs out and redirects to sign in" do
      user = create(:user)
      sign_in(user)
      delete sign_out_path
      expect(response).to redirect_to(new_session_path)
    end
  end
end
