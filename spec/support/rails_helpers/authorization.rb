# Example configuration in rails_helper.rb
#
# config.include Authorization, type: :request
#
# A type of :request means this will only be run for request specs or
# when the entire suite is run.
module Authorization

  # Warning: Created token_user is not rolled back as part of a transaction.
  def user_authorized_to(*permission_names)
    attributes = FactoryGirl.attributes_for(:token_user)

    user = User.where(attributes).first_or_create!

    permissions = []
    permission_names.each do |name|
      permissions << Permission.where(name: name).first_or_create!
    end
    user.permissions = permissions

    user
  end
end
