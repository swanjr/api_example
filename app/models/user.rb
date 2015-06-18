class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :account_number, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  has_and_belongs_to_many :roles, join_table: :users_roles

  def self.for_account_number(account_number, enabled = true)
    find_by(account_number: account_number.to_s, enabled: enabled)
  end
end
