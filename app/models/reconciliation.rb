# encoding: utf-8

# == Schema Information
# Schema version: 20130926102709
#
# Table name: reconciliations
#
#  id         :integer          not null, primary key
#  txn_id     :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_reconciliations_on_txn_id   (txn_id)
#  index_reconciliations_on_user_id  (user_id)
#

#
# Represents a transaction reconciliation.
#
class Reconciliation < ActiveRecord::Base

  #
  # Validator that ensures the owner of the reconciliation is also the account
  # holder.
  #
  class AccountHolderValidator < ActiveModel::Validator
    def validate(reconciliation)
      unless reconciliation.user_is_account_holder?
        reconciliation.errors[:user] << 'must be a holder of the account'
      end
    end
  end

  belongs_to :txn
  belongs_to :user

  attr_accessible :user

  validates :txn_id,  presence: true

  validates(:user_id,
            presence:   true,
            uniqueness: {
              scope:   :txn_id,
              message: 'should be at most 1 per transaction'
            })

  validates :user, account_holder: true

  def user_is_account_holder?
    txn.present? && txn.account_held_by?(user)
  end
end
