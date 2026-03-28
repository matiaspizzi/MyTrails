require "rails_helper"

RSpec.describe Objective, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      expect(build(:objective)).to be_valid
    end

    it "requires title" do
      expect(build(:objective, title: nil)).not_to be_valid
    end

    it "requires description" do
      expect(build(:objective, description: nil)).not_to be_valid
    end

    it "requires estimated_completion_at" do
      expect(build(:objective, estimated_completion_at: nil)).not_to be_valid
    end

    it "requires estimated_completion_at to be in the future" do
      expect(build(:objective, estimated_completion_at: 1.day.ago)).not_to be_valid
    end

    it "defaults status to New" do
      objective = create(:objective)
      expect(objective.status).to eq("New")
    end
  end

  describe "associations" do
    it "belongs to an employee" do
      employee = create(:user)
      objective = create(:objective, employee: employee)
      expect(objective.employee).to eq(employee)
    end

    it "belongs to a rater (optional)" do
      expect(build(:objective, rater: nil)).to be_valid
    end
  end

  describe "enums" do
    it "transitions through valid statuses" do
      objective = create(:objective)
      expect(objective).to be_New
      objective.In_Progress!
      expect(objective).to be_In_Progress
      objective.In_Review!
      expect(objective).to be_In_Review
      objective.Done!
      expect(objective).to be_Done
    end
  end
end
