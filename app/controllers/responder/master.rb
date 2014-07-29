module Responder
  class Master < ActionController::Responder
    include Responder::JSONResourceErrors
  end
end
