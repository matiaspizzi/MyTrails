class AddIndexesToObjectivesAndUsers < ActiveRecord::Migration[8.0]
  def change
    add_index :objectives, :status
    add_index :objectives, [ :employee_id, :status ]
    add_index :users, :role
  end
end
