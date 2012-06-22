class AddAccountIdToTxns < ActiveRecord::Migration
  def change
    add_column :txns, :account_id, :integer
    add_index :txns, [:account_id, :date]
  end
end
