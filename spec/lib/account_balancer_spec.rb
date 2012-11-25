require 'account_balancer'

describe AccountBalancer do
  context '.balance' do
    it "calculates the difference between user's txns and other party's txns" do
      AccountBalancer.stub(user_txns_sum: 10)
      AccountBalancer.stub(other_party_txns_sum: 7)
      AccountBalancer.balance(stub).should == 3
    end

    it "is negative when user's txns < other party's txns" do
      AccountBalancer.stub(user_txns_sum: 7)
      AccountBalancer.stub(other_party_txns_sum: 10)
      AccountBalancer.balance(stub).should == -3
    end
  end

  context '.user_txns_sum' do
    it "sum's the user's txns" do
      account = stub(user_txns: :user_txns)
      AccountBalancer.should_receive(:sum_txns).with(:user_txns)
      AccountBalancer.user_txns_sum(account)
    end
  end

  context '.other_party_txns_sum' do
    it "sum's the other party's txns" do
      account = stub(other_party_txns: :other_party_txns)
      AccountBalancer.should_receive(:sum_txns).with(:other_party_txns)
      AccountBalancer.other_party_txns_sum(account)
    end
  end

  context '.sum_txns' do
    it "sums the amounts of txns" do
      t1 = stub(amount: 1)
      t2 = stub(amount: -2)
      t3 = stub(amount: 3)
      AccountBalancer.sum_txns([t1, t2, t3]).should == 2
    end
  end
end
