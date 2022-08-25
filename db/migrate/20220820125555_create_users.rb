# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false
      t.boolean :is_admin, default: false, null: false
      t.boolean :is_deleted, default: false, null: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        execute <<-SQL
          INSERT INTO users (name, email, password_digest, is_admin, created_at, updated_at)
          VALUES ('admin', 'onimuska@mail.ru', '$2a$10$Tf2Kpd1VWPbc2XOwhjaqp.iSiR81KAiUIiCqqq/aA8/BX.5af4Wiu', true, '2022-08-22', '2022-08-22')
        SQL
      end
      dir.down do
        execute <<-SQL
          DELETE FROM users
        SQL
      end
    end
  end
end
