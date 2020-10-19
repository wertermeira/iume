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

ActiveRecord::Schema.define(version: 2020_10_16_194008) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "neighborhood"
    t.bigint "city_id"
    t.string "complement"
    t.string "number"
    t.string "reference"
    t.string "cep"
    t.string "addressable_type", null: false
    t.bigint "addressable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
    t.index ["city_id"], name: "index_addresses_on_city_id"
  end

  create_table "authenticate_tokens", force: :cascade do |t|
    t.string "body"
    t.datetime "last_used_at"
    t.integer "expires_in"
    t.string "user_agent"
    t.string "authenticateable_type", null: false
    t.bigint "authenticateable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["authenticateable_type", "authenticateable_id"], name: "authenticateable_type_and_authenticateable_id"
    t.index ["body"], name: "index_authenticate_tokens_on_body", unique: true
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.boolean "capital", default: false
    t.bigint "state_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["state_id"], name: "index_cities_on_state_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.string "screen"
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_feedbacks_on_owner_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "order_details", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.decimal "unit_price", precision: 8, scale: 2
    t.integer "quantity", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_order_details_on_order_id"
    t.index ["product_id"], name: "index_order_details_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "restaurant_id"
    t.string "uid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["restaurant_id"], name: "index_orders_on_restaurant_id"
    t.index ["uid"], name: "index_orders_on_uid", unique: true
  end

  create_table "owners", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "provider"
    t.string "password_digest"
    t.integer "account_status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "login_count", default: 0
    t.integer "lock_version", default: 0
    t.integer "remarketing", default: 0
    t.index ["email"], name: "index_owners_on_email", unique: true
  end

  create_table "phones", force: :cascade do |t|
    t.string "phoneable_type", null: false
    t.bigint "phoneable_id", null: false
    t.string "number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["phoneable_type", "phoneable_id"], name: "index_phones_on_phoneable_type_and_phoneable_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer "section_id"
    t.string "name"
    t.text "description"
    t.decimal "price", precision: 8, scale: 2
    t.integer "position"
    t.boolean "active", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "deleted", default: false
    t.index ["section_id"], name: "index_products_on_section_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "restaurants", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.string "name"
    t.string "slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: false
    t.string "uid"
    t.bigint "theme_color_id"
    t.index ["owner_id"], name: "index_restaurants_on_owner_id"
    t.index ["slug"], name: "index_restaurants_on_slug", unique: true
    t.index ["theme_color_id"], name: "index_restaurants_on_theme_color_id"
    t.index ["uid"], name: "index_restaurants_on_uid", unique: true
  end

  create_table "sections", force: :cascade do |t|
    t.string "name"
    t.bigint "restaurant_id", null: false
    t.integer "position"
    t.boolean "active", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "description"
    t.boolean "deleted", default: false
    t.index ["position"], name: "index_sections_on_position"
    t.index ["restaurant_id"], name: "index_sections_on_restaurant_id"
  end

  create_table "social_networks", force: :cascade do |t|
    t.integer "provider", null: false
    t.bigint "restaurant_id", null: false
    t.string "username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["restaurant_id", "provider"], name: "index_restaurant_id_provider", unique: true
    t.index ["restaurant_id"], name: "index_social_networks_on_restaurant_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.string "acronym"
    t.bigint "region_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["region_id"], name: "index_states_on_region_id"
  end

  create_table "theme_colors", force: :cascade do |t|
    t.string "color"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tool_whatsapps", force: :cascade do |t|
    t.bigint "restaurant_id", null: false
    t.boolean "active", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["restaurant_id"], name: "index_tool_whatsapps_on_restaurant_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "cities"
  add_foreign_key "cities", "states"
  add_foreign_key "feedbacks", "owners"
  add_foreign_key "order_details", "orders"
  add_foreign_key "order_details", "products"
  add_foreign_key "orders", "restaurants"
  add_foreign_key "products", "sections"
  add_foreign_key "restaurants", "owners"
  add_foreign_key "restaurants", "theme_colors"
  add_foreign_key "sections", "restaurants"
  add_foreign_key "social_networks", "restaurants"
  add_foreign_key "states", "regions"
  add_foreign_key "tool_whatsapps", "restaurants"
end
