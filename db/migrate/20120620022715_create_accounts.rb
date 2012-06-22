class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :user_id
      t.integer :other_party_id
      t.integer :balance

      t.timestamps
    end

    add_index :accounts, :user_id
    add_index :accounts, :other_party_id
    add_index :accounts, [:user_id, :other_party_id], unique: true
  end
end
