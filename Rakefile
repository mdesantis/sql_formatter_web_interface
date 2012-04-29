require 'echoe'

Echoe.new("sql_formatter_web_interface") do |p|
  p.url         = 'https://github.com/ProGNOMmers/sql_formatter_web_interface'
  p.project     = 'sql_formatter_web_interface'
  p.author      = "Maurizio De Santis"
  p.email       = 'desantis.maurizio@gmail.com'
  p.description = "SQL formatter web interface - Web interface for SQL formatting"
  p.summary     = "It lets you format SQL via web SQL formatting services"
end

desc 'IRB console'
task :irb do
  $LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
  # require 'sql_formatter_web_interface'
  require 'sql_formatter_web_interface/to_formatted_sql'
  require 'irb'
  ARGV.clear
  IRB.start
end

desc 'run example'
task :run_example, [:example_name, :options] do |t, args|
  $LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
  require 'sql_formatter_web_interface'

  example = args.example_name

  options = 
    if args.options.nil?
      {}
    else
      {}.tap do |hash|
        args.options.split(';').each do |v| 
          _v = v.split(':')
          raise Exception, 'options must be in this format: opt1:val1;opt2:val2;...' unless _v.size == 2
          hash[_v[0]] = _v[1]
        end
      end
    end

  examples_dir = File.join(File.dirname(__FILE__), 'examples')
  examples = Dir[File.join(examples_dir, '*.sql')].map { |filename| File.basename(filename, '.sql') }

  raise Exception, "there is not any example named '#{example}'" unless examples.include? example

  example_content = open(File.join(examples_dir, "#{example}.sql")).read

  puts SqlFormatterWebInterface.format(example_content, options)

end