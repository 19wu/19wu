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

ActiveRecord::Schema.define(version: 20130818175826) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "event_changes", force: true do |t|
    t.integer  "event_id"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "event_changes", ["event_id"], name: "index_event_changes_on_event_id", using: :btree

  create_table "event_order_items", force: true do |t|
    t.integer  "order_id",                   null: false
    t.integer  "ticket_id",                  null: false
    t.integer  "quantity",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price_in_cents", default: 0, null: false
  end

  create_table "event_order_participants", force: true do |t|
    t.integer  "order_id",               null: false
    t.integer  "event_id",               null: false
    t.integer  "user_id",                null: false
    t.string   "checkin_code", limit: 6, null: false
    t.datetime "checkin_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_order_participants", ["event_id", "checkin_code"], name: "index_event_order_participants_on_event_id_and_checkin_code", unique: true, using: :btree

  create_table "event_order_shipping_addresses", force: true do |t|
    t.integer  "order_id",                 null: false
    t.string   "invoice_title"
    t.string   "province",      limit: 64
    t.string   "city",          limit: 64
    t.string   "district",      limit: 64
    t.string   "address"
    t.string   "name",          limit: 64
    t.string   "phone",         limit: 64
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_order_status_transitions", force: true do |t|
    t.integer  "event_order_id"
    t.string   "event"
    t.string   "from"
    t.string   "to"
    t.datetime "created_at"
  end

  add_index "event_order_status_transitions", ["event_order_id"], name: "index_event_order_status_transitions_on_event_order_id", using: :btree

  create_table "event_orders", force: true do |t|
    t.integer  "event_id",                              null: false
    t.integer  "user_id",                               null: false
    t.integer  "quantity",                              null: false
    t.string   "status",         limit: 16
    t.string   "trade_no",       limit: 16
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price_in_cents",            default: 0, null: false
  end

  add_index "event_orders", ["event_id"], name: "index_event_orders_on_event_id", using: :btree
  add_index "event_orders", ["user_id"], name: "index_event_orders_on_user_id", using: :btree

  create_table "event_summaries", force: true do |t|
    t.text    "content"
    t.integer "event_id"
  end

  create_table "event_tickets", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "require_invoice"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price_in_cents",  default: 0, null: false
  end

  add_index "event_tickets", ["event_id"], name: "index_event_tickets_on_event_id", using: :btree

  create_table "events", force: true do |t|
    t.string   "title",                        null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "location"
    t.text     "content"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "user_id",                      null: false
    t.text     "location_guide"
    t.integer  "group_id",                     null: false
    t.integer  "tickets_quantity", default: 0
  end

  add_index "events", ["group_id"], name: "index_events_on_group_id", using: :btree

  create_table "fallback_urls", force: true do |t|
    t.string   "origin"
    t.string   "change_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "fallback_urls", ["origin"], name: "index_fallback_urls_on_origin", unique: true, using: :btree

  create_table "follows", force: true do |t|
    t.integer  "followable_id",                   null: false
    t.string   "followable_type",                 null: false
    t.integer  "follower_id",                     null: false
    t.string   "follower_type",                   null: false
    t.boolean  "blocked",         default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "group_collaborators", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_topic_replies", force: true do |t|
    t.text     "body"
    t.integer  "group_topic_id", null: false
    t.integer  "user_id",        null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "group_topic_replies", ["group_topic_id"], name: "index_group_topic_replies_on_group_topic_id", using: :btree

  create_table "group_topics", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id",                   null: false
    t.integer  "group_id",                  null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "replies_count", default: 0
  end

  add_index "group_topics", ["group_id"], name: "index_group_topics_on_group_id", using: :btree

  create_table "groups", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "slug",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "groups", ["slug"], name: "index_groups_on_slug", unique: true, using: :btree

  create_table "photos", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", force: true do |t|
    t.string   "name"
    t.string   "website"
    t.text     "bio"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "login"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "invitation_token",       limit: 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.boolean  "admin",                             default: false
    t.string   "invite_reason"
    t.string   "phone"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
