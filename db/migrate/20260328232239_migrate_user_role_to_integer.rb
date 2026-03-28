class MigrateUserRoleToInteger < ActiveRecord::Migration[8.0]
  ROLE_MAP = { "employee" => 0, "leader" => 1, "admin" => 2 }.freeze

  def up
    add_column :users, :role_int, :integer, default: 0, null: false

    User.reset_column_information
    User.find_each do |user|
      user.update_column(:role_int, ROLE_MAP.fetch(user.role, 0))
    end

    remove_column :users, :role
    rename_column :users, :role_int, :role

    add_check_constraint :users, "role IN (0, 1, 2)", name: "check_users_role"
  end

  def down
    remove_check_constraint :users, name: "check_users_role"

    add_column :users, :role_str, :string, default: "employee"

    User.reset_column_information
    User.find_each do |user|
      user.update_column(:role_str, ROLE_MAP.invert.fetch(user.role, "employee"))
    end

    remove_column :users, :role
    rename_column :users, :role_str, :role
  end
end
