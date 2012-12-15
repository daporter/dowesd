# == Schema Information
# Schema version: 20121216015420
#
# Table name: reconciliations
#
#  id         :integer          not null, primary key
#  txn_id     :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Reconciliation do
  it { should belong_to(:txn) }
  it { should belong_to(:user) }

  it { should allow_mass_assignment_of(:user) }

  it { should validate_presence_of(:txn_id) }
  it { should validate_presence_of(:user_id) }

  it 'is invalid if the user already has a reconciliation for this txn' do
    user = FactoryGirl.build(:user)
    txn  = FactoryGirl.build(:txn, user: user)
    FactoryGirl.build(:reconciliation, txn: txn, user: user)
    FactoryGirl.build(:reconciliation, txn: txn, user: user).should_not be_valid
  end

  it 'is invalid if the user is not a holder of the owning account' do
    user, other_party = FactoryGirl.create(:user), FactoryGirl.create(:user)
    account = FactoryGirl.create(:account,
                                user: user,
                                other_party: other_party)
    txn = FactoryGirl.create(:txn, account: account, user: user)
    not_account_holder = FactoryGirl.create(:user)
    rec = FactoryGirl.build(:reconciliation, txn: txn, user: not_account_holder)
    rec.should_not be_valid
  end
end
