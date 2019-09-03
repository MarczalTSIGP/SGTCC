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

ActiveRecord::Schema.define(version: 2019_09_03_171255) do

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

  create_table "activities", force: :cascade do |t|
    t.string "name"
    t.bigint "base_activity_type_id"
    t.integer "tcc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "calendar_id"
    t.datetime "initial_date"
    t.datetime "final_date"
    t.index ["base_activity_type_id"], name: "index_activities_on_base_activity_type_id"
    t.index ["calendar_id"], name: "index_activities_on_calendar_id"
  end

  create_table "assignments", force: :cascade do |t|
    t.bigint "professor_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["professor_id"], name: "index_assignments_on_professor_id"
    t.index ["role_id"], name: "index_assignments_on_role_id"
  end

  create_table "base_activities", force: :cascade do |t|
    t.string "name"
    t.bigint "base_activity_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tcc"
    t.index ["base_activity_type_id"], name: "index_base_activities_on_base_activity_type_id"
  end

  create_table "base_activity_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "calendars", force: :cascade do |t|
    t.string "year"
    t.integer "semester"
    t.integer "tcc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

# Could not dump table "document_types" because of following StandardError
#   Unknown type 'document_type_identifiers' for column 'identifier'

  create_table "documents", force: :cascade do |t|
    t.json "content"
    t.bigint "document_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.json "request"
    t.index ["document_type_id"], name: "index_documents_on_document_type_id"
  end

  create_table "examination_board_attendees", force: :cascade do |t|
    t.bigint "examination_board_id"
    t.bigint "professor_id"
    t.bigint "external_member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["examination_board_id"], name: "index_examination_board_attendees_on_examination_board_id"
    t.index ["external_member_id"], name: "index_examination_board_attendees_on_external_member_id"
    t.index ["professor_id"], name: "index_examination_board_attendees_on_professor_id"
  end

  create_table "examination_boards", force: :cascade do |t|
    t.datetime "date"
    t.string "place"
    t.bigint "orientation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tcc"
    t.index ["orientation_id"], name: "index_examination_boards_on_orientation_id"
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
    t.bigint "scholarity_id"
    t.string "personal_page"
    t.string "encrypted_password"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["reset_password_token"], name: "index_external_members_on_reset_password_token", unique: true
    t.index ["scholarity_id"], name: "index_external_members_on_scholarity_id"
  end

  create_table "institutions", force: :cascade do |t|
    t.string "name"
    t.string "trade_name"
    t.string "cnpj"
    t.bigint "external_member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "working_area"
    t.index ["external_member_id"], name: "index_institutions_on_external_member_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.text "content"
    t.datetime "date"
    t.boolean "viewed", default: false
    t.bigint "orientation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["orientation_id"], name: "index_meetings_on_orientation_id"
  end

  create_table "orientation_supervisors", force: :cascade do |t|
    t.bigint "orientation_id"
    t.bigint "professor_supervisor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "external_member_supervisor_id"
    t.index ["external_member_supervisor_id"], name: "index_orientation_supervisors_on_external_member_supervisor_id"
    t.index ["orientation_id"], name: "index_orientation_supervisors_on_orientation_id"
    t.index ["professor_supervisor_id"], name: "index_orientation_supervisors_on_professor_supervisor_id"
  end

  create_table "orientations", force: :cascade do |t|
    t.string "title"
    t.bigint "calendar_id"
    t.bigint "academic_id"
    t.bigint "advisor_id"
    t.bigint "institution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "IN_PROGRESS"
    t.text "renewal_justification"
    t.text "cancellation_justification"
    t.index ["academic_id"], name: "index_orientations_on_academic_id"
    t.index ["advisor_id"], name: "index_orientations_on_advisor_id"
    t.index ["calendar_id"], name: "index_orientations_on_calendar_id"
    t.index ["institution_id"], name: "index_orientations_on_institution_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fa_icon"
    t.string "url"
    t.integer "identifier"
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
    t.bigint "scholarity_id"
    t.bigint "professor_type_id"
    t.text "working_area"
    t.index ["email"], name: "index_professors_on_email", unique: true
    t.index ["professor_type_id"], name: "index_professors_on_professor_type_id"
    t.index ["reset_password_token"], name: "index_professors_on_reset_password_token", unique: true
    t.index ["scholarity_id"], name: "index_professors_on_scholarity_id"
    t.index ["username"], name: "index_professors_on_username", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "identifier"
  end

  create_table "scholarities", force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "signatures", force: :cascade do |t|
    t.bigint "orientation_id"
    t.bigint "document_id"
    t.integer "user_id"
    t.string "user_type", limit: 3
    t.boolean "status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_signatures_on_document_id"
    t.index ["orientation_id"], name: "index_signatures_on_orientation_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "sidebar"
  end

  add_foreign_key "activities", "base_activity_types"
  add_foreign_key "activities", "calendars"
  add_foreign_key "assignments", "professors"
  add_foreign_key "assignments", "roles"
  add_foreign_key "base_activities", "base_activity_types"
  add_foreign_key "documents", "document_types"
  add_foreign_key "examination_board_attendees", "examination_boards"
  add_foreign_key "examination_board_attendees", "external_members"
  add_foreign_key "examination_board_attendees", "professors"
  add_foreign_key "examination_boards", "orientations"
  add_foreign_key "external_members", "scholarities"
  add_foreign_key "institutions", "external_members"
  add_foreign_key "meetings", "orientations"
  add_foreign_key "orientation_supervisors", "external_members", column: "external_member_supervisor_id"
  add_foreign_key "orientation_supervisors", "orientations"
  add_foreign_key "orientation_supervisors", "professors", column: "professor_supervisor_id"
  add_foreign_key "orientations", "academics"
  add_foreign_key "orientations", "calendars"
  add_foreign_key "orientations", "institutions"
  add_foreign_key "orientations", "professors", column: "advisor_id"
  add_foreign_key "professors", "professor_types"
  add_foreign_key "professors", "scholarities"
  add_foreign_key "signatures", "documents"
  add_foreign_key "signatures", "orientations"
end
