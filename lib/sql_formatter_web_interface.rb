require 'net/http'
# @author Maurizio De Santis <desantis.maurizio@gmail.com>
#
# This module helps you to format your SQL using an online SQL formatting 
# service (http://sqlformat.appspot.com/format/ is the only supported at the 
# moment), providing a {format} method which accepts a SQL string and returns
# the formatted version.
# 
# @note <b> 
#   Being a web interface, it is _VERY_ unsafe sending data via HTTP
#   to a service that could store informations about the requests; 
#   this library should be used only with queries not including 
#   sensitive data - did someone say <em>development database</em>?
#   </b>
module SqlFormatterWebInterface

  SQL_FORMATTER_URL = 'http://sqlformat.appspot.com/format/'

  # @private
  #   XXX According to HTTP::NET API must be String => String
  DEFAULT_OPTIONS = {
    'format'          => 'text',
    'remove_comments' => '',
    'highlight'       => '',
    'keyword_case'    => 'upper',
    'identifier_case' => '',
    'n_indents'       => '2',
    'right_margin'    => '',
    'output_format'   => 'sql'
  }

  # It makes a request to an online formatting service which will format a SQL string, 
  # according to the setted options (see http://sqlformat.appspot.com for details about
  # the default SQL formatting service)
  #
  # @example
  #   sql = <<-SQL
  #            select user_id, count(*) as how_many from bboard where 
  #            not exists (select 1 from bboard_authorized_maintainers bam 
  #            where bam.user_id = bboard.user_id) and posting_time + 60 > sysdate 
  #            group by user_id order by how_many desc;
  #            SQL
  #   SqlFormatterWebInterface.format(sql) #=>
  #   # SELECT user_id,
  #   #        count(*) AS how_many
  #   # FROM bboard
  #   # WHERE NOT EXISTS
  #   #     (SELECT 1
  #   #      FROM bboard_authorized_maintainers bam
  #   #      WHERE bam.user_id = bboard.user_id)
  #   #   AND posting_time + 60 > sysdate
  #   # GROUP BY user_id
  #   # ORDER BY how_many DESC;
  #
  # @param [String] sql   SQL query to be formatted
  # @param [Hash] options The options to pass to the web service (see 
  #                       http://sqlformat.appspot.com/api/ for informations about the
  #                       available options); it will be merged with {DEFAULT_OPTIONS}.
  #                       The special option +:url+ can be used in order to specify 
  #                       the URL of the request (if +nil+ {SQL_FORMATTER_URL} will be used)
  #
  # @return [String]      If +sql+ is a valid SQL a formatted copy of the string
  #                       converted to the expected format, else an identical copy of the string
  # @raise [SocketError]  When the service cannot reach the setted URL
  def self.format(sql, options = {})
    uri = URI(options[:url].nil? ? SQL_FORMATTER_URL : options.delete(:url))

    stringify_hash!(options)

    options['data'] = sql
    options = DEFAULT_OPTIONS.merge(options)

    Net::HTTP.post_form(uri, options).body

  rescue SocketError
    raise SocketError.new "unable to resolve #{uri.to_s}"
  end

  private
  def self.stringify_hash!(hash)
    hash.keys.each do |key|
      hash[key.to_s] = hash.delete(key).to_s
    end
  end
end
