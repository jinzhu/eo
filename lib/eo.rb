%w(optparse yaml eo/eo).each {|f| require f}

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

      opts.on("-v", "--version","Show version information.") do
        puts Easyoperate::VERSION
      end

      opts.on("-u", "--update","Update Repository.") do
        #FIXME Update
        #self.run
      end

      if !arguments.empty?
        opts.parse!(arguments)
      else
        self.run
      end
    end
  end
end
