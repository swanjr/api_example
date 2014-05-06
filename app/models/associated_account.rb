class AssociatedAccount < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true
  validates :type, presence: true
  validates :username, presence: true, uniqueness: {scope: :type}
  validates :account_id, presence: true, uniqueness: {scope: :type}
end
