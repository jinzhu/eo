%w(yaml eo/repository eo/gem eo/eo).each {|f| require f}
require 'readline'
include Readline

class Eo
  Repos = Hash.new

  config_file = File.join("#{ENV['HOME']}",".eo/config")
  repos_file = File.join("#{ENV['HOME']}",".eo/repos")

  Config = {'open'  => 'vim'}.merge(
    File.exist?(config_file) ? YAML.load_file(config_file) : {}
  )

  YAML.load_file( repos_file ).each_pair do |key,value|
    Repos[key] = Repository.new(value.merge!("_name_" => key))
  end if File.exist?( repos_file )

  class << self
    def execute(args)
      params = (args.size > 1) ? args[1,args.size].join : ''

      case args.first
      when /^-gs$/i then gemshow(params)
      when /^-gc$/i then gemshell(params)
      when /^-go$/i then gemopen(params)
      when /^-s$/i  then show(params)
      when /^-o$/i  then open(params)
      when /^-c$/i  then choose(params)
      when /^-i$/i  then init(params)
      when /^-u$/i  then update(params)
      when /^-t$/i  then type
      when /^-v$/i  then puts "\e[33mEo_oE : v#{Easyoperate::VERSION}\e[0m"
      when /^-(h|help)$/i  then help
      else self.run
      end
    end

    def run
      loop do
        input = (readline("\e[33mInput Commands (q:quit h:help): \e[0m",true) || exit).rstrip.split(' ',2)

        case input[0].to_s
        when /^GS$/i then gemshow(input[1])
        when /^GC$/i then gemshell(input[1])
        when /^GO$/i then gemopen(input[1])
        when /^S$/i  then show(input[1])
        when /^O$/i  then open(input[1])
        when /^C$/i  then choose(input[1])
        when /^U$/i  then update(input[1])
        when /^I$/i  then init(input[1])
        when /^T$/i  then type
        when /^Q$/i  then exit
        when /^V$/i  then
          puts "\e[33mEo_oE : v" + Easyoperate::VERSION + "\e[0m"
        when /^H|HELP$/i  then help
        else puts "\e[31mError Command\e[0m"
        end
      end
    end

    def help(shell=true)
      puts <<-DOC.gsub(/^(\s*)/,'').gsub(/^\|(\s*)/,'\1' + (shell ? '-':''))
      Usage:

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
      |  V        : Show version information.
      #{shell ? "e.g: \n \e[032m $ eo -S v.*m\e[0m" :
                "e.g:\n  \e[32m s v.*m\e[0m" }
      DOC
    end
  end
end
