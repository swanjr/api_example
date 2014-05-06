Rails.application.routes.draw do

  namespace 'api', :defaults => {:format => :json}  do
    namespace 'v1' do
      resources :authorized_users

      get '/health_check' => 'health_check#show'
    end
  end

end
