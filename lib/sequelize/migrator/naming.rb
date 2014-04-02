require 'sequel/model/inflections'

module Sequelize
  class Migrator
    class Naming
      include Sequel::Inflections

      ACTION_REGEXP     = /^(create|add|drop|remove|rename|change)_(.*)/.freeze
      TABLE_DIV_REGEXP  = /_(to|from|in)_/.freeze
      COLUMN_DIV_REGEXP = /_and_/.freeze
      VIEW_REGEXP       = /(.*)_view$/.freeze
      INDEX_REGEXP      = /(.*)_index$/.freeze

      ##
      # Returns: {String} table name
      #
      attr_reader :table_name

      ##
      # Returns: {String} new table name
      #
      attr_reader :table_rename

      ##
      # Returns: {Set} column names list
      #
      attr_reader :columns

      ##
      # Returns: {Hash} hash of column renames
      #
      attr_reader :column_changes

      ##
      # Returns: {Set} index names list
      #
      attr_reader :indexes

      def use_change?

      end

      def table_action

      end

      def column_action

      end

      def index_action

      end

    private

      def initialize(name)
        @rest = underscore(name)
        @name = @rest.freeze
        @renames = {}
        tokenize
      end

      def tokenize
        get_action
        get_table
        get_columns
        if @action == 'rename'
          set_column_renames
          set_table_renames
        end
      end

      ##
      # Private: Extract action name from name
      #
      def get_action
        match = ACTION_REGEXP.match(@name)

        @rest   = match[2]
        @action = match[1]
      end

      ##
      # Private: Extract table name and detect
      # if table is view
      #
      def get_table
        parts = @rest.split(TABLE_DIV_REGEXP)

        @table_name = parts.pop

        if match = VIEW_REGEXP.match(table_name)
          @view = true
          @table_name = match[1]
        end

        parts.pop
        @rest = parts.join('_')
      end

      ##
      # Private: Extract column and index names
      #
      def get_columns
        columns = @rest.split(COLUMN_DIV_REGEXP)

        @columns = Set.new
        @indexes = Set.new

        columns.each do |col|
          if match = INDEX_REGEXP.match(col)
            @indexes << match[1]
          else
            @columns << col
          end
        end
      end

      ##
      # Private: Create hash where key is old column name
      # and values is new column name
      #
      def set_column_renames
        @renames = @columns.each_with_object({}) do |column, renames|
          if column.include?('_to_')
            cols = column.split('_to_')
            renames[cols.first] = cols.last
          end
        end

        @columns = @renames.keys.to_set
      end

      ##
      # Private: Set table new name
      #
      def set_table_renames
        @table_name, @table_rename = @rest, @table_name if @renames.empty?
      end

    end
  end
end
