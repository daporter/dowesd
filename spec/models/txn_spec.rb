require "spec_helper"

describe Txn do
  let(:user)       { FactoryGirl.create :user }
  let(:other_user) { FactoryGirl.create :user }
  let(:account) do
    FactoryGirl.create(:account,
                       user:           user,
                       other_party_id: other_user.id,
                       balance:        0)
  end

  before do
    @txn = FactoryGirl.create(:txn,
                              amount:  111,
                              user:    user,
                              account: account)
  end

  subject { @txn }

  it { should respond_to(:date) }
  it { should respond_to(:description) }
  it { should respond_to(:amount) }
  it { should respond_to(:account_id) }
  it { should respond_to(:account) }
  its(:account) { should == account }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Txn.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "when user_id is not present" do
    before { @txn.user_id = nil }
    it { should_not be_valid }
  end

  describe "when account_id is not present" do
    before { @txn.account_id = nil }
    it { should_not be_valid }
  end

  describe "without date" do
    before { @txn.date = nil }
    it { should_not be_valid }
  end

  describe "with blank description" do
    before { @txn.description = " " }
    it { should_not be_valid }
  end

  describe "with description that is too long" do
    before { @txn.description = "a" * 61 }
    it { should_not be_valid }
  end

  describe "when missing amount" do
    before { @txn.amount = nil }
    it { should_not be_valid }
  end

  describe "when zero amount" do
    before { @txn.amount = 0 }
    it { should_not be_valid }
  end

  describe "#amount_dollars" do
    its(:amount_dollars) { should == 1.11 }
  end

  describe "#amount_dollars=" do
    before { @txn.amount_dollars = 3.21 }
    its(:amount) { should == 321 }
  end

  describe "when creating" do
    before { FactoryGirl.create(:txn, amount: 1000, account: account) }

    it "should update the account balance" do
      account.balance.should == 1111
    end
  end

  describe "when updating" do
    before { @txn.update_attribute :amount, 11 }

    it "should update the account balance" do
      account.balance.should == 11
    end
  end

  describe "when destroying" do
    before { @txn.destroy }

    it "should update the account balance" do
      account.balance.should == 0
    end
  end
end
