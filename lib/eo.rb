%w(optparse yaml eo/eo).each {|f| require f}

class Eo

  def self.execute(args)

    case args.first
    when "-s" then self.show(args[1,args.size])
    when "-c" then self.choose(args[1,args.size])
    when "-i" then self.init(args[1,args.size])
    when "-u" then self.update(args[1,args.size])
    when "-v" then puts "\e[33mEo_oE : v" + Easyoperate::VERSION + "\e[0m"
    when "-h" then
      puts <<-DOC.gsub(/^(\s*\|)/,'')
        |Usage: #{File.basename($0)} [options] [ARGS]

        |Options are:
        |  -u        Update Repository. <Regexp>
        |  -s        Show All Repositories. <Regexp>
        |  -v        Show version information.
        |  -c        Choose Repository.
        |  -i        Initialize Repository. <Regexp>
      DOC
    else self.run
    end
  end
end
