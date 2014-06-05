require 'rest_client'
require 'date'

module Security
  class GettyToken < BaseToken
    include Configurable

    attr_accessor :caller_token

    def self.create(username, password)
      getty_token = nil
      response = call_create_session(username, password)

      status = response["ResponseHeader"]["Status"]

      if status == "success"
        token = response["CreateSessionResult"]["Token"]
        getty_token = GettyToken.new(token)
      end
      getty_token
    end

    def initialize(token)
      originating_token, caller_token = separate_tokens(token)

      @analyzer = Security::GettyTokenAnalyzer.new(originating_token)
      @value = originating_token
      @caller_token = caller_token
      @expires_at = @analyzer.expires_at
      @account_id = @analyzer.account_id
    end

    def valid?
      @analyzer.authentic? && !@analyzer.expired? &&
        @analyzer.system_id == self.class.config.auth_system_id.to_s
    end

    def expired?
      @analyzer.expired?
    end

    private

    def self.call_create_session(username, password)
      begin
        request = create_request(username, password)
        response = RestClient.post(config.endpoint,
                                request,
                                {'Content-Type' => 'application/json'})
        return JSON.parse(response)
      rescue RestClient::Exception => e
        #TODO: Log error
        raise TokenError.new("Error occurred while retrieving authentication token for '#{username}'")
      end
    end

    def self.create_request(username, password)
      {
        RequestHeader: {
          Token: ""
        },
        CreateSessionRequestBody: {
          SystemId:       config.auth_system_id,
          SystemPassword: config.auth_system_password,
          UserName:       username,
          UserPassword:   password
        }
      }.to_json
    end

    def separate_tokens(token)
      tokens = token.split('#')

      originating_token = tokens[0]
      caller_token = tokens[1]

      return originating_token, caller_token
    end

  end
end
