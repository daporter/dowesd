require 'active_support/all'

class BalanceCalculator
  def self.balance(account)
    user_txns_sum(account) - other_party_txns_sum(account)
  end

  def self.user_txns_sum(account)
    sum_txns(account.user_txns)
  end

  def self.other_party_txns_sum(account)
    sum_txns(account.other_party_txns)
  end

  def self.sum_txns(txns)
    txns.sum(&:amount)
  end
end
