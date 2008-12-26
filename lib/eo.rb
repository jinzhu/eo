%w(yaml eo/eo).each {|f| require f}

class Eo

  def self.execute(args)

    case args.first
    when "-gs" then self.gemshow(args[1,args.size])
    when "-gc" then self.gemchoose(args[1,args.size])
    when "-s"  then self.show(args[1,args.size])
    when "-c"  then self.choose(args[1,args.size])
    when "-i"  then self.init(args[1,args.size])
    when "-u"  then self.update(args[1,args.size])
    when "-t"  then self.type
    when "-v"  then puts "\e[33mEo_oE : v" + Easyoperate::VERSION + "\e[0m"
    when "-h"  then
      puts <<-DOC.gsub(/^(\s*\|)/,'')
        |Usage: #{File.basename($0)} [options] [ARGS]

        |Options are:
        |  -i        Initialize Repository. <Regexp>
        |  -t        Show All Support Scm
        |  -u        Update Repository. <Regexp>
        |  -s        Show All Repositories. <Regexp>
        |  -c        Choose Repository. <Regexp>
        |  -gs       Show All Gems. <Regexp>
        |  -gc       Choose Gem. <Regexp>
        |  -v        Show version information.
      DOC
    else self.run
    end
  end
end
