require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'run example'
task :run_example, [:example_name, :options] do |_t, args|
  $LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
  require 'sql_formatter_web_interface'

  example = args.example_name

  raise 'Must provide an example' if example.nil? || example.empty?

  options =
    args.options.to_s.split(';').map do |v|
      vs = v.split(':')
      unless vs.size == 2
        raise 'Options must be in this format: opt1:val1;opt2:val2;...'
      end
      [vs[0], vs[1]]
    end.to_h

  examples_dir = File.join(File.dirname(__FILE__), 'examples')
  examples = Dir[File.join(examples_dir, '*.sql')].map do |filename|
    File.basename(filename, '.sql')
  end

  unless examples.include? example
    raise "there isn't any example named '#{example}'"
  end

  example_content = open(File.join(examples_dir, "#{example}.sql")).read

  puts SqlFormatterWebInterface.new(example_content).format(options)
end
