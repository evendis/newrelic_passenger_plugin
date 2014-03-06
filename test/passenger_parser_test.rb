require File.join(File.dirname(__FILE__), 'test_helper')

class PassengerParserTest < Test::Unit::TestCase

  def run_command(cmd)
    PassengerParser.new(cmd).run_command
  end

  # NB these tests assume a *nix environment

  test "when command is successful" do
    command = 'ls'
    assert !run_command(command).empty?
  end

  test "when command exits with error" do
    command = 'bash -c "exit 1"'
    assert run_command(command).nil?
  end

  test "when invalid command" do
    command = 'bogative_command_123'
    assert run_command(command).nil?
  end

end