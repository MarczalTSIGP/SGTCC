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

ActiveRecord::Schema.define(version: 2019_03_13_131044) do

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

  create_table "assignments", force: :cascade do |t|
    t.bigint "professor_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["professor_id"], name: "index_assignments_on_professor_id"
    t.index ["role_id"], name: "index_assignments_on_role_id"
  end

  create_table "external_members", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.boolean "is_active", default: false
    t.string "gender", limit: 1
    t.text "working_area"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_image"
    t.bigint "professor_title_id"
    t.string "personal_page"
    t.index ["professor_title_id"], name: "index_external_members_on_professor_title_id"
  end

  create_table "institutions", force: :cascade do |t|
    t.string "name"
    t.string "trade_name"
    t.string "cnpj"
    t.bigint "external_member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_member_id"], name: "index_institutions_on_external_member_id"
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
    t.text "working_area"
    t.index ["email"], name: "index_professors_on_email", unique: true
    t.index ["professor_title_id"], name: "index_professors_on_professor_title_id"
    t.index ["professor_type_id"], name: "index_professors_on_professor_type_id"
    t.index ["reset_password_token"], name: "index_professors_on_reset_password_token", unique: true
    t.index ["username"], name: "index_professors_on_username", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "assignments", "professors"
  add_foreign_key "assignments", "roles"
  add_foreign_key "external_members", "professor_titles"
  add_foreign_key "institutions", "external_members"
  add_foreign_key "professors", "professor_titles"
  add_foreign_key "professors", "professor_types"
end
