module Queries
  class DynamicSearch
    attr_reader :limit, :offset

    def self.default_limit
      20
    end

    def self.max_limit
      100
    end

    def self.valid_operators
      ['<=','>=','=','<>','!=','>','<']
    end

    # The search model can be provided instead of subclassing
    # if no customized functionality is needed.
    def initialize(provided_model = nil, limit = nil)
      @search_model = provided_model || search_model
      @order = "#{qualify_field('id')} asc"
      @limit = valid_limit(limit)
      @offset = 0
      @fields = []
      @filters = []
    end

    # Returns the configured search query relation and the total record count.
    def search
      relation = search_model

      relation = relation.select(fields) unless fields.blank?
      filters.each do |filter|
        relation = relation.where(filter[:clause], filter[:value])
      end

      relation = relation.order(order) unless order.blank?
      relation.limit(limit).offset(offset)
    end

    # Returns the total records in the database matching the query.
    def total_records
      relation = search_model

      filters.each do |filter|
        relation = relation.where(filter[:clause], filter[:value])
      end
      relation.count
    end

    # Takes multiple hash args or an array of hashes.
    # Each hash contains the filter's field, operator, and value.
    # Only the records matching the filter(s) will be returned in the query results.
    # ex.
    #    {field: 'name', operator: '=', value: 'john'},
    #    {field: 'id', operator: 'not in', value: [2,3,9]}
    def filter_by(*filters)
      @filters = []

      return self if filters[0].blank?
      @filters = process_filters(handle_nested_array_arg(filters))

      self
    end

    # Takes multiple fields or an array of fields.
    # Only the specified fields are returned in the query results.
    # ex. name, id
    def for_fields(*fields)
      @fields = []

      return self if fields[0].blank?
      @fields = process_fields(handle_nested_array_arg(fields))

      self
    end

    def starting_at(offset = 0)
      @offset = offset.to_i

      self
    end

    # Takes a list of name/order hashes in the order in which
    # they should be applied.
    # ex. {'name' => 'desc'}, {id: 'asc'}
    def sort_by(*sort_order)
      @order = ''

      return self if sort_order[0].blank?
      @order = process_sort_order(handle_nested_array_arg(sort_order))

      self
    end

    def search_model
      return @search_model unless @search_model.blank?

      raise ArgumentError.new(
        "DynamicSearch was not subclassed so an ActiveRecord model must be provided.")
    end

    protected

    attr_accessor :fields, :filters, :order
    attr_writer :limit, :offset

    def process_fields(fields)
      fields.each_with_index do |field_name, index|
        check_field(field_name)
        fields[index] = qualify_field(field_name)
      end
      fields.compact.join(', ')
    end

    def process_filters(filters)
      processed_filters = []

      filters.each do |filter|
        check_field(filter[:field])
        field_name = qualify_field(filter[:field])

        operator = filter[:operator]
        check_operator(operator)

        value = filter[:value]

        # Handle not equal alias
        operator = '<>' if operator == '!='

        # Handle various value formats
        if value.is_a?(Array)
          operator = operator == '=' ? 'in (?)' : 'not in (?)'
        elsif value.nil? || value.to_s.downcase == 'null'
          value = nil
          operator = operator == '=' ? 'is ?' : 'is not ?'
        elsif value.to_s.include?('%')
          operator = operator == '=' ? 'like ?' : 'not like ?'
        else
          operator = "#{operator} ?"
        end

        # @filters cannot be a hash because similar clauses would overwrite each other
        processed_filters << { clause: "#{field_name} #{operator}", value: value }
      end
      processed_filters
    end

    def process_sort_order(sort_order)
      processed_sort_order = ''

      sort_order.each do |sort_option|
        field_name = sort_option.keys[0]
        check_field(field_name.to_s)

        order = sort_option[field_name]
        field_name = qualify_field(field_name.to_s)

        processed_sort_order << "#{field_name} #{order},"
      end
      processed_sort_order.chomp(',')
    end

    # Subclasses may override this method to qualify a field name with a table name or 
    # map it to a new name.
    def qualify_field(field_name)
      "#{search_model.table_name}.#{field_name.to_s}"
    end

    def valid_operator?(operator)
      self.class.valid_operators.include?(operator.strip.downcase)
    end

    # Subclasses may override to allow field names on association tables.
    def valid_field?(field_name)
      search_model.column_names.include?(field_name.to_s.strip.downcase)
    end

    private

    def valid_limit(limit)
      limit = limit.to_i
      if limit < 1
        limit = self.class.default_limit
      elsif limit > self.class.max_limit
        limit = self.class.max_limit
      end
      limit
    end

    def handle_nested_array_arg(values)
      (values.is_a?(Array) && values[0].is_a?(Array)) ? values[0] : values
    end

    def check_operator(operator)
      raise InvalidOperatorError.new("Unrecognized operator '#{operator}'") unless
      valid_operator?(operator)
    end

    def check_field(field_name)
      raise InvalidFieldError.new("Unrecognized field '#{field_name}'") unless
      valid_field?(field_name)
    end
  end
end
