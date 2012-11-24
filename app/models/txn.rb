# == Schema Information
# Schema version: 20120626235852
#
# Table name: txns
#
#  id          :integer          not null, primary key
#  date        :date             not null
#  description :string(60)       not null
#  amount      :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#  account_id  :integer          not null
#
# Indexes
#
#  index_txns_on_account_id_and_date  (account_id,date)
#  index_txns_on_user_id_and_date     (user_id,date)
#

class Txn < ActiveRecord::Base
  attr_accessible :date, :description, :amount, :amount_dollars, :account_id

  belongs_to :user
  belongs_to :account

  validates :date, presence: true
  validates :description, presence: true, length: { maximum: 60 }
  validates(:amount_dollars,
            presence:  true,
            exclusion: { in: [0], message: "can't be zero" })
  validates :user_id, presence: true
  validates :account_id, presence: true

  default_scope order: "txns.date DESC, txns.created_at DESC"

  scope(:by_user_and_matching_description,
        lambda { |user, term| where("user_id = ? AND description LIKE ?",
                                    user.id, "%#{term}%") })

  def self.from_users_sharing_accounts_with(user)
    other_party_ids = ("SELECT other_party_id FROM accounts " \
                       "WHERE user_id = :user_id")
    where("user_id IN (#{other_party_ids}) OR user_id = :user_id",
          user_id: user)
  end

  def amount_dollars
    amount && amount.to_f / 100
  end

  def amount_dollars=(v)
    self.amount = v.to_f * 100
  end

  def other_party
    account.other_party
  end
end
