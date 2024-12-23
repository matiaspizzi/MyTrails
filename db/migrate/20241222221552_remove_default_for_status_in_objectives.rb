class RemoveDefaultForStatusInObjectives < ActiveRecord::Migration[6.0]
  def change
    change_column_default :objectives, :status, nil
  end
end