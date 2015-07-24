class Group < ActiveRecord::Base
  has_and_belongs_to_many :permissions, join_table: :group_permissions do
    def <<(*permissions)
      permissions.flatten.each do |permission|
        begin
          super(permission)
        rescue ActiveRecord::RecordNotUnique
          #Absorb unique error since it means the permission was already assigned
        end
      end
    end
  end

  has_and_belongs_to_many :users, join_table: :group_users do
    def <<(*users)
      users.flatten.each do |user|
        begin
          super(user)
        rescue ActiveRecord::RecordNotUnique
          #Absorb unique error since it means the user was already assigned
        end
      end
    end
  end

  validates :name, presence: true, uniqueness: true

  def add_user(user)
    user.permissions << permissions
    users << user
    user.reload
  end

  def remove_user(user)
    remaining_permissions = user.groups.map do |group|
      group.permissions if group.id != self.id
    end.flatten.compact

    users.delete(user)

    user.permissions = remaining_permissions
    user.reload
  end
end
