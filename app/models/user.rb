class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :account_number, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.for_account_number(account_number, enabled = true)
    find_by(account_number: account_number.to_s, enabled: enabled)
  end
end
