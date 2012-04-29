require 'sql_formatter_web_interface'

module SqlFormatterWebInterface
  # Includes the {InstanceMethods#to_formatted_sql} method in the +String+ class
  module ToFormattedSql
    def self.included(klass)
      klass.send(:include, InstanceMethods)
    end

    module InstanceMethods
      # It calls {SqlFormatterWebInterface::format} using +self+ for +sql+
      # @see SqlFormatterWebInterface::format
      def to_formatted_sql(options = {})
        SqlFormatterWebInterface.format(self, options)
      end
    end
  end
end

String.send(:include, SqlFormatterWebInterface::ToFormattedSql)