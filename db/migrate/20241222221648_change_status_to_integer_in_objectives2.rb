class ChangeStatusToIntegerInObjectives2 < ActiveRecord::Migration[6.0]
  def change
    change_column :objectives, :status, :integer, using: 'status::integer', default: 0
  end
end
