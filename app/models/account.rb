class Account < ActiveRecord::Base
  attr_accessible :balance, :balance_dollars, :other_party_id

  has_many :txns
  belongs_to :user
  belongs_to :other_party, class_name: "User"

  validates :user_id,        presence: true
  validates :other_party_id, presence: true
  validates :balance,        presence: true

  def other_party_name
    other_party.name
  end

  def balance_dollars
    balance && balance.to_f / 100
  end
end
