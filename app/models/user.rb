class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :account_id, presence: true, uniqueness: true

  def self.find_by_account_id(account_id)
    find_by(:account_id => account_id.to_s)
  end
end
