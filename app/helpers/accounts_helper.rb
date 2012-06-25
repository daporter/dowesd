module AccountsHelper
  def current_balance_prefix(account)
    debtor, creditor = account.user, account.other_party
    debtor, creditor = creditor, debtor  if account.balance < 0

    "#{creditor.name} owes #{debtor.name}"
  end
end
