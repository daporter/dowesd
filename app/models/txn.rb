class Txn < ActiveRecord::Base
  attr_accessible :date, :description, :amount, :amount_dollars, :account_id

  belongs_to :user
  belongs_to :account

  validates :date, presence: true
  validates :description, presence: true, length: { maximum: 60 }
  validates(:amount,
            presence:  true,
            exclusion: { in: [0], message: 'Amount cannot be 0' })
  validates :user_id, presence: true
  validates :account_id, presence: true

  default_scope order: 'txns.date DESC'

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
end
