require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      expect(build(:user)).to be_valid
    end

    it "requires email_address" do
      expect(build(:user, email_address: nil)).not_to be_valid
    end

    it "requires unique email_address" do
      create(:user, email_address: "test@example.com")
      expect(build(:user, email_address: "test@example.com")).not_to be_valid
    end

    it "requires a valid email format" do
      expect(build(:user, email_address: "not-an-email")).not_to be_valid
    end

    it "normalizes email to lowercase" do
      user = create(:user, email_address: "TEST@EXAMPLE.COM")
      expect(user.email_address).to eq("test@example.com")
    end

    it "requires password" do
      expect(build(:user, password: nil)).not_to be_valid
    end
  end

  describe "associations" do
    it "has many sessions" do
      user = create(:user)
      expect { user.sessions.create!(user_agent: "test", ip_address: "127.0.0.1") }.to change { Session.count }.by(1)
    end

    it "destroys sessions when user is destroyed" do
      user = create(:user)
      user.sessions.create!(user_agent: "test", ip_address: "127.0.0.1")
      expect { user.destroy }.to change { Session.count }.by(-1)
    end

    it "has many objectives as employee" do
      user = create(:user)
      create(:objective, employee: user)
      expect(user.objectives.count).to eq(1)
    end

    it "has many employees through leaderships" do
      leader = create(:user, :leader)
      employee = create(:user)
      create(:leadership, leader: leader, employee: employee)
      expect(leader.employees).to include(employee)
    end

    it "has many leaders through inverse_leaderships" do
      leader = create(:user, :leader)
      employee = create(:user)
      create(:leadership, leader: leader, employee: employee)
      expect(employee.leaders).to include(leader)
    end
  end

  describe "#confirm!" do
    it "sets confirmed_at and clears confirmation_token" do
      user = create(:user, :unconfirmed, confirmation_token: "abc123")
      user.confirm!
      expect(user.confirmed_at).not_to be_nil
      expect(user.confirmation_token).to be_nil
    end
  end

  describe "#confirmed?" do
    it "returns true when confirmed_at is set" do
      expect(build(:user)).to be_confirmed
    end

    it "returns false when confirmed_at is nil" do
      expect(build(:user, :unconfirmed)).not_to be_confirmed
    end
  end
end
