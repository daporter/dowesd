class AddConstraints < ActiveRecord::Migration
  def up
    change_column :accounts, :user_id,        :integer, null: false
    change_column :accounts, :other_party_id, :integer, null: false

    change_column :txns, :date,        :date,    null: false
    change_column :txns, :description, :string,  null: false, limit: 60
    change_column :txns, :amount,      :integer, null: false
    change_column :txns, :user_id,     :integer, null: false
    change_column :txns, :account_id,  :integer, null: false

    change_column :users, :name,            :string, null: false, limit: 50
    change_column :users, :email,           :string, null: false
    change_column :users, :password_digest, :string, null: false
  end

  def down
    change_column :accounts, :user_id,        :integer
    change_column :accounts, :other_party_id, :integer

    change_column :txns, :date,        :date
    change_column :txns, :description, :string
    change_column :txns, :amount,      :integer
    change_column :txns, :user_id,     :integer
    change_column :txns, :account_id,  :integer

    change_column :users, :name,            :string
    change_column :users, :email,           :string
    change_column :users, :password_digest, :string
  end
end
