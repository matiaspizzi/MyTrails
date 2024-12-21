class CreateLeaderships < ActiveRecord::Migration[6.0]
  def change
    create_table :leaderships do |t|
      t.bigint :leader_id, null: false
      t.bigint :employee_id, null: false

      t.timestamps
    end

    add_index :leaderships, [:leader_id, :employee_id], unique: true
    add_foreign_key :leaderships, :users, column: :leader_id
    add_foreign_key :leaderships, :users, column: :employee_id
  end
end
