# == Schema Information
# Schema version: 20120626235852
#
# Table name: accounts
#
#  id             :integer          not null, primary key
#  user_id        :integer          not null
#  other_party_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_accounts_on_other_party_id              (other_party_id)
#  index_accounts_on_user_id                     (user_id)
#  index_accounts_on_user_id_and_other_party_id  (user_id,other_party_id) UNIQUE
#

require 'spec_helper'

describe Account do
  let(:account) { Account.new }

  it { should belong_to(:user) }
  it { should belong_to(:other_party) }
  it { should have_many(:txns) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:other_party_id) }

  it { should_not allow_mass_assignment_of(:user_id) }

  it 'knows the name of the other party' do
    account.other_party = User.new(name: 'David')
    account.other_party_name.should == 'David'
  end

  describe '#other_participant' do
    let(:user)        { User.new(name: 'David') }
    let(:other_party) { User.new(name: 'Deciana') }

    before do
      account.user        = user
      account.other_party = other_party
    end

    it 'returns the other party when the argument is the account user' do
      account.other_participant(user).name.should == 'Deciana'
    end

    it "returns the user when the argument is the account's other party" do
      account.other_participant(other_party).name.should == 'David'
    end

    it 'raises an exception when the argument is neither'
  end

  describe '#creditor' do
    let(:user)        { User.new(name: 'David') }
    let(:other_party) { User.new(name: 'Deciana') }

    before do
      account.user        = user
      account.other_party = other_party
    end

    it 'returns the other party when the balance > 0' do
      BalanceCalculator.stub(:balance) { 100 }
      account.creditor.name.should == 'Deciana'
    end

    it 'returns the user when the balance < 0' do
      BalanceCalculator.stub(:balance) { -100 }
      account.creditor.name.should == 'David'
    end

    it 'returns WHAT? when the balance is 0'
  end

  describe '#debtor' do
    let(:user)        { User.new(name: 'David') }
    let(:other_party) { User.new(name: 'Deciana') }

    before do
      account.user        = user
      account.other_party = other_party
    end

    it 'returns the user when the balance > 0' do
      BalanceCalculator.stub(:balance) { 100 }
      account.debtor.name.should == 'David'
    end

    it 'returns the other party when the balance < 0' do
      BalanceCalculator.stub(:balance) { -100 }
      account.debtor.name.should == 'Deciana'
    end

    it 'returns WHAT? when the balance is 0'
  end
end
