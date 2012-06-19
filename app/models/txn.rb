class Txn < ActiveRecord::Base
  attr_accessible :date, :description, :amount

  belongs_to :user

  validates :date, presence: true
  validates :description, presence: true, length: { maximum: 50 }
  validates(:amount,
            presence:  true,
            exclusion: { in: [0], message: 'Amount cannot be 0' })
  validates :user_id, presence: true

  default_scope order: 'txns.date DESC'
end
