module Sequelize
  class Migrator
    class MigrationAttributes

      Attribute = Struct.new(:name, :type, :options)

      Index = Struct.new(:name, :options)

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
                'blob'      => 'File' }

      MaximumLength = 255
 
      attr_reader :attributes, :indexes

      def self.normalize_type(type)
        Types[type.gsub(/\([0-9]+\)/, '')] if type
      end


      def add_index(name, options={})
        @indexes << Index.new(name.to_sym, options)
      end

      def add_attribute(name, type=nil, options={})
        @attributes << Attribute.new(name, type, options)
      end

      def extract_options(options_array, name=nil)
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

    private

      def initialize(params)
        @naming = Sequelize::Migrator::Naming.new(params[:name])

        @indexes = @naming.indexes.map { |index| Index.new(index) }

        if with_names?
          @attributes = params[:args].map do |item|
            name, type, options = parse_attribute(item)
            Attribute.new(name, type, options)
          end
        else
          @attributes = @naming.columns.map.each_with_index do |column, index|
            name, type, options = parse_attribute(params[:args][index], column)
            Attribute.new(name, type, options)
          end
        end

      end

      def parse_attribute(attribute, name=nil)

        type = nil
        options = {}

        if attribute
          splited = attribute.split(':')

          if name
            type    = self.class.normalize_type(splited.first)
            options = extract_options(splited)
          else
            name    = splited[0]
            type    = self.class.normalize_type(splited[1])
            options = extract_options(splited[1..-1], name)
          end
        end

        [name.to_sym, type, options]
      end

      def with_names?
        @naming.table_action == 'create_table'
      end

      def attribute_length(attribute_name)
        if attribute_name
          length = attribute_name.scan(/[0-9]+/).first.to_i
          if length > 0 && length < 255
            length
          end
        end
      end

    end
  end
end