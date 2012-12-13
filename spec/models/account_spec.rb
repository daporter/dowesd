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
  let(:user)        { FactoryGirl.create(:user) }
  let(:other_party) { FactoryGirl.create(:user) }
  let(:account) do
    FactoryGirl.create(:account, user: user, other_party: other_party)
  end

  subject { account }

  it { should respond_to(:txns) }
  it { should respond_to(:balance) }
  it { should respond_to(:user) }
  it { should respond_to(:other_party) }

  describe 'accessible attributes' do
    it 'should not allow access to user id' do
      expect do
        Account.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  it 'knows the name of the other party' do
    account.other_party_name.should == other_party.name
  end

  describe 'when other party id is not present' do
    before { account.other_party_id = nil }
    it { should_not be_valid }
  end

  describe 'when user id is not present' do
    before { account.user_id = nil }
    it { should_not be_valid }
  end

  describe '#other_participant' do
    describe 'when argument == user' do
      specify do
        account.other_participant(user).name.should == other_party.name
      end
    end

    describe 'when argument == other_party' do
      specify do
        account.other_participant(other_party).name.should == user.name
      end
    end
  end

  describe 'when balance < 0' do
    before do
      FactoryGirl.create(:txn, account: account, user: user, amount: -1000)
    end

    it 'knows the user is the creditor' do
      account.creditor.name.should == user.name
    end

    it 'knows the other party is the debtor' do
      account.debtor.name.should == other_party.name
    end
  end

  describe 'when balance > 0' do
    before do
      FactoryGirl.create(:txn, account: account, user: user, amount: 2000)
    end

    it 'knows the other party the creditor' do
      account.creditor.name.should == other_party.name
    end

    it 'knows is the user is the debtor' do
      account.debtor.name.should == user.name
    end
  end

  describe 'when balance == 0' do
    before do
      account.txns.clear
    end

    its(:creditor) { should be_nil }
    its(:debtor)   { should be_nil }
  end
end
