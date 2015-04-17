require 'rest_client'
require 'date'

module Security
  class GettyToken
    cattr_accessor :config

    attr_reader :account_number, :value, :expires_at, :system_token
    attr_accessor :caller_token

    def self.create_system_token(coordination_id = '')
      getty_token = nil
      response = call_get_system_token(coordination_id)

      status = response['ResponseHeader']['Status']

      if ['success', 'warning'].include?(status)
        token = response['GetSystemTokenResponseBody']['Token']
        getty_token = GettyToken.new(token)
      end
      getty_token
    end

    def self.renew(token_value, coordination_id = '')
      getty_token = nil
      token_value = token_value.value if token_value.class.equal?(self)

      response = call_renew_token(token_value, coordination_id)

      status = response['ResponseHeader']['Status']

      if ['success', 'warning'].include?(status)
        token = response['RenewTokenResponseBody']['Token']
        getty_token = GettyToken.new(token)
      end
      getty_token
    end


    def initialize(token, allow_system_token = false)
      originating_token, caller_token = separate_tokens(token)

      @analyzer = Security::GettyTokenAnalyzer.new(originating_token)
      @value = originating_token
      @caller_token = caller_token
      @expires_at = @analyzer.expires_at
      @account_number = @analyzer.account_number
      @system_token = @account_number.blank?
      @allow_system_token = allow_system_token
    end

    def valid?
      valid = @analyzer.authentic? && !expired?
      valid = valid && !@system_token unless @allow_system_token
      valid
    end

    def invalid?
      !valid?
    end

    def expired?
      expires_at < DateTime.now
    end

    private

    def self.call_get_system_token(coordination_id)
      begin
        request = {
          'RequestHeader' => header(coordination_id),
          'GetSystemTokenRequestBody' => {
            'SystemId' => self.config[:auth_system_id],
            'SystemPassword' => self.config[:auth_system_password]
          }
        }.to_json

        return call_service(self.config[:get_system_token_endpoint], request)
      rescue RestClient::Exception
        raise TokenError.new("Error occurred retrieving system token for system id #{config[:auth_system_id]}.")
      end
    end

    def self.call_renew_token(token, coordination_id)
      begin
        request = {
          'RequestHeader' => header(coordination_id),
          'RenewTokenRequestBody' => {
            'SystemId' => self.config[:auth_system_id],
            'SystemPassword' => self.config[:auth_system_password],
            'Token' => token
          }
        }.to_json

        return call_service(self.config[:renew_token_endpoint], request)
      rescue RestClient::Exception
        raise TokenError.new("Error occurred renewing authentication token.")
      end
    end

    def self.header(coordination_id)
      {
        'Token' => '',
        'CoordinationId' => coordination_id
      }
    end

    def self.call_service(endpoint, request)
      response = RestClient.post(endpoint, request, {'Content-Type' => 'application/json'})
      JSON.parse(response)
    end

    def separate_tokens(token)
      return nil unless token

      tokens = token.split('#')

      originating_token = tokens[0]
      caller_token = tokens[1]

      return originating_token, caller_token
    end
  end

  class TokenError < StandardError
  end
end
