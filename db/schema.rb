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

ActiveRecord::Schema.define(version: 2019_08_28_145637) do

  create_table "secrets", force: :cascade do |t|
    t.integer "user_id"
    t.string "secret_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "auth_type"
    t.string "certificate"
    t.string "key_handle"
    t.string "public_key"
    t.integer "counter"
    t.string "mobile_number"
    t.boolean "mobile_number_status", default: false, null: false
    t.string "sms_otp"
    t.datetime "created_sms_otp_at"
    t.index ["user_id"], name: "index_secrets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_users_on_user_id", unique: true
  end

end
