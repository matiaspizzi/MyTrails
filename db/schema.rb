# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_12_22_221648) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "leaderships", force: :cascade do |t|
    t.bigint "leader_id", null: false
    t.bigint "employee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["leader_id", "employee_id"], name: "index_leaderships_on_leader_id_and_employee_id", unique: true
  end

  create_table "objectives", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.string "title", null: false
    t.text "description"
    t.datetime "estimated_completion_at", precision: nil, null: false
    t.integer "rating"
    t.bigint "rated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["employee_id"], name: "index_objectives_on_employee_id"
    t.index ["rated_by"], name: "index_objectives_on_rated_by"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.string "role", default: "employee"
    t.string "name"
    t.string "surname"
    t.text "profile_image"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "leaderships", "users", column: "employee_id"
  add_foreign_key "leaderships", "users", column: "leader_id"
  add_foreign_key "objectives", "users", column: "employee_id"
  add_foreign_key "objectives", "users", column: "rated_by"
  add_foreign_key "sessions", "users"
end
