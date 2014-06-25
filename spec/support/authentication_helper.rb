module AuthenticationHelper
  def http_authorization_header
    token = 'JYE3gNbvSv5GH3dAp2QnYAicNf407Yh3z1f7RJi3BNPcD1j4JwRMPutk/9pe01kg0urM2fzIPLNKoCRhuAwwbUoPeQCmmEFZTZw09Sq1MfadjKKL4TJKb5SLvySAvTtG2XUiXNI53oRzzaq7s3gU53cDIiNy9CJbCpLBtoAshDg=|77u/dkZYTnQ5OHlyZmt0dXZnR3lCc1UKMTUyMAo0NzUyOTM5CmpFTUhCUT09CkFHcTlJdz09CjAKCjExLjIyLjMzLjQ0CjAKCkFCQ01OZz09Cgo=|3'
    {'HTTP_AUTHORIZATION' => "Token token=#{token}"}
  end

  def authorize_as(role)
    attributes = FactoryGirl.attributes_for(:token_user)

    user = User.create_with(attributes).
      find_or_create_by!(account_id: attributes[:account_id])
    #user.add_role(role)
    user
  end
end
