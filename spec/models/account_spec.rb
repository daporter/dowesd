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

    it 'raises an exception when the argument is neither' do
      unknown_user = FactoryGirl.create(:user)
      expect { account.other_participant(unknown_user) }.
        to raise_error(Account::UnknownUserError)
    end
  end

  describe '#held_by?' do
    it 'returns true when the person owns the account' do
      owner   = FactoryGirl.create(:user)
      account = FactoryGirl.create(:account, user: owner)
      account.held_by?(owner).should be_true
    end

    context "when the person doesn't own the account" do
      it 'returns true when the person is the other party to the account' do
        other_party = FactoryGirl.create(:user)
        account     = FactoryGirl.create(:account, other_party: other_party)
        account.held_by?(other_party).should be_true
      end

      it "returns false when the person isn't the other party to the account" do
        account = FactoryGirl.create(:account,
                                     other_party: FactoryGirl.create(:user))
        not_other_party = FactoryGirl.create(:user)
        account.held_by?(not_other_party).should be_false
      end
    end
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

    it 'returns nil when the balance is 0' do
      BalanceCalculator.stub(:balance) { 0 }
      account.creditor.should be_nil
    end
  end
end
