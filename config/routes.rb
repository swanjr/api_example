Rails.application.routes.draw do
  resources :apidocs, only: [:index], defaults: {:format => :json}

  namespace 'api', defaults: {format: :json}  do
    namespace 'v2' do
      resources :submission_batches, only: [:index, :show, :create, :update]

      get '/health_check' => 'health_check#show'
    end
  end
end
