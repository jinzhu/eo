%w(yaml eo/repository eo/gem eo/eo).each {|f| require f}

class Eo
  Repos = Hash.new

  Config_file = File.join("#{ENV['HOME']}",".eorc")

  unless File.exist?(Config_file)
    puts " \e[31m;(     No config file\e[0m \n\nExample Config file:\n\n"
    puts File.read(File.join(File.dirname(__FILE__),'../../example/eorc'))
    exit
  end

  YAML.load_file(Config_file).each_pair do |key,value|
    Repos[key] = Repository.new(value.merge!("_name_" => key))
  end

  class << self
    def execute(args)
      case args.first
      when "-gs" then self.gemshow(args[1,args.size])
      when "-gc" then self.gemshell(args[1,args.size])
      when "-go" then self.gemopen(args[1,args.size])
      when "-s"  then self.show(args[1,args.size])
      when "-o"  then self.open(args[1,args.size])
      when "-c"  then self.choose(args[1,args.size])
      when "-i"  then self.init(args[1,args.size])
      when "-u"  then self.update(args[1,args.size])
      when "-t"  then self.type
      when "-v"  then puts "\e[33mEo_oE : v" + Easyoperate::VERSION + "\e[0m"
      when "-h"  then
        puts <<-DOC.gsub(/^(\s*\|)/,'')
        |Usage: #{File.basename($0)} [options] [ARGS]

        |Options are:
        |  -i        Initialize Repository.     <Regexp>
        |  -t        Show All Support Scm
        |  -u        Update Repository.         <Regexp>
        |  -s        Show All Repositories.     <Regexp>
        |  -o        Open The repository's path <Regexp>
        |  -c        Choose Repository.         <Regexp>
        |  -gs       Show All Gems.             <Regexp>
        |  -gc       Choose Gem.                <Regexp>
        |  -go       Open The Gem's Path        <Regexp>
        |  -v        Show version information.
        DOC
      else self.run
      end
    end


    def run
      loop do
        printf("\e[33mInput Commands (q:quit h:help): \e[0m")
        input = (STDIN.gets || exit).rstrip.split(' ',2)

        case input[0].to_s
        when /GS/i then gemshow(input[1])
        when /GC/i then gemshell(input[1])
        when /GO/i then gemopen(input[1])
        when /S/i  then show(input[1])
        when /O/i  then open(input[1])
        when /C/i  then choose(input[1])
        when /U/i  then update(input[1])
        when /I/i  then init(input[1])
        when /T/i  then type
        when /Q/i  then exit
        else help
        end
      end
    end

    def help
      puts <<-DOC.gsub(/^(\s*\|)/,'')
      |Usage:
      |  I /args/ : Initialize matched Repository <Regexp>
      |  U /args/ : Update matched Repository     <Regexp>
      |  T        : Show All Support Scm
      |  S /args/ : Show matched repositories     <Regexp>
      |  O /args/ : Open The repository's path    <Regexp>
      |  C /args/ : Choose One Repository         <Regexp>
      | GS /args/ : Show matched Gems             <Regexp>
      | GC /args/ : Choose One Gem                <Regexp>
      | GO /args/ : Open The Gem's Path           <Regexp>
      |  Q        : Quit
      |  H        : Show this help message.
      |e.g:\n  \e[32m s v.*m\e[0m
      DOC
    end
  end
end
