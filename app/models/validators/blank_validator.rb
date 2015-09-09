class BlankValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    message = options[:message] || 'must be blank'
    record.errors.add attribute, message unless value.blank?
  end
end
