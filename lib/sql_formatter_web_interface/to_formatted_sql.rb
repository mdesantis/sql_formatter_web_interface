require 'sql_formatter_web_interface'

class SqlFormatterWebInterface
  # Includes the {#to_formatted_sql} method into `String`
  module ToFormattedSql
    def self.included(klass)
      klass.send(:include, InstanceMethods)
    end

    # :nodoc:
    module InstanceMethods
      # It calls SqlFormatterWebInterface#format using `self` for `sql`
      # @see SqlFormatterWebInterface#format
      def to_formatted_sql(**options)
        SqlFormatterWebInterface.new(self).format(options)
      end
    end
  end
end

String.send(:include, SqlFormatterWebInterface::ToFormattedSql)
