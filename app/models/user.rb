class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :account_id, presence: true, uniqueness: true
end
