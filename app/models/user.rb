# == Schema Information
# Schema version: 20120626235852
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(50)       not null
#  email           :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)      not null
#  remember_token  :string(255)
#
# Indexes
#
#  index_users_on_email           (email) UNIQUE
#  index_users_on_remember_token  (remember_token)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation

  has_secure_password

  has_many :txns, dependent: :destroy
  has_many :accounts, dependent: :destroy
  has_many :other_parties, through: :accounts
  has_many(:reverse_accounts,
           foreign_key: "other_party_id",
           class_name:  "Account",
           dependent:   :destroy)
  has_many :reverse_other_parties, through: :reverse_accounts, source: :user

  validates :name,                  presence: true, length: { maximum: 50 }
  validates :password,              presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email,
            presence:   true,
            format:     { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false })

  before_save { self.email.downcase! }
  before_save :create_remember_token

  def feed
    Txn.from_users_sharing_accounts_with(self)
  end

  def has_account_with?(other_user)
    other_parties.include?(other_user) ||
      reverse_other_parties.include?(other_user)
  end

  def open_account_with!(other_user)
    accounts.create!(other_party_id: other_user.id)
  end

  def close_account_with!(other_user)
    accounts.find_by_other_party_id(other_user.id).destroy
  end

  def total_accounts
    accounts.size + reverse_accounts.size
  end

  def to_s
    name
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
