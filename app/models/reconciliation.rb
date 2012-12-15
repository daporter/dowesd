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

class Reconciliation < ActiveRecord::Base
  belongs_to :txn
  belongs_to :user

  attr_accessible :user

  validates :txn_id,  presence: true

  validates(:user_id,
            presence:   true,
            uniqueness: {
              scope:   :txn_id,
              message: "should be at most 1 per transaction"
            })

  validates_with AccountHolderValidator
end
