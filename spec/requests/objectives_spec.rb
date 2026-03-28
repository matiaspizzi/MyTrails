require "rails_helper"

RSpec.describe "Objectives", type: :request do
  let(:employee) { create(:user) }
  let(:other_employee) { create(:user) }
  let(:leader) { create(:user, :leader) }
  let(:admin) { create(:user, :admin) }
  let(:objective) { create(:objective, employee: employee) }

  describe "POST /objectives" do
    context "when authenticated" do
      it "creates an objective and redirects" do
        sign_in(employee)
        expect {
          post objectives_path, params: { objective: { title: "New Goal", description: "Details", estimated_completion_at: 30.days.from_now } }
        }.to change { Objective.count }.by(1)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post objectives_path, params: { objective: { title: "Goal", description: "Details", estimated_completion_at: 30.days.from_now } }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "PATCH /objectives/:id" do
    context "as the owner" do
      it "updates the objective" do
        sign_in(employee)
        patch objective_path(objective), params: { objective: { status: "In_Progress" } }
        expect(response).to redirect_to(root_path)
        expect(objective.reload.status).to eq("In_Progress")
      end
    end

    context "as a different employee" do
      it "is forbidden" do
        sign_in(other_employee)
        patch objective_path(objective), params: { objective: { status: "In_Progress" } }
        expect(response).to redirect_to(root_path)
        expect(objective.reload.status).to eq("New")
      end
    end
  end

  describe "DELETE /objectives/:id" do
    context "as the owner" do
      it "destroys the objective" do
        sign_in(employee)
        delete objective_path(objective)
        expect(response).to redirect_to(root_path)
        expect(Objective.find_by(id: objective.id)).to be_nil
      end
    end

    context "as the owner with a Done objective" do
      it "does not destroy and redirects with alert" do
        done_objective = create(:objective, :done, employee: employee)
        sign_in(employee)
        delete objective_path(done_objective)
        expect(response).to redirect_to(root_path)
        expect(Objective.find_by(id: done_objective.id)).to be_present
      end
    end

    context "as a different employee" do
      it "is forbidden" do
        sign_in(other_employee)
        expect { delete objective_path(objective) }.not_to change { Objective.count }
      end
    end
  end

  describe "POST /objective/rate" do
    let(:in_review_objective) { create(:objective, :in_review, employee: employee) }

    context "as a leader" do
      it "rates the objective" do
        sign_in(leader)
        post rate_objective_path, params: { id: in_review_objective.id, rating: 5 }
        expect(in_review_objective.reload.rating).to eq(5)
        expect(in_review_objective.reload.status).to eq("Done")
      end
    end

    context "as an employee" do
      it "is forbidden" do
        sign_in(employee)
        post rate_objective_path, params: { id: in_review_objective.id, rating: 5 }
        expect(response).to redirect_to(root_path)
        expect(in_review_objective.reload.rating).to be_nil
      end
    end
  end
end
