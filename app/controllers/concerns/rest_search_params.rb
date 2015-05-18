module RestSearchParams
  extend ActiveSupport::Concern

  #Order of operators must be from complex to simple in the Regex.
  FILTER_OPERATORS_REGEX = /<=|>=|!=|=|<>|>|</
  private_constant :FILTER_OPERATORS_REGEX

  def fields
    fields = params[:fields]
    fields.blank? ? [] : fields.split(',').map!{ |field| field.strip }
  end

  # Handles filters in the following format and
  # converts them to an array of hashes.
  # ex. name=john,id>2
  #   [
  #     {field: 'name', operator: '=', value: 'john'},
  #     {field: 'id', operator: '>', value: '2'}
  #   ]
  def filters
    filters = []

    unless params[:filters].blank?
      raw_filters = parse_filters(params[:filters])

      raw_filters.each do |filter|
        filter.strip!
        field, operator, value = clean(filter.partition(FILTER_OPERATORS_REGEX))

        filters << {
          field: field,
          operator: operator,
          value: value
        }
      end
    end
    filters
  end

  # Handles sort options in the following format and
  # converts them to an array of hashes. The order of the
  # sort options is maintained.
  #  -name    =   [{'name' => 'desc'}]
  #  name     =   [{'name' => 'asc'}]
  #  name,-id =   [{'name' => 'asc'}, { 'id' => 'desc'}]
  def sort_order
    sort_order = []

    unless params[:sort].blank?
      field_names = params[:sort].split(',')

      field_names.each do |field_name|
        field_name.strip!
        field_name, order = field_name[1..-1], 'desc' if field_name.start_with?('-')
        order ||= 'asc'

        sort_order << {field_name => order}
      end
    end
    sort_order
  end

  def offset
    params[:offset]
  end

  def limit
    params[:limit]
  end

  private

  def parse_filters(filters)
    # Remove commas in brackets so split doesn't split bracketed values
    filters.gsub!(/\[.*?\]/) do |substr|
      substr.gsub(' ', '').gsub(',', '`')
    end

    filters = filters.split(',')

    # Add commas back inside of brackets
    filters.each do |filter|
      filter.gsub!(/\[.*?\]/) do |substr|
        substr.gsub('`', ',')
      end
    end

    filters
  end

  def clean(filter_parts)
   field, operator, value = *filter_parts

   # Remove whitespace
   field.strip!
   value.strip!

   # Convert partial match symbols
   if value.include?('*')
     value.gsub!('*', '%')
   end

   # Parse values array
   if value.include?('[')
     value.gsub!(']', '')
     value.gsub!('[', '')
     value = value.split(',')
   end

   [field, operator, value]
  end
end
