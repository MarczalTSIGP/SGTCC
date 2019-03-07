# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_03_05_172016) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "academics", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "ra"
    t.string "gender", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "profile_image"
    t.index ["reset_password_token"], name: "index_academics_on_reset_password_token", unique: true
  end

  create_table "professor_roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "professor_titles", force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "professor_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "professors", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_image"
    t.string "username"
    t.string "name"
    t.string "lattes"
    t.string "gender", limit: 1
    t.boolean "is_active", default: false
    t.boolean "available_advisor"
    t.bigint "professor_title_id"
    t.bigint "professor_type_id"
    t.bigint "professor_role_id"
    t.text "working_area"
    t.index ["email"], name: "index_professors_on_email", unique: true
    t.index ["professor_role_id"], name: "index_professors_on_professor_role_id"
    t.index ["professor_title_id"], name: "index_professors_on_professor_title_id"
    t.index ["professor_type_id"], name: "index_professors_on_professor_type_id"
    t.index ["reset_password_token"], name: "index_professors_on_reset_password_token", unique: true
    t.index ["username"], name: "index_professors_on_username", unique: true
  end

  add_foreign_key "professors", "professor_roles"
  add_foreign_key "professors", "professor_titles"
  add_foreign_key "professors", "professor_types"
end
