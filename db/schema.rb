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

ActiveRecord::Schema[7.0].define(version: 2022_11_07_111509) do
  create_table "access_conditions", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "active_admin_comments", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.string "resource_type", null: false
    t.integer "resource_id", null: false
    t.string "author_type"
    t.integer "author_id"
    t.text "body"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "namespace"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", length: { author_type: 191 }
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", length: 191
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", length: { resource_type: 191 }
  end

  create_table "admin_messages", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.text "message", null: false
    t.datetime "start_at", precision: nil, null: false
    t.datetime "finish_at", precision: nil, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "agent_roles", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "collection_admins", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "collection_id", null: false
    t.integer "user_id", null: false
    t.index ["collection_id", "user_id"], name: "index_collection_admins_on_collection_id_and_user_id", unique: true
    t.index ["collection_id"], name: "index_collection_admins_on_collection_id"
    t.index ["user_id"], name: "index_collection_admins_on_user_id"
  end

  create_table "collection_countries", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "collection_id"
    t.integer "country_id"
    t.index ["collection_id", "country_id"], name: "index_collection_countries_on_collection_id_and_country_id", unique: true
  end

  create_table "collection_languages", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "collection_id"
    t.integer "language_id"
    t.index ["collection_id", "language_id"], name: "index_collection_languages_on_collection_id_and_language_id", unique: true
  end

  create_table "collections", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "identifier", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.integer "collector_id", null: false
    t.integer "operator_id"
    t.integer "university_id"
    t.integer "field_of_research_id"
    t.string "region"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "access_condition_id"
    t.text "access_narrative"
    t.string "metadata_source"
    t.string "orthographic_notes"
    t.string "media"
    t.text "comments"
    t.boolean "complete"
    t.boolean "private"
    t.string "tape_location"
    t.boolean "deposit_form_received"
    t.float "north_limit"
    t.float "south_limit"
    t.float "west_limit"
    t.float "east_limit"
    t.string "doi"
    t.index ["access_condition_id"], name: "index_collections_on_access_condition_id"
    t.index ["collector_id"], name: "index_collections_on_collector_id"
    t.index ["field_of_research_id"], name: "index_collections_on_field_of_research_id"
    t.index ["identifier"], name: "index_collections_on_identifier", unique: true
    t.index ["operator_id"], name: "index_collections_on_operator_id"
    t.index ["university_id"], name: "index_collections_on_university_id"
  end

  create_table "comments", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "owner_id", null: false
    t.integer "commentable_id", null: false
    t.string "commentable_type", null: false
    t.text "body", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "status"
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", length: { commentable_type: 191 }
    t.index ["owner_id"], name: "index_comments_on_owner_id"
  end

  create_table "countries", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.index ["code"], name: "index_countries_on_code", unique: true
    t.index ["name"], name: "index_countries_on_name", unique: true
  end

  create_table "countries_languages", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "country_id", null: false
    t.integer "language_id", null: false
    t.index ["country_id", "language_id"], name: "index_countries_languages_on_country_id_and_language_id", unique: true
  end

  create_table "data_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_data_categories_on_name", unique: true
  end

  create_table "data_types", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_data_types_on_name", length: 191
  end

  create_table "delayed_jobs", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at", precision: nil
    t.datetime "locked_at", precision: nil
    t.datetime "failed_at", precision: nil
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "discourse_types", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name", null: false
    t.index ["name"], name: "index_discourse_types_on_name", unique: true
  end

  create_table "downloads", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "essence_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["essence_id"], name: "index_downloads_on_essence_id"
    t.index ["user_id"], name: "index_downloads_on_user_id"
  end

  create_table "essences", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "item_id"
    t.string "filename"
    t.string "mimetype"
    t.integer "bitrate"
    t.integer "samplerate"
    t.bigint "size"
    t.float "duration"
    t.integer "channels"
    t.integer "fps"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "doi"
    t.boolean "derived_files_generated", default: false
    t.index ["item_id"], name: "index_essences_on_item_id"
  end

  create_table "fields_of_research", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "identifier"
    t.string "name"
    t.index ["identifier"], name: "index_fields_of_research_on_identifier", unique: true
    t.index ["name"], name: "index_fields_of_research_on_name", unique: true
  end

  create_table "funding_bodies", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "key_prefix"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "grants", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "collection_id"
    t.string "grant_identifier"
    t.integer "funding_body_id"
    t.index ["collection_id"], name: "index_grants_on_collection_id"
    t.index ["funding_body_id"], name: "index_grants_on_funding_body_id"
    t.index ["grant_identifier"], name: "index_grants_on_grant_identifier", length: 191
  end

  create_table "item_admins", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "user_id", null: false
    t.index ["item_id", "user_id"], name: "index_item_admins_on_item_id_and_user_id", unique: true
  end

  create_table "item_agents", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "user_id", null: false
    t.integer "agent_role_id", null: false
    t.index ["item_id", "user_id", "agent_role_id"], name: "index_item_agents_on_item_id_and_user_id_and_agent_role_id", unique: true
  end

  create_table "item_content_languages", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "language_id", null: false
    t.index ["item_id", "language_id"], name: "index_item_content_languages_on_item_id_and_language_id", unique: true
  end

  create_table "item_countries", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "country_id", null: false
    t.index ["item_id", "country_id"], name: "index_item_countries_on_item_id_and_country_id", unique: true
  end

  create_table "item_data_categories", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "data_category_id", null: false
    t.index ["item_id", "data_category_id"], name: "index_item_data_categories_on_item_id_and_data_category_id", unique: true
  end

  create_table "item_data_types", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "data_type_id", null: false
    t.index ["data_type_id"], name: "index_item_data_types_on_data_type_id"
    t.index ["item_id"], name: "index_item_data_types_on_item_id"
  end

  create_table "item_subject_languages", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "language_id", null: false
    t.index ["item_id", "language_id"], name: "index_item_subject_languages_on_item_id_and_language_id", unique: true
  end

  create_table "item_users", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "item_id", null: false
    t.integer "user_id", null: false
    t.index ["item_id", "user_id"], name: "index_item_users_on_item_id_and_user_id", unique: true
  end

  create_table "items", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "collection_id", null: false
    t.string "identifier", null: false
    t.boolean "private"
    t.string "title", null: false
    t.string "url"
    t.integer "collector_id", null: false
    t.integer "university_id"
    t.integer "operator_id"
    t.text "description", null: false
    t.date "originated_on"
    t.string "language"
    t.string "dialect"
    t.string "region"
    t.integer "discourse_type_id"
    t.integer "access_condition_id"
    t.text "access_narrative"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "metadata_exportable"
    t.boolean "born_digital"
    t.boolean "tapes_returned"
    t.text "original_media"
    t.datetime "received_on", precision: nil
    t.datetime "digitised_on", precision: nil
    t.text "ingest_notes"
    t.datetime "metadata_imported_on", precision: nil
    t.datetime "metadata_exported_on", precision: nil
    t.text "tracking"
    t.text "admin_comment"
    t.boolean "external", default: false
    t.text "originated_on_narrative"
    t.float "north_limit"
    t.float "south_limit"
    t.float "west_limit"
    t.float "east_limit"
    t.string "doi"
    t.integer "essences_count"
    t.index ["access_condition_id"], name: "index_items_on_access_condition_id"
    t.index ["collection_id"], name: "index_items_on_collection_id"
    t.index ["collector_id"], name: "index_items_on_collector_id"
    t.index ["discourse_type_id"], name: "index_items_on_discourse_type_id"
    t.index ["identifier", "collection_id"], name: "index_items_on_identifier_and_collection_id", unique: true
    t.index ["operator_id"], name: "index_items_on_operator_id"
    t.index ["university_id"], name: "index_items_on_university_id"
  end

  create_table "languages", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.boolean "retired"
    t.float "north_limit"
    t.float "south_limit"
    t.float "west_limit"
    t.float "east_limit"
    t.index ["code"], name: "index_languages_on_code", unique: true
  end

  create_table "latlon_boundaries", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "country_id", null: false
    t.decimal "east_limit", precision: 6, scale: 3, null: false
    t.decimal "west_limit", precision: 6, scale: 3, null: false
    t.decimal "north_limit", precision: 6, scale: 3, null: false
    t.decimal "south_limit", precision: 6, scale: 3, null: false
    t.boolean "wrapped", default: false
    t.index ["country_id"], name: "index_latlon_boundaries_on_country_id"
  end

  create_table "party_identifiers", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "party_type", null: false
    t.string "identifier", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["party_type"], name: "index_party_identifiers_on_party_type"
    t.index ["user_id"], name: "index_party_identifiers_on_user_id"
  end

  create_table "universities", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "party_identifier"
  end

  create_table "users", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "password_salt"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.string "first_name", null: false
    t.string "last_name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "admin", default: false, null: false
    t.string "address"
    t.string "address2"
    t.string "country"
    t.string "phone"
    t.boolean "contact_only", default: false
    t.integer "rights_transferred_to_id"
    t.string "rights_transfer_reason"
    t.string "party_identifier"
    t.boolean "collector", default: false, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["rights_transferred_to_id"], name: "index_users_on_rights_transferred_to_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "versions", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :medium
    t.datetime "created_at", precision: nil
    t.text "object_changes", size: :medium
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", length: { item_type: 191 }
  end

end
