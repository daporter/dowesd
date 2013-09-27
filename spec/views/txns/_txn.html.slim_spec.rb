# encoding: utf-8

require 'spec_helper'

describe 'the txn partial' do
  let(:user) { FactoryGirl.create(:user) }

  before do
    view.stub(:current_user) { user }
  end

  it 'displays a "reconcile" link when txn in unreconciled' do
    txn  = FactoryGirl.create(:txn, id: 2, user: user)
    render partial: 'txns/txn', locals: { txn: txn }
    rendered.should have_selector("#txn-2-reconcile")
  end

  it 'display a "unreconcile" checkbox when the txn is reconciled' do
    account = FactoryGirl.create(:account, user: user)
    txn = FactoryGirl.create(:txn, id: 2, account: account, user: user)
    reconciliation = FactoryGirl.create(:reconciliation, txn: txn, user: user)
    render partial: 'txns/txn', locals: { txn: txn }
    rendered.should have_selector("#txn-2-unreconcile")
  end
end
