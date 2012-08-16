module AccountsHelper
  def current_balance_prefix(account)
    if account.balance != 0
      if current_user == account.creditor
        'You owe'
      else
        "#{account.creditor} owes"
      end
    end
  end
end
