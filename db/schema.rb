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

ActiveRecord::Schema[7.0].define(version: 2025_02_20_014920) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "contact_reply_templates", force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.string "category", null: false
    t.boolean "default", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category", "default"], name: "index_contact_reply_templates_on_category_and_default"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.text "content", null: false
    t.string "category", null: false
    t.string "status", default: "pending", null: false
    t.text "admin_memo"
    t.boolean "privacy_policy_agreed", default: false, null: false
    t.datetime "responded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "reply_content"
    t.datetime "replied_at"
    t.index ["category"], name: "index_contacts_on_category"
    t.index ["created_at"], name: "index_contacts_on_created_at"
    t.index ["status"], name: "index_contacts_on_status"
  end

  create_table "image_posts", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "likeable_type", null: false
    t.bigint "likeable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["likeable_id", "likeable_type", "created_at"], name: "index_likes_on_likeable_and_created_at"
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable"
    t.index ["likeable_type", "likeable_id"], name: "index_likes_on_likeable_type_and_likeable_id"
    t.index ["user_id", "likeable_type", "likeable_id"], name: "index_likes_on_user_id_and_likeable_type_and_likeable_id", unique: true
    t.index ["user_id", "likeable_type"], name: "index_likes_on_user_id_and_likeable_type"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "post_tags", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id", "tag_id"], name: "index_post_tags_on_post_id_and_tag_id", unique: true
    t.index ["post_id"], name: "index_post_tags_on_post_id"
    t.index ["tag_id"], name: "index_post_tags_on_tag_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "display_content"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reading", default: "", null: false
    t.bigint "image_post_id"
    t.bigint "theme_id"
    t.integer "likes_count", default: 0, null: false
    t.datetime "deleted_at"
    t.index ["created_at"], name: "index_posts_on_created_at"
    t.index ["image_post_id"], name: "index_posts_on_image_post_id"
    t.index ["theme_id"], name: "index_posts_on_theme_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "posts_deletion_requests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.text "reason", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_posts_deletion_requests_on_post_id"
    t.index ["user_id"], name: "index_posts_deletion_requests_on_user_id"
  end

  create_table "posts_reports", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.integer "reason_category", default: 4, null: false
    t.text "reason", null: false
    t.integer "status", default: 0
    t.text "admin_note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_posts_reports_on_post_id"
    t.index ["user_id"], name: "index_posts_reports_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "themes", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "image_post_id"
    t.integer "likes_count", default: 0, null: false
    t.integer "status", default: 0
    t.datetime "deleted_at"
    t.integer "posts_count", default: 0
    t.index ["created_at"], name: "index_themes_on_created_at"
    t.index ["image_post_id"], name: "index_themes_on_image_post_id"
    t.index ["posts_count"], name: "index_themes_on_posts_count"
    t.index ["status"], name: "index_themes_on_status"
    t.index ["user_id"], name: "index_themes_on_user_id"
  end

  create_table "themes_deletion_requests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "theme_id", null: false
    t.text "reason", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["theme_id"], name: "index_themes_deletion_requests_on_theme_id"
    t.index ["user_id"], name: "index_themes_deletion_requests_on_user_id"
  end

  create_table "themes_reports", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "theme_id", null: false
    t.integer "reason_category", default: 4, null: false
    t.text "reason", null: false
    t.integer "status", default: 0
    t.text "admin_note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["theme_id"], name: "index_themes_reports_on_theme_id"
    t.index ["user_id"], name: "index_themes_reports_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "role", default: 0, null: false
    t.datetime "last_login_at"
    t.boolean "email_confirmed", default: false
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "likes", "users"
  add_foreign_key "post_tags", "posts"
  add_foreign_key "post_tags", "tags"
  add_foreign_key "posts", "image_posts"
  add_foreign_key "posts", "themes"
  add_foreign_key "posts", "users"
  add_foreign_key "posts_deletion_requests", "posts"
  add_foreign_key "posts_deletion_requests", "users"
  add_foreign_key "posts_reports", "posts"
  add_foreign_key "posts_reports", "users"
  add_foreign_key "themes", "image_posts"
  add_foreign_key "themes", "users"
  add_foreign_key "themes_deletion_requests", "themes"
  add_foreign_key "themes_deletion_requests", "users"
  add_foreign_key "themes_reports", "themes"
  add_foreign_key "themes_reports", "users"
end
