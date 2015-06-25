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

ActiveRecord::Schema.define(version: 20150625072321) do

  create_table "articles", force: :cascade do |t|
    t.integer  "user_id",        limit: 4
    t.string   "title",          limit: 255
    t.text     "content",        limit: 65535
    t.text     "keywords",       limit: 65535
    t.text     "hashtags",       limit: 65535
    t.integer  "state",          limit: 4
    t.datetime "published_at"
    t.integer  "published",      limit: 4,     default: 0, null: false
    t.integer  "comments_count", limit: 4,     default: 0, null: false
    t.integer  "recommended",    limit: 4,     default: 0, null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "hits_count",     limit: 4,     default: 0, null: false
    t.integer  "share_count_fb", limit: 4,     default: 0, null: false
    t.integer  "share_count_tw", limit: 4,     default: 0, null: false
  end

  add_index "articles", ["published", "comments_count"], name: "idx_articles_by_pc", using: :btree
  add_index "articles", ["published", "published_at"], name: "idx_articles_by_pp", using: :btree
  add_index "articles", ["published", "recommended"], name: "idx_articles_by_pr", using: :btree
  add_index "articles", ["user_id", "published", "published_at"], name: "idx_articles_by_upp", using: :btree

  create_table "articles_photos", force: :cascade do |t|
    t.integer  "article_id", limit: 4, default: 0, null: false
    t.integer  "photo_id",   limit: 4, default: 0, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "articles_photos", ["article_id"], name: "idx_articles_photos_by_aid", using: :btree
  add_index "articles_photos", ["photo_id"], name: "idx_articles_photos_by_pid", using: :btree

  create_table "articles_tags", force: :cascade do |t|
    t.integer  "article_id", limit: 4, default: 0, null: false
    t.integer  "tag_id",     limit: 4, default: 0, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "articles_tags", ["article_id"], name: "idx_articles_tags_by_aid", using: :btree
  add_index "articles_tags", ["tag_id"], name: "idx_articles_tags_by_tid", using: :btree

  create_table "embeds", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "article_id",  limit: 4
    t.text     "source",      limit: 65535
    t.text     "code",        limit: 65535
    t.string   "cover",       limit: 255
    t.string   "url",         limit: 255
    t.string   "title",       limit: 255
    t.text     "content",     limit: 65535
    t.text     "keywords",    limit: 65535
    t.string   "youtube_key", limit: 255
    t.string   "vimeo_key",   limit: 255
    t.string   "fake_key",    limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "embeds", ["article_id"], name: "idx_embeds_by_article_id", using: :btree
  add_index "embeds", ["user_id"], name: "idx_embeds_by_uid", using: :btree

  create_table "photos", force: :cascade do |t|
    t.integer  "user_id",           limit: 4
    t.integer  "article_id",        limit: 4
    t.string   "hashkey",           limit: 255
    t.string   "original_filename", limit: 255
    t.string   "filename",          limit: 255
    t.string   "content_type",      limit: 255
    t.string   "filesize",          limit: 255
    t.string   "dimensions",        limit: 255
    t.string   "positions",         limit: 255
    t.string   "details",           limit: 255
    t.string   "title",             limit: 255
    t.text     "content",           limit: 65535
    t.text     "keywords",          limit: 65535
    t.text     "colors",            limit: 65535
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "photos", ["article_id"], name: "idx_photos_by_article_id", using: :btree
  add_index "photos", ["user_id"], name: "idx_photos_by_uid", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "weight",     limit: 4,   default: 0, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "tags", ["name"], name: "idx_tags_by_nme", using: :btree
  add_index "tags", ["weight"], name: "idx_tags_by_wgt", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "login",      limit: 255,             null: false
    t.integer  "level",      limit: 4,   default: 0, null: false
    t.string   "salt",       limit: 255
    t.string   "password",   limit: 255
    t.string   "email",      limit: 255
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

end
