class ChangeDefaultForStatusInObjectives < ActiveRecord::Migration[6.0]
  def change
    change_column_default :objectives, :status, 'New'
  end
end
