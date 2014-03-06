require 'open3'

class PassengerParser
  attr_reader :command
  attr_reader :passenger_version
  attr_reader :generate_dummy_stats
  attr_accessor :output_to_parse

  def initialize(command = nil, passenger_version = 3)
    @command = command
    @passenger_version = passenger_version
    @generate_dummy_stats = generate_dummy_stats
  end

  # Command: gets fresh results.
  # Returns true if new data available, else false
  def refresh!
    !!(self.output_to_parse = run_command)
  end

  # Returns the results of running @command or nil if error
  # This handles stdout/stderr from the command correctly so the plugin can run fine without tty
  def run_command
    # uncomment to test example_output files
    # return File.read(File.join(File.dirname(__FILE__), "../test/example_output/#{command.split('/').last}_version-#{passenger_version}"))
    stdout_result = nil
    stderr_result = nil
    result = nil
    Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
      stdout_result = stdout.read
      stderr_result = stderr.read
      result = wait_thr.value
    end
    if result.success?
      stdout_result
    else
      $stderr.puts "failed executing #{command} #{stderr_result}"
      nil
    end
  rescue Exception => e
    $stderr.puts "failed executing #{command} #{e.message}"
    nil
  end

end

require File.join(File.dirname(__FILE__), 'passenger_memory_stats_parser')
require File.join(File.dirname(__FILE__), 'passenger_status_parser')