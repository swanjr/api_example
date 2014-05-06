class ValidationErrorsSerializer < ActiveModel::Serializer
  attributes :error_code, :message, :details, :timestamp, :links


end
