require 'rest_client'

module Security
  class GettyToken < BaseToken

    def self.create(username, password)
      token = nil
      response = call_create_session(username, password)

      status = response["ResponseHeader"]["Status"]

      if status == "success"
        key = response["CreateSessionResult"]["Token"]
        duration = response['CreateSessionResult']['TokenDurationMinutes']
        token = GettyToken.new(key, duration)
      end
      token
    end

    def initialize(key, duration)
      @key = key
      @duration = duration
      @account_id = parse_user_id(key) if key.present?
    end

    private

    def self.call_create_session(username, password)
      begin
        request = create_request(username, password)
        response = RestClient.post(CREATE_SESSION_ENDPOINT,
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
          SystemId:       AUTH_SYSTEM_ID,
          SystemPassword: AUTH_SYSTEM_PASSWORD,
          UserName:       username,
          UserPassword:   password
        }
      }.to_json
    end

    def parse_user_id(token)
      if token.present?
        parts = token.split('|')
        decoded_token =  Base64.decode64(parts[1])
        split_data = decoded_token.split("\n")
        return split_data[2]
      end
      nil
    end

  end
end
