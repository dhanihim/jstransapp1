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

ActiveRecord::Schema.define(version: 2022_06_27_030400) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agents", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "contact"
    t.string "pickupordooring"
    t.integer "active"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "assignment_details", force: :cascade do |t|
    t.integer "quantity"
    t.integer "total"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "assignment_id"
    t.integer "customer_product_id"
    t.index ["assignment_id"], name: "index_assignment_details_on_assignment_id"
    t.index ["customer_product_id"], name: "index_assignment_details_on_customer_product_id"
  end

  create_table "assignments", force: :cascade do |t|
    t.string "uid"
    t.datetime "pickuptime"
    t.integer "document_status"
    t.integer "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "agent_id"
    t.string "customer_id"
    t.string "pickup_location"
    t.string "destination_location"
    t.index ["agent_id"], name: "index_assignments_on_agent_id"
    t.index ["customer_id"], name: "index_assignments_on_customer_id"
  end

  create_table "containers", force: :cascade do |t|
    t.string "number"
    t.string "sealnumber"
    t.string "size"
    t.integer "active"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "customer_locations", force: :cascade do |t|
    t.string "address"
    t.integer "active"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "customer_id"
    t.integer "location_id"
    t.index ["customer_id"], name: "index_customer_locations_on_customer_id"
    t.index ["location_id"], name: "index_customer_locations_on_location_id"
  end

  create_table "customer_product_pricelists", force: :cascade do |t|
    t.integer "per20ft"
    t.integer "per40ft"
    t.integer "per20od"
    t.integer "per21ft"
    t.integer "per20fr"
    t.integer "per40fr"
    t.integer "ppncategory"
    t.integer "active"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "customer_location_id"
    t.integer "customer_product_id"
    t.integer "location_id"
    t.integer "percubic"
    t.integer "peruom"
    t.index ["customer_location_id"], name: "index_customer_product_pricelists_on_customer_location_id"
    t.index ["customer_product_id"], name: "index_customer_product_pricelists_on_customer_product_id"
    t.index ["location_id"], name: "index_customer_product_pricelists_on_location_id"
  end

  create_table "customer_products", force: :cascade do |t|
    t.string "name"
    t.string "uom"
    t.integer "active"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "customer_id"
    t.index ["customer_id"], name: "index_customer_products_on_customer_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "contact"
    t.integer "active"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.integer "active"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "shipments", force: :cascade do |t|
    t.string "uid"
    t.string "shipname"
    t.string "voyage"
    t.date "estimateddeparture"
    t.date "estimatedarrival"
    t.date "actualdeparture"
    t.date "actualarrival"
    t.integer "active"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "pod"
    t.string "pol"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
