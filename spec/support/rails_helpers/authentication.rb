# Example configuration in rails_helper.rb
#
# config.include Authentication, type: :request
#
# A type of :request means this will only be run for request specs or
# when the entire suite is run.
module Authentication
  def http_authorization_header
    #Token is associated with the 'token_user' user factory
    token = 'YlGeha7EwdDiNmqnK6tIC78bl82YU80NX1RUzq0BRTxMIT6K77jJTdi4JUnw8vUE5dNgzrT68pP6rxLLOHxoJvqmf+Cq/s8WQ4FBLnDk7AP9XDRH8PhvUuSUMXMTLeCimz1cvCNa8J67JL1KPYf+e+Cy8uq3D8YdsfmExO709BA=|77u/SlZ2R2JQMEJTZHVQeDdlZ1h3TUYKMTAwCjMxNAo0ME1KQkE9PQpBR3E5SXc9PQowCgoxMS4yMi4zMy40NAowCgpBQkNNTmc9PQo=|3'
    {'HTTP_AUTHORIZATION' => "Token token=#{token}"}
  end
end
