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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120621013022) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "other_party_id"
    t.integer  "balance"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "accounts", ["other_party_id"], :name => "index_accounts_on_other_party_id"
  add_index "accounts", ["user_id", "other_party_id"], :name => "index_accounts_on_user_id_and_other_party_id", :unique => true
  add_index "accounts", ["user_id"], :name => "index_accounts_on_user_id"

  create_table "txns", :force => true do |t|
    t.date     "date"
    t.string   "description"
    t.integer  "amount"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
    t.integer  "account_id"
  end

  add_index "txns", ["account_id", "date"], :name => "index_txns_on_account_id_and_date"
  add_index "txns", ["user_id", "date"], :name => "index_txns_on_user_id_and_date"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
