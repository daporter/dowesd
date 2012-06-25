require 'spec_helper'

describe Account do
  let(:user)        { FactoryGirl.create(:user) }
  let(:other_party) { FactoryGirl.create(:user) }
  let(:account) do
    FactoryGirl.create(:account, user: user, other_party: other_party)
  end

  subject { account }

  it { should respond_to(:txns) }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user id" do
      expect do
        Account.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "party methods" do
    it { should respond_to(:user) }
    it { should respond_to(:other_party) }
    it { should respond_to(:other_party_name) }
    its(:user)             { should == user }
    its(:other_party)      { should == other_party }
    its(:other_party_name) { should == other_party.name }
  end

  describe "when other party id is not present" do
    before { account.other_party_id = nil }
    it { should_not be_valid }
  end

  describe "when user id is not present" do
    before { account.user_id = nil }
    it { should_not be_valid }
  end

  describe "#balance" do
    before do
      FactoryGirl.create(:txn, account: account, user: user, amount: 1000)
      FactoryGirl.create(:txn, account: account, user: other_party, amount: 250)
      FactoryGirl.create(:txn, account: account, user: user, amount: 5000)
    end

    its(:balance) { should == 5750 }
  end
end
