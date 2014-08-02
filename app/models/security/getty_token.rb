require 'rest_client'
require 'date'

module Security
  class GettyToken
    include Configurable

    attr_reader :account_id, :value, :expires_at
    attr_accessor :caller_token

    def self.create(username, password, client_ip, options = {})
      getty_token = nil
      response = call_get_user_token(username, password, client_ip, options)

      status = response['ResponseHeader']['Status']

      if ['success', 'warning'].include?(status)
        token = response['GetUserTokenResponseBody']['NonSecureToken']['Token']
        getty_token = GettyToken.new(token)
      end
      getty_token
    end

    def self.renew(token_value, options = {})
      getty_token = nil
      token_value = token_value.value if token_value.class.equal?(self.class)

      response = call_renew_token(token_value, options)

      status = response['ResponseHeader']['Status']

      if ['success', 'warning'].include?(status)
        token = response['RenewTokenResponseBody']['Token']
        getty_token = GettyToken.new(token)
      end
      getty_token
    end

    def initialize(token, auth_system_id = self.class.config.auth_system_id)
      originating_token, caller_token = separate_tokens(token)

      @analyzer = Security::GettyTokenAnalyzer.new(originating_token)
      @value = originating_token
      @caller_token = caller_token
      @expires_at = @analyzer.expires_at
      @account_id = @analyzer.account_id
      @auth_system_id = auth_system_id.to_s
    end

    def valid?
      @analyzer.authentic? && !expired? &&
        @analyzer.system_id == @auth_system_id
    end

    def expired?
      @analyzer.expires_at < DateTime.now
    end

    private

    def self.call_get_user_token(username, password, client_ip, options)
      begin
        request = {
          'RequestHeader' => header(options),
          'GetUserTokenRequestBody' => {
            'ClientIp' => client_ip,
            'EnhancedAuthenticationMode' => 0,
            'SystemId' => config.auth_system_id,
            'SystemPassword' => config.auth_system_password,
            'UserName' => username,
            'UserPassword' => password
          }
        }.to_json

        return call_service(config.get_user_token_endpoint, request)
      rescue RestClient::Exception => e
        #TODO: Log error
        raise TokenError.new("Error occurred retrieving authentication token for '#{username}'")
      end
    end

    def self.call_renew_token(token, options)
      begin
        request = {
          'RequestHeader' => header(options),
          'RenewTokenRequestBody' => {
            'SystemId' => config.auth_system_id,
            'SystemPassword' => config.auth_system_password,
            'Token' => token
          }
        }.to_json

        return call_service(config.renew_token_endpoint, request)
      rescue RestClient::Exception => e
        #TODO: Log error
        raise TokenError.new("Error occurred renewing authentication token")
      end
    end

    def self.header(options)
      {
        'Token' => '',
        'CoordinationId' => options[:coordination_id] || ''
      }
    end

    def self.call_service(endpoint, request)
      response = RestClient.post(endpoint, request, {'Content-Type' => 'application/json'})
      JSON.parse(response)
    end

    def separate_tokens(token)
      tokens = token.split('#')

      originating_token = tokens[0]
      caller_token = tokens[1]

      return originating_token, caller_token
    end
  end

  class TokenError < StandardError
  end
end
