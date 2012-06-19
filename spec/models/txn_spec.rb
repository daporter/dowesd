require 'spec_helper'

describe Txn do
  let(:user) { FactoryGirl.create :user }

  before do
    @txn = user.txns.build(date: Date.today, description: 'Lorem', amount: 100)
  end

  subject { @txn }

  it { should respond_to(:date) }
  it { should respond_to(:description) }
  it { should respond_to(:amount) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }

  it { should be_valid }

  describe 'accessible attributes' do
    it 'should not allow access to user_id' do
      expect do
        Txn.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe 'when user_id is not present' do
    before { @txn.user_id = nil }
    it { should_not be_valid }
  end

  describe 'without date' do
    before { @txn.date = nil }
    it { should_not be_valid }
  end

  describe 'with blank description' do
    before { @txn.description = ' ' }
    it { should_not be_valid }
  end

  describe 'with description that is too long' do
    before { @txn.description = 'a' * 51 }
    it { should_not be_valid }
  end

  describe 'without amount' do
    before { @txn.amount = nil }
    it { should_not be_valid }
  end

  describe 'with zero amount' do
    before { @txn.amount = 0 }
    it { should_not be_valid }
  end
end
