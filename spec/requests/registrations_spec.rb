require "rails_helper"

RSpec.describe "Registrations", type: :request do
  describe "GET /registration/new" do
    it "returns http success" do
      get new_registration_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /registration" do
    let(:valid_params) do
      { user: { email_address: "new@example.com", password: "password123", password_confirmation: "password123", name: "Jane", surname: "Smith" } }
    end

    it "creates a user and redirects to root" do
      expect { post registration_path, params: valid_params }.to change { User.count }.by(1)
      expect(response).to redirect_to(root_path)
    end

    it "assigns employee role by default" do
      post registration_path, params: valid_params
      expect(User.last.role).to eq("employee")
    end

    it "rejects duplicate email" do
      create(:user, email_address: "new@example.com")
      expect { post registration_path, params: valid_params }.not_to change { User.count }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
