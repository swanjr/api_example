module AuthenticationHelper
  def http_authorization_header
    token = 'YlGeha7EwdDiNmqnK6tIC78bl82YU80NX1RUzq0BRTxMIT6K77jJTdi4JUnw8vUE5dNgzrT68pP6rxLLOHxoJvqmf+Cq/s8WQ4FBLnDk7AP9XDRH8PhvUuSUMXMTLeCimz1cvCNa8J67JL1KPYf+e+Cy8uq3D8YdsfmExO709BA=|77u/SlZ2R2JQMEJTZHVQeDdlZ1h3TUYKMTAwCjMxNAo0ME1KQkE9PQpBR3E5SXc9PQowCgoxMS4yMi4zMy40NAowCgpBQkNNTmc9PQo=|3'
    {'HTTP_AUTHORIZATION' => "Token token=#{token}"}
  end

  # Warning: Created token_user is not rolled back as part of a transaction.
  def authorize_as(role)
    attributes = FactoryGirl.attributes_for(:token_user)

    user = User.create_with(attributes).
      find_or_create_by!(account_id: attributes[:account_id])
    #user.add_role(role)
    user
  end
end
