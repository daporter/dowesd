# == Schema Information
# Schema version: 20120626235852
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
#  index_txns_on_account_id_and_date  (account_id,date)
#  index_txns_on_user_id_and_date     (user_id,date)
#

require "spec_helper"

describe Txn do
  let(:txn) { Txn.new }

  it { should belong_to(:user) }
  it { should belong_to(:account) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:account_id) }
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:description) }
  it { should ensure_length_of(:description).is_at_most(60) }

  it { should ensure_exclusion_of(:amount_dollars).in_array([0]).
    with_message("can't be zero") }

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
end
