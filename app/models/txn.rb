class Txn < ActiveRecord::Base
  attr_accessible :amount, :date, :description
end
