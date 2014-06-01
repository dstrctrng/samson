require 'pty'

# Executes commands in a fake terminal. The output will be streamed to a
# specified IO-like object.
#
# Example:
#
#   output = StringIO.new
#   terminal = TerminalExecutor.new(output)
#   terminal.execute!("echo", "hello")
#
#   output.string #=> "hello\r\"
#
class TerminalExecutor
  attr_reader :pid

  def initialize(output)
    @output = output
  end

  def execute!(command, *args)
    payload = {}

    ActiveSupport::Notifications.instrument("execute_shell.samson", payload) do
      payload[:success] = execute_command!(command, *args)
    end
  end

  def stop!
    # Kill processes in the same process group
    Process.kill("TERM", -pid) if pid
  end

  private

  def execute_command!(command, *args)
    output, input, @pid = Bundler.with_clean_env do
      PTY.spawn(command, *args, in: "/dev/null")
    end

    begin
      output.each(3) {|line| @output.write(line) }
    rescue Errno::EIO
      # The IO has been closed.
    end

    _, status = Process.wait2(@pid)

    input.close

    return status.success?
  end

  def error(command)
    "Failed to execute \"#{command}\""
  end
end
