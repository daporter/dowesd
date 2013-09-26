# enncoding: utf-8

# == Schema Information
# Schema version: 20130926102709
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
#  index_txns_on_account_id           (account_id)
#  index_txns_on_account_id_and_date  (account_id,date)
#  index_txns_on_user_id              (user_id)
#  index_txns_on_user_id_and_date     (user_id,date)
#

class Txn < ActiveRecord::Base
  attr_accessible(:date,
                  :description,
                  :amount,
                  :amount_dollars,
                  :account_id,
                  :reconciled)

  belongs_to :user
  belongs_to :account
  has_many :reconciliations, dependent: :destroy

  validates :date, presence: true
  validates :description, presence: true, length: { maximum: 60 }
  validates(:amount_dollars,
            presence:  true,
            exclusion: { in: [0], message: "can't be zero" })
  validates :user_id, presence: true
  validates :account_id, presence: true

  scope :date_desc, order: 'txns.date DESC, txns.created_at DESC'

  def self.by_user_and_matching_description(user, term)
    where('user_id = ? AND description LIKE ?', user.id, "%#{term}%").date_desc
  end

  def self.find_for_account_holder(txn_id, user)
    txn = find(txn_id)
    if txn.user == user || txn.account.held_by?(user)
      txn
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def other_party
    account.other_party
  end

  def amount_dollars
    amount && amount.to_f / 100
  end

  def amount_dollars=(v)
    self.amount = v.to_f * 100
  end

  def reconciled_by?(user)
    reconciliations.exists?(user_id: user.id)
  end

  def reconciliation_for(user)
    if reconciled_by?(user)
      reconciliations.where(user_id: user.id).first
    end
  end

  def create_reconciliation_for(user)
    reconciliations.create(user: user)
  end
end
