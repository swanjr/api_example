class API::V1::HealthCheckController < API::BaseController

  def show
    render :json => run_diagnostics
  end

  private

  #def success
    #{ :status => 'ok' }
  #end

  #def error(e)
    #{ :status => 'error', :error => e.message }
  #end

  def run_diagnostics
    results = {}

    ## RDS
    #begin
      #Rails.logger.info("Checking RDS")
      #SubmissionBatch.last
      #results[:rds] = success
    #rescue Exception => e
      #results[:rds] = error(e)
    #end

    ## EWS CreateSession
    #begin
      #Rails.logger.info("Checking EWS CreateSession")
      #@token = EventService.send(:get_token)
      #results[:ews_create_session] = success
    #rescue Timeout::Error, Exception => e
      #results[:ews_create_session] = error(e)
    #end

    ## EWS Event
    #begin
      #Rails.logger.info("Checking EWS Event Service")
      #EventService.get_event_details({})
      #results[:ews_event] = success
    #rescue Timeout::Error, Exception => e
      #results[:ews_event] = error(e)
    #end

    ## DSA
    #if Flip.dsa_publish?
      #begin
        #Rails.logger.info("Checking DSA")
        #Net::HTTP.get('dsa-beta.gettyimages.io', '/health/ping')
        #results[:dsa] = success
      #rescue Timeout::Error, Exception => e
        #results[:dsa] = error(e)
      #end
    #end

    ## Redis
    #begin
      #Rails.logger.info("Checking Redis")
      #$redis.ping
      #results[:redis] = success
    #rescue Exception => e
      #results[:redis] = error(e)
    #end

    ## Encoding.com
    #begin
      #Rails.logger.info("Checking Encoding.com")
      #client = EncodingClient.new("http://status.encoding.com/status.php")
      #response = client.api_status
      #if response.message == 'ok'
        #results[:encoding_com] = success
      #else
        #results[:encoding_com] =   { :status => 'error', :error => response.error }
      #end
    #end

    results
  end
end
