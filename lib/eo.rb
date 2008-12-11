require 'optparse'

class Eo
  def self.execute(stdout, arguments=[])

    parser = OptionParser.new do |opts|
      opts.banner = <<-BANNER.gsub(/^          /,'')
          Usage: #{File.basename($0)} [options]

          Options are:
      BANNER

      opts.on("-h", "--help","Show this help message.") do |args|
        stdout.puts opts; exit
      end

      opts.on("-v", "--version","Show version information.") do |args|
        puts Easyoperate::VERSION
      end

      opts.parse!(arguments)
    end
  end
end
