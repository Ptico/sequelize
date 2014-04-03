require 'sequel/model/inflections'
require 'pry'

module Sequelize
  class Migrator
    class Naming
      include Sequel::Inflections

      ACTION_REGEXP     = /^(create|add|drop|remove|rename|change)_(.*)/.freeze
      TABLE_DIV_REGEXP  = /_(to|from|in|of)_/.freeze
      COLUMN_DIV_REGEXP = /_and_/.freeze
      VIEW_REGEXP       = /(.*)_view$/.freeze
      INDEX_REGEXP      = /(.*)_index$/.freeze
      USE_CHANGE_LIST   = Set.new(['drop', 'remove', 'change']).freeze
      ALTER_ACTIONS     = Set.new(['add', 'remove', 'change']).freeze

      ##
      # Returns: {String} table name
      #
      attr_reader :table_name

      ##
      # Returns: {String} new table name
      #
      attr_reader :table_rename

      ##
      # Returns: {Hash} hash of column renames
      #
      attr_reader :column_changes

      ##
      # Returns: {Set} index names list
      #
      def indexes
        @indexes.map(&:to_sym).to_set
      end

      ##
      # Returns: {Set} column names list
      #
      def columns
        @columns.map(&:to_sym).to_set
      end

      def use_change?
        change? ? false : changing_action?
      end

      def table_action
        alter_table? ? "alter_#{subject_name}" : "#{@action}_#{subject_name}"
      end

      def column_action
        use_change? ? "#{@action}_column" : 'drop_column'
      end

      def index_action
        # HACK:
        # special cases
        return nil if @action == 'change'
        @action = 'create' if @action == 'add'
        use_change? ? "#{@action}_index" : 'drop_index'
      end

    private

      def initialize(name)
        @rest = underscore(name)
        @name = @rest.freeze
        @view = false
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
        if match
          @rest   = match[2]
          @action = match[1]
        end
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

        @column_changes = @renames

        @columns = @renames.keys.to_set
      end

      ##
      # Private: Set table new name
      #
      def set_table_renames
        @table_name, @table_rename = @rest, @table_name if @renames.empty?
      end

      ##
      # Private: helper for table action
      # Returns: {String} subject name ('table' or 'view')
      #
      def subject_name
        @view ? 'view' : 'table'
      end

      ##
      # Private: helper for alter_table?
      # Returns: {Bool} true if we change columns in table
      #
      def change_columns?
        column_changes && !column_changes.empty?
      end

      ##
      # Private: helper for table_action
      # Returns: {Bool} true if we alter table structure
      #
      def alter_table?
        (ALTER_ACTIONS.include? @action) || change_columns?
      end

      ##
      # Private: helper for use_change?
      # Returns: {Bool} true if there is not any action for tables
      def change?
        !@action || @view
      end

      ##
      # Private: hlper for use_change?
      # Returns: {Bool} true if action should make changes in table
      def changing_action?
        !USE_CHANGE_LIST.include? @action
      end

    end
  end
end
