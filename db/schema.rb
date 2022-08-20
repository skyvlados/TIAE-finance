# frozen_string_literal: true

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

ActiveRecord::Schema[7.0].define(version: 20_220_820_130_453) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'categories', force: :cascade do |t|
    t.text 'name'
    t.bigint 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_categories_on_user_id'
  end

  create_table 'operations', force: :cascade do |t|
    t.integer 'direction', null: false
    t.datetime 'date', precision: nil, null: false
    t.decimal 'amount', null: false
    t.integer 'currency', null: false
    t.bigint 'user_id', null: false
    t.bigint 'category_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['category_id'], name: 'index_operations_on_category_id'
    t.index ['user_id'], name: 'index_operations_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'email', null: false
    t.string 'password_digest', null: false
    t.boolean 'is_deleted', default: false, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_foreign_key 'categories', 'users'
  add_foreign_key 'operations', 'categories'
  add_foreign_key 'operations', 'users'
end
