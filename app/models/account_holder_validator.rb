# encoding: utf-8

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
