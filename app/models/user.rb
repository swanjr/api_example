class User < ActiveRecord::Base
  has_and_belongs_to_many :permissions, join_table: :user_permissions do
    def <<(*permissions)
      permissions.flatten.each do |permission|
        begin
          super(permission)
        rescue ActiveRecord::RecordNotUnique
          #Absorb unique error since it means the permission was already assigned
        end
      end
    end

    def names
      pluck(:name)
    end
  end

  has_and_belongs_to_many :groups, join_table: :group_users do
    def <<(*groups)
      groups.flatten.each do |group|
        begin
          super(group)
        rescue ActiveRecord::RecordNotUnique
          #Absorb unique error since it means the group was already assigned
        end
      end
    end
  end

  validates :username, presence: true, uniqueness: true
  validates :account_number, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.for_account_number(account_number, enabled = true)
    find_by(account_number: account_number.to_s, enabled: enabled)
  end

  def has_permission?(permission_name)
    permissions.names.include?(permission_name.to_s)
  end
end
