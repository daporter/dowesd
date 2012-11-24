# == Schema Information
# Schema version: 20120626235852
#
# Table name: accounts
#
#  id             :integer          not null, primary key
#  user_id        :integer          not null
#  other_party_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_accounts_on_other_party_id              (other_party_id)
#  index_accounts_on_user_id                     (user_id)
#  index_accounts_on_user_id_and_other_party_id  (user_id,other_party_id) UNIQUE
#

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

  def other_participant(a_user)
    return other_party  if a_user == user
    return user         if a_user == other_party
  end

  def balance
    user_txn_sum - other_party_txn_sum
  end

  def balance_dollars
    balance.to_f / 100
  end

  def creditor
    return user         if balance < 0
    return other_party  if balance > 0
  end

  def debtor
    return other_party  if balance < 0
    return user         if balance > 0
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
