class CreateReconciliations < ActiveRecord::Migration
  def change
    create_table :reconciliations do |t|
      t.integer :txn_id,  null: false
      t.integer :user_id, null: false
      t.timestamps
    end
  end
end
