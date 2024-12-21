class CreateObjectives < ActiveRecord::Migration[6.0]
  def change
    create_table :objectives do |t|
      t.bigint :employee_id, null: false
      t.string :title, null: false
      t.text :description
      t.datetime :estimated_completion_at, null: false
      t.integer :rating
      t.bigint :rated_by # ID del líder que calificó el objetivo

      t.timestamps
    end

    add_index :objectives, :employee_id
    add_index :objectives, :rated_by
    add_foreign_key :objectives, :users, column: :employee_id
    add_foreign_key :objectives, :users, column: :rated_by
  end
end
