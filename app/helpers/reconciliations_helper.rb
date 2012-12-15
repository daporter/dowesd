module ReconciliationsHelper
  def unreconcile_link(txn, reconciliation)
    link_to('unreconcile', txn_reconciliation_path(txn, reconciliation),
            method: :delete, remote: true, id: "txn-#{txn.id}-unreconcile")
  end

  def reconcile_link(txn)
    link_to('reconcile', txn_reconciliations_path(txn),
            method: :post, remote: true, id: "txn-#{txn.id}-reconcile")
  end
end
