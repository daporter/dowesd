require 'spec_helper'

describe AccountsHelper do
  describe '#txn_reconciliation_link' do
    it 'has text "reconcile" when txn is unreconciled' do
      user    = FactoryGirl.create(:user)
      account = FactoryGirl.create(:account, user: user)
      txn     = FactoryGirl.create(:txn, account: account, user: user)
      helper.txn_reconciliation_link(txn, user).should =~ /\breconcile\b/
    end

    it 'has text "unreconcile" when txn is reconciled' do
      user    = FactoryGirl.create(:user)
      account = FactoryGirl.create(:account, user: user)
      txn     = FactoryGirl.create(:txn, account: account, user: user)
      reconciliation = FactoryGirl.create(:reconciliation, txn: txn, user: user)
      helper.txn_reconciliation_link(txn, user).should =~ /\bunreconcile\b/
    end
  end
end
