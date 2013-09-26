# encoding: utf-8

class AddIndexes < ActiveRecord::Migration
  def change
    add_index :reconciliations, :txn_id
    add_index :reconciliations, :user_id

    add_index :txns, :user_id
    add_index :txns, :account_id
  end
end
