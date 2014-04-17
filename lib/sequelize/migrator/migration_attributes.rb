module Sequelize
  class Migrator
    class MigrationAttributes

      Attribute = Struct.new(:name, :type, :options)

      Index = Struct.new(:name, :options)

      Types = { 'integer'   => 'Integer',
                'string'   => 'String',
                'char'      => 'String',
                'text'      => 'String',
                'blob'      => 'File',
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
        type.gsub!(/\([0-9]+\)/, '') 
        Types[type]
      end

      def self.extract_options(type)
        options = {}
        splited = type.split(':')
        if length = self.attribute_length(splited.first)
          options[:size] = length
        end
        options
      end

      def add_index(name)
        @indexes << Index.new(name.to_sym)
      end

      def add_attribute(name, type=nil)
        @attributes << Attribute.new(name, type)
      end

    private

      def initialize(params)
        naming = Sequelize::Migrator::Naming.new(params[:name])


        @attributes = naming.columns.map do |column|
          Attribute.new(column)
        end
        @indexes = naming.indexes.map { |index| Index.new(index) }
      end

      def self.attribute_length(attribute_name)
        length = attribute_name.scan(/[0-9]+/).first.to_i
        if length > 0 && length < 255
          length
        end
      end

    end
  end
end