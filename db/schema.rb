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

ActiveRecord::Schema.define(version: 20170321122149) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "username",               limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "failed_attempts",                    default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  add_index "admins", ["unlock_token"], name: "index_admins_on_unlock_token", unique: true
  add_index "admins", ["username"], name: "index_admins_on_username", unique: true

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token",   limit: 255,                           null: false
    t.integer  "dns_entry_id",                                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dns_entry_type", limit: 255, default: "DnsHostRecord", null: false
  end

  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", unique: true
  add_index "api_keys", ["dns_entry_id", "dns_entry_type"], name: "tokenparent_idx", unique: true

  create_table "authentication_tokens", force: :cascade do |t|
    t.string   "token",        limit: 255
    t.integer  "account_id"
    t.string   "account_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentication_tokens", ["account_id", "account_type"], name: "index_authentication_tokens_on_account_id_and_account_type"
  add_index "authentication_tokens", ["token"], name: "index_authentication_tokens_on_token", unique: true

  create_table "dns_host_ip_a_records", force: :cascade do |t|
    t.string   "address",             limit: 255
    t.integer  "dns_host_record_id",              null: false
    t.integer  "isp_dns_a_record_id"
    t.datetime "lastset"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dns_host_ip_a_records", ["dns_host_record_id"], name: "index_dns_host_ip_a_records_on_dns_host_record_id"
  add_index "dns_host_ip_a_records", ["isp_dns_a_record_id"], name: "index_dns_host_ip_a_records_on_isp_dns_a_record_id", unique: true

  create_table "dns_host_ip_aaaa_records", force: :cascade do |t|
    t.string   "address",                limit: 255
    t.integer  "dns_host_record_id",                 null: false
    t.integer  "isp_dns_aaaa_record_id"
    t.datetime "lastset"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dns_host_ip_aaaa_records", ["dns_host_record_id"], name: "index_dns_host_ip_aaaa_records_on_dns_host_record_id"
  add_index "dns_host_ip_aaaa_records", ["isp_dns_aaaa_record_id"], name: "index_dns_host_ip_aaaa_records_on_isp_dns_aaaa_record_id", unique: true

  create_table "dns_host_records", force: :cascade do |t|
    t.string   "name",        limit: 255,               null: false
    t.integer  "dns_zone_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ttl",                     default: 300, null: false
  end

  add_index "dns_host_records", ["dns_zone_id"], name: "index_dns_host_records_on_dns_zone_id"
  add_index "dns_host_records", ["name", "dns_zone_id"], name: "recordname_idx", unique: true
  add_index "dns_host_records", ["user_id"], name: "index_dns_host_records_on_user_id"

  create_table "dns_zones", force: :cascade do |t|
    t.string   "name",               limit: 255,                 null: false
    t.string   "isp_dnszone_origin", limit: 255,                 null: false
    t.integer  "isp_dnszone_id",                                 null: false
    t.integer  "isp_client_user_id",                             null: false
    t.boolean  "is_public",                      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dns_zones", ["isp_client_user_id"], name: "index_dns_zones_on_isp_client_user_id"
  add_index "dns_zones", ["isp_dnszone_id"], name: "index_dns_zones_on_isp_dnszone_id", unique: true
  add_index "dns_zones", ["isp_dnszone_origin"], name: "index_dns_zones_on_isp_dnszone_origin", unique: true
  add_index "dns_zones", ["name"], name: "index_dns_zones_on_name", unique: true

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id"

  create_table "settings", force: :cascade do |t|
    t.string   "name",       limit: 255, default: "", null: false
    t.string   "value",      limit: 255
    t.datetime "updated_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["name"], name: "index_settings_on_name"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",                    default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
