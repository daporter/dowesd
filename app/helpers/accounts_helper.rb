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

  def txn_reconciliation_link(txn, user)
    if txn.reconciled_by?(user)
      reconciliation = txn.reconciliation_for(user)
      unreconcile_link(txn, reconciliation)
    else
      reconcile_link(txn)
    end
  end
end
