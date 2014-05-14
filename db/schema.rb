# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140514211836) do

  create_table "dns_zone_a_records", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.integer  "dns_zone_id"
    t.integer  "user_id",     null: false
    t.datetime "lastset"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dns_zone_a_records", ["dns_zone_id"], name: "index_dns_zone_a_records_on_dns_zone_id"
  add_index "dns_zone_a_records", ["name", "dns_zone_id"], name: "arecord_idx", unique: true

  create_table "dns_zone_aaaa_records", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.integer  "dns_zone_id"
    t.integer  "user_id",     null: false
    t.datetime "lastset"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dns_zone_aaaa_records", ["dns_zone_id"], name: "index_dns_zone_aaaa_records_on_dns_zone_id"
  add_index "dns_zone_aaaa_records", ["name", "dns_zone_id"], name: "aaaarecord_idx", unique: true

  create_table "dns_zones", force: true do |t|
    t.string   "name",               null: false
    t.string   "isp_dnszone_origin", null: false
    t.integer  "isp_dnszone_id",     null: false
    t.integer  "isp_client_user_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dns_zones", ["isp_client_user_id"], name: "index_dns_zones_on_isp_client_user_id"
  add_index "dns_zones", ["isp_dnszone_id"], name: "index_dns_zones_on_isp_dnszone_id", unique: true
  add_index "dns_zones", ["isp_dnszone_origin"], name: "index_dns_zones_on_isp_dnszone_origin", unique: true
  add_index "dns_zones", ["name"], name: "index_dns_zones_on_name", unique: true

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "s_id_idx"
  add_index "sessions", ["updated_at"], name: "s_update_idx"

  create_table "settings", force: true do |t|
    t.string   "name",       default: "", null: false
    t.string   "value"
    t.datetime "updated_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["name"], name: "index_settings_on_name"

  create_table "users", force: true do |t|
    t.string   "last_name",                  null: false
    t.string   "first_name",                 null: false
    t.string   "login_id",                   null: false
    t.string   "email",                      null: false
    t.string   "password",                   null: false
    t.boolean  "active",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["login_id"], name: "index_users_on_login_id", unique: true

end
