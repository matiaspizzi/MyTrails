require "rails_helper"

RSpec.describe Leadership, type: :model do
  describe "validations" do
    it "is valid with a leader and employee" do
      expect(build(:leadership)).to be_valid
    end

    it "prevents duplicate leader-employee pairs" do
      leader = create(:user, :leader)
      employee = create(:user)
      create(:leadership, leader: leader, employee: employee)
      expect(build(:leadership, leader: leader, employee: employee)).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to a leader" do
      leadership = create(:leadership)
      expect(leadership.leader).to be_present
    end

    it "belongs to an employee" do
      leadership = create(:leadership)
      expect(leadership.employee).to be_present
    end

    it "is destroyed when leader is destroyed" do
      leader = create(:user, :leader)
      create(:leadership, leader: leader)
      expect { leader.destroy }.to change { Leadership.count }.by(-1)
    end

    it "is destroyed when employee is destroyed" do
      employee = create(:user)
      create(:leadership, employee: employee)
      expect { employee.destroy }.to change { Leadership.count }.by(-1)
    end
  end
end
