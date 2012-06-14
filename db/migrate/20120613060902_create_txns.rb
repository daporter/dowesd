class CreateTxns < ActiveRecord::Migration
  def change
    create_table :txns do |t|
      t.date :date
      t.string :description
      t.integer :amount

      t.timestamps
    end
  end
end
