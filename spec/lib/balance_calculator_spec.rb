# encoding: utf-8

require 'balance_calculator'

describe BalanceCalculator do
  context '.balance' do
    it "calculates the difference between user's txns and other party's txns" do
      BalanceCalculator.stub(user_txns_sum: 10)
      BalanceCalculator.stub(other_party_txns_sum: 7)
      BalanceCalculator.balance(double).should == 3
    end

    it "is negative when user's txns < other party's txns" do
      BalanceCalculator.stub(user_txns_sum: 7)
      BalanceCalculator.stub(other_party_txns_sum: 10)
      BalanceCalculator.balance(double).should == -3
    end
  end

  context '.user_txns_sum' do
    it "sum's the user's txns" do
      account = double(user_txns: :user_txns)
      BalanceCalculator.should_receive(:sum_txns).with(:user_txns)
      BalanceCalculator.user_txns_sum(account)
    end
  end

  context '.other_party_txns_sum' do
    it "sum's the other party's txns" do
      account = double(other_party_txns: :sentinel)
      BalanceCalculator.should_receive(:sum_txns).with(:sentinel)
      BalanceCalculator.other_party_txns_sum(account)
    end
  end

  context '.sum_txns' do
    it 'sums the amounts of txns' do
      t1 = double(amount: 1)
      t2 = double(amount: -2)
      t3 = double(amount: 3)
      BalanceCalculator.sum_txns([t1, t2, t3]).should == 2
    end
  end
end
