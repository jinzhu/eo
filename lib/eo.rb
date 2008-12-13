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

      opts.on("-s [ARGS]", "--show","Show All Repositories.") do |args|
        self.show(args)
      end

      opts.on("-c [ARGS]", "--choose","Choose Some Repository.") do |args|
        self.choose(args)
      end

      opts.on("-i [ARGS]", "--init","Initialize Repository.") do |args|
        self.init(args)
      end

      if !arguments.empty?
        begin
          opts.parse!(arguments)
        rescue OptionParser::InvalidOption
          puts "\e[31m;(\tError\e[0m \n\tHelp?\t\e[33m$ eo -h \e[31m;)\e[0m"
        end
      else
        self.run
      end
    end
  end
end
