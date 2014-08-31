module Sequelize
  class Migrator
    class MigrationAttributes

      Attribute = Struct.new(:name, :type, :options)

      ForeignKey = Struct.new(:name, :table)

      Types = { 'string'    => 'String',
                'char'      => 'String',
                'text'      => 'String',
                'integer'   => 'Fixnum',
                'bigint'    => 'Bignum',
                'double'    => 'Float',
                'float'     => 'Float',
                'numeric'   => 'BigDecimal',
                'date'      => 'Date',
                'timestamp' => 'DateTime',
                'time'      => 'Time',
                'bool'      => 'TrueClass',
                'boolean'   => 'TrueClass',
                'blob'      => 'File' }.freeze

      LENGTH_REGEXP = /\([0-9]+\)/
 
      attr_reader :attributes, :indexes, :foreign_keys

      ##
      # Params:
      # - type {String} type of attribute option
      #
      # Examples:
      #   normalize_type('bigint') # => 'Bignum'
      #   
      #   normalize_type('specific_type') # => 'specific_type'
      #
      # Returns: {String} normalized name of type
      #
      def self.normalize_type(type)
        if type
          clear_type = type.gsub(LENGTH_REGEXP, '')

          Types.has_key?(clear_type) ? Types[clear_type] : clear_type 
        end
      end

      ##
      # Add new index
      #
      # Params:
      # - name {String} name of index
      #
      def add_index(name)
        @indexes << name.to_sym
      end

      ##
      # Add new attribute
      #
      # Params:
      # - name {Symbol} name of attribute
      #
      # Options:
      # - type {String} normalized type of attribute
      # - options {Hash} additional aptions for attribute
      #
      def add_attribute(name, type=nil, options={})
        @attributes << Attribute.new(name, type, options)
      end

      ##
      # Add new foreign key
      #
      # Params:
      # - name  {Symbol} name of reference column
      # - table {Symbol} name of table
      #
      def add_reference(name, table)
        @foreign_keys << ForeignKey.new(name, table)
        add_index(name)
      end

    private

      def initialize(args, naming_object)
        @naming = naming_object

        @attributes   = []
        @foreign_keys = []

        @indexes = @naming.indexes


        attributes_count = [args.size, @naming.columns.size].max

        attributes_count.times do |index|
          params = tokenize_params(args[index])
          name = (@naming.columns.to_a[index] || params.shift.to_sym)

          parse_item(name, params)
        end
      end

      ##
      # Private: make an array of parameters from parameters string
      #
      # Params:
      # - params {String} params string
      #
      # Returns: {Array} splited params array
      # 
      def tokenize_params(params)
        (params || '').split(':')
      end

      ##
      # Private: parse item
      # and add new foreign key or attribute
      #
      # Params:
      # - name {Symbol} name of attribute
      # - params {Array} array of string with parameters
      #
      def parse_item(name, params)
        if params[0] == 'reference_to'
          table = params[1].to_sym

          add_reference(name, table)
        else
          type = self.class.normalize_type(params[0])
          options = extract_options(params, name)

          add_attribute(name, type, options)
        end
      end

      ##
      # Private: parse options
      #
      # Params:
      # - options_array {Array} array of strings with options
      # - name {Symbol} name of attribute
      #
      # Returns: {Hash} options of attribute
      #
      def extract_options(options_array, name)
        options = {}

        unless options_array.empty?
          if length = attribute_length(options_array.first)
            options[:size] = length
          end

          add_index(name) if options_array.include?('index')

          options[:fixed] = true if (options_array.include?('fixed') || options_array.first.include?('char'))
          options[:only_time] = true if options_array.first.include?('time')
        end

        options
      end

      ##
      # Private: extract attribute paramater "length" from type
      #
      # Examples: 
      #
      #     attribute_length('char(250)')
      #     # => 250
      #
      # Returns: {Fixnum} length option of attribute
      #
      def attribute_length(attribute_name)
        if attribute_name
          length = attribute_name.scan(LENGTH_REGEXP).first

          length.slice(1..-1).to_i if length
        end
      end
    end
  end
end