require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'run example'
task :run_example, [:example_name, :options] do |_t, args|
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
