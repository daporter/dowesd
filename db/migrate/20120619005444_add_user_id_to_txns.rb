class AddUserIdToTxns < ActiveRecord::Migration
  def change
    add_column :txns, :user_id, :integer
    add_index :txns, [:user_id, :date]
  end
end
