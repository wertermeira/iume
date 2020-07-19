# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_14_192049) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authenticate_tokens", force: :cascade do |t|
    t.string "body"
    t.datetime "last_used_at"
    t.integer "expires_in"
    t.string "ip_address"
    t.string "user_agent"
    t.string "authenticateable_type", null: false
    t.bigint "authenticateable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["authenticateable_type", "authenticateable_id"], name: "authenticateable_type_and_authenticateable_id"
    t.index ["body"], name: "index_authenticate_tokens_on_body", unique: true
  end

  create_table "owners", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "provider"
    t.string "password_digest"
    t.integer "account_status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_owners_on_email", unique: true
  end

end
