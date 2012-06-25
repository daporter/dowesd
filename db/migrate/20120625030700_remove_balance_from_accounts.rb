class RemoveBalanceFromAccounts < ActiveRecord::Migration
  def up
    remove_column :accounts, :balance
  end

  def down
    add_column :accounts, :balance, :integer
  end
end
