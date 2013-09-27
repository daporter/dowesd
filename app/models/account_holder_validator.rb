# encoding: utf-8

#
# Ensures a given user is the holder of a given account.
#
class AccountHolderValidator < ActiveModel::Validator
  def validate(record)
    unless user_is_account_holder?(record)
      record.errors[:user] << 'must be a holder of the owning account'
    end
  end

  private

  def user_is_account_holder?(record)
    if record.user.present? &&
        record.txn.present? &&
        record.txn.account.present?
      record.user == record.txn.account.user ||
        record.user == record.txn.account.other_party
    else
      false
    end
  end
end
