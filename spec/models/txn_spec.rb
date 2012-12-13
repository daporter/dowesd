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
  let(:user)       { FactoryGirl.create :user }
  let(:other_user) { FactoryGirl.create :user }
  let(:account) do
    FactoryGirl.create(:account, user: user, other_party_id: other_user.id)
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
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Txn.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
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

  describe "when missing amount_dollars" do
    before { @txn.amount_dollars = nil }
    it { should_not be_valid }
  end

  describe "with zero amount_dollars" do
    before { @txn.amount_dollars = 0 }
    it { should_not be_valid }
  end

  describe "#amount_dollars" do
    its(:amount_dollars) { should == 1.11 }
  end

  describe "#amount_dollars=" do
    before { @txn.amount_dollars = 3.21 }
    its(:amount) { should == 321 }
  end

  describe "scope :by_user_and_matching_description" do
    before do
      @txn1 = FactoryGirl.create(:txn, description: "Foobar", user: user)
      @txn2 = FactoryGirl.create(:txn, description: "Bazbat", user: user)
      @txn3 = FactoryGirl.create(:txn, description: "Foobaz", user: user)
      @txn4 = FactoryGirl.create(:txn, description: "Foobar", user: other_user)
    end

    it "should return all txns with given user and matching description" do
      Txn.by_user_and_matching_description(user, "oba").should =~ [@txn1, @txn3]
    end

    it "should not return txns not owned by user" do
      Txn.by_user_and_matching_description(user, "oba").should_not include(@txn4)
    end

    it "should not return txns not matching description" do
      Txn.by_user_and_matching_description(user, "oba").should_not include(@txn2)
    end
  end
end
