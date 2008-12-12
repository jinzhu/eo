%w(optparse yaml eo/eo).each {|f| require f}

class Eo

  def self.execute(stdout, arguments=[])

    parser = OptionParser.new do |opts|
      opts.banner = <<-BANNER.gsub(/^          /,'')
          Usage: #{File.basename($0)} [options]

          Options are:
      BANNER

      opts.on_tail("-h", "--help","Show this help message.") do |args|
        stdout.puts opts; exit
      end

      opts.on_tail("-v", "--version","Show version information.") do
        puts Easyoperate::VERSION; exit
      end

      opts.on("-u [ARGS]", "--update","Update Repository.") do |args|
        self.update(args)
      end

      opts.on("-c [ARGS]", "--choose","Choose Repository.") do |args|
        self.choose(args)
      end

      if !arguments.empty?
        opts.parse!(arguments)
      else
        self.run
      end
    end
  end
end
