# encoding: utf-8

# == Schema Information
# Schema version: 20130926102709
#
# Table name: txns
#
#  id          :integer          not null, primary key
#  date        :date             not null
#  description :string(60)       not null
#  amount      :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#  account_id  :integer          not null
#
# Indexes
#
#  index_txns_on_account_id           (account_id)
#  index_txns_on_account_id_and_date  (account_id,date)
#  index_txns_on_user_id              (user_id)
#  index_txns_on_user_id_and_date     (user_id,date)
#

require "spec_helper"

describe Txn do
  let(:txn) { Txn.new }

  it { should belong_to(:user) }
  it { should belong_to(:account) }
  it { should have_many(:reconciliations).dependent(:destroy) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:account_id) }
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:description) }
  it { should ensure_length_of(:description).is_at_most(60) }

  it { should ensure_exclusion_of(:amount_dollars).in_array([0]).
    with_message("can't be zero") }

  it { should allow_mass_assignment_of(:date) }
  it { should allow_mass_assignment_of(:description) }
  it { should allow_mass_assignment_of(:amount) }
  it { should allow_mass_assignment_of(:amount_dollars) }
  it { should allow_mass_assignment_of(:account_id) }
  it { should allow_mass_assignment_of(:reconciled) }
  it { should_not allow_mass_assignment_of(:user_id) }

  describe 'scope :by_user_and_matching_description' do
    let(:user) { FactoryGirl.create(:user) }

    it 'finds all txns owned by a user and with a matching description' do
      txn1 = FactoryGirl.create(:txn, description: 'foo1', user: user)
      txn2 = FactoryGirl.create(:txn, description: 'foo2', user: user)
      Txn.by_user_and_matching_description(user, 'foo').should =~ [txn1, txn2]
    end

    it "doesn't find txns not owned by user" do
      txn        = FactoryGirl.create(:txn, description: 'foo', user: user)
      wrong_user = FactoryGirl.create(:user)
      Txn.by_user_and_matching_description(wrong_user, 'foo').
        should_not include(txn)
    end

    it "doesn't find txns not matching description" do
      txn  = FactoryGirl.create(:txn, description: 'foo', user: user)
      Txn.by_user_and_matching_description(user, "bar").should_not include(txn)
    end
  end

  describe '.find_for_account_holder' do
    it 'returns the txn when the user owns it' do
      owner = FactoryGirl.create(:user)
      txn   = FactoryGirl.create(:txn, user: owner)
      Txn.find_for_account_holder(txn.id, owner).should == txn
    end

    describe "when the user doesn't own the txn" do
      it "returns the txn when the user is a holder of the txn's account" do
        # FIXME: somehow stub Account#held_by? instead of setting up this
        # data.
        holder  = FactoryGirl.create(:user)
        account = FactoryGirl.create(:account, user: holder)
        txn = FactoryGirl.create(:txn, account: account)
        Txn.find_for_account_holder(txn.id, holder).should == txn
      end

      it "raises an error when the user is not a holder of the txn's account" do
        not_holder = FactoryGirl.create(:user)
        account    = FactoryGirl.create(:account)
        txn        = FactoryGirl.create(:txn, account: account)
        expect do
          Txn.find_for_account_holder(txn.id, not_holder)
        end.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#other_party' do
    it 'returns the other party of the owning account' do
      account             = Account.new
      account.other_party = User.new(name: 'David')
      txn.account         = account
      txn.other_party.name.should == 'David'
    end
  end

  describe "#amount_dollars" do
    it 'returns the amount in dollars' do
      txn.amount = 123
      txn.amount_dollars.should == 1.23
    end

    # FIXME: should this just return 0?
    it 'returns nil when the amount is nil' do
      txn.amount = nil
      txn.amount_dollars.should be_nil
    end
  end

  describe "#amount_dollars=" do
    it 'sets the amount after converting from dollars' do
      txn.amount_dollars = 1.23
      txn.amount.should == 123
    end
  end

  describe '#reconciled_by?' do
    before do
      @user   = FactoryGirl.create(:user)
      account = FactoryGirl.create(:account, user: @user)
      @txn    = FactoryGirl.create(:txn, account: account, user: @user)
      FactoryGirl.create(:reconciliation, txn: @txn, user: @user)
    end

    it "is true when a reconciliaton owned by the given user exists" do
      @txn.reconciled_by?(@user).should be_true
    end

    it "is false when no reconciliation owned by the given user exists" do
      other_user = FactoryGirl.create(:user)
      @txn.reconciled_by?(other_user).should be_false
    end
  end

  describe '#reconciliation_for' do
    before do
      @user   = FactoryGirl.create(:user)
      account = FactoryGirl.create(:account, user: @user)
      @txn    = FactoryGirl.create(:txn, account: account, user: @user)
    end

    it "returns the user's reconciliation if one exists" do
      reconciliation =
        FactoryGirl.create(:reconciliation, txn: @txn, user: @user)
      @txn.reconciliation_for(@user).should == reconciliation
    end

    it "returns nil if the user hasn't created a reconciliation" do
      @txn.reconciliation_for(@user).should be_nil
    end
  end

  describe '#create_reconciliation_for' do
    it 'creates a reconciliation for the txn and user' do
      user    = FactoryGirl.create(:user)
      account = FactoryGirl.create(:account, user: user)
      txn     = FactoryGirl.create(:txn, account: account)
      reconciliaton = txn.create_reconciliation_for(user)
      reconciliaton.txn.should == txn
      reconciliaton.user.should == user
    end
  end
end
