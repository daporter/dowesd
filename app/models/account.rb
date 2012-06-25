class Account < ActiveRecord::Base
  attr_accessible :balance, :balance_dollars, :other_party_id

  has_many :txns
  belongs_to :user
  belongs_to :other_party, class_name: "User"

  validates :user_id,        presence: true
  validates :other_party_id, presence: true

  def other_party_name
    other_party.name
  end

  def balance
    user_txn_sum - other_party_txn_sum
  end

  def balance_dollars
    balance.to_f / 100
  end

  private

  def user_txn_sum
    sum_txns_by_user_id(user.id)
  end

  def other_party_txn_sum
    sum_txns_by_user_id(other_party.id)
  end

  def sum_txns_by_user_id(user_id)
    txns.sum(:amount, conditions: { user_id: user_id })
  end
end
