# encoding: utf-8

#
# Ensures a given user is the holder of a given account.
#
class AccountHolderValidator < ActiveModel::Validator
  def validate(reconciliation)
    unless user_is_account_holder?(reconciliation)
      reconciliation.errors[:user] << 'must be a holder of the owning account'
    end
  end

  private

  def user_is_account_holder?(reconciliation)
    user    = reconciliation.user
    txn     = reconciliation.txn
    account = txn.try(:account)
    if user.present? && txn.present? && account.present?
      user == account.user || user == account.other_party
    else
      false
    end
  end
end
