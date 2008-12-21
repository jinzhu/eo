require 'eo/repository'
class Eo
  Repos = Hash.new

  Config_file = File.join("#{ENV['HOME']}",".eorc")

  unless File.exist?(Config_file)
    puts " \e[31m;(     No config file\e[0m \n\nExample Config file:\n\n"
    puts File.read(File.join(File.dirname(__FILE__),'../../example/eorc'))
    exit
  end

  YAML.load_file(Config_file).each_pair do |key,value|
    Repos[key] = Repository.new(value.merge(:_name_ => key))
  end

  class << self
    def run
      loop do
        printf("\e[33mInput Commands (q:quit h:help): \e[0m")
        input = STDIN.gets.split(' ',2)
        input[1] ? input[1].strip! : next

        case input[0].to_s
        when /S/i then show(input[1])
        when /C/i then choose(input[1])
        when /U/i then update(input[1])
        when /I/i then init(input[1])
        when /Q/i then exit
        else help
        end
      end
    end

    def help
      puts <<-DOC.gsub(/^(\s*\|)/,'')
      |Usage:
      |  S /args/ : Show matched repositories <Regexp>
      |  C /args/ : Choose One Repository <Regexp>
      |  U /args/ : Update matched Repository <Regexp>
      |  I /args/ : Initialize matched Repository <Regexp>
      |  Q        : Quit
      |  H        : Show this help message.
      |e.g:\n  \e[32m s v.*m\e[0m
      DOC
    end

    def show(*args)
      repos = pick(args,false)
      puts "\e[33mAll Repo match < #{args} > :\e[0m"

      repos.each_index do |x|
        printf "\e[32m %-22s\e[0m" % [repos[x].rstrip]
        printf("\n") if (x+1)%3==0
      end
      puts "\n" if repos.size%3 != 0
    end

    def choose(*args)
      repos = pick(args)
      if repos && repos = repos.to_s
        return false unless exist_path(repos)
        loop do
          printf("\e[01;34m#{repos.first} (h:help)>> \e[0m")
          input = STDIN.gets.strip
          break if input =~ /\A\s*q\s*\Z/
          exit if input =~ /\A\s*Q\s*\Z/
          Repos[repos].send(input) unless input.empty?
        end
      end
    end

    def init(*args)
      repos = pick(args,false)
      repos.each do |x|
        if File.exist?(File.expand_path(Repos[x].path))
          puts "\e[32m %-18s: already Initialized\e[0m" % [x]
          next
        end
        puts "\e[32m %-18s: Initializing\e[0m" % [x]
        Repos[x].init
      end
    end

    def update(*args)
      repos = pick(args,false)
      repos.each do |x|
        puts "\e[32m Updating #{Repos[x].path}:\e[0m"
        next if !exist_path(x)
        Repos[x].update
      end
    end

    protected
    def pick(args,only_one=true)
      repos = Repos.keys.grep(/#{args}/)
        if only_one
          if repos.size == 1
            return repos
          elsif repos.empty?
            printf("\e[31mSorry,But No Result.\n\e[0m")
            return false
          else
            return choose_one(repos)
          end
        else
          return repos
        end
    end

    def choose_one(args)
      puts "\e[33mPlease Choose One of them : \e[0m"

      args.each_index do |x|
        printf "\e[32m%-2d\e[0m %-22s" % [x+1,args[x].rstrip]
        printf "\n" if (x+1)%3 == 0
      end
      printf "\n" if args.size%3 != 0

      num = choose_range(args.size)
      return num ? [args[num-1]] : false
    end

    def choose_range(size)
      printf "\e[33mPlease Input A Valid Number (1-#{size}) (q:quit): \e[0m"
      num = STDIN.gets
      return false if num =~ /q/i
      choosed_num = num.strip.empty? ? 1 : num.to_i
      (1..size).member?(choosed_num) ? (return choosed_num) : choose_range(size)
    end

    def exist_path(repos)
      if File.exist?(File.expand_path(Repos[repos].path))
        Dir.chdir(File.expand_path(Repos[repos].path))
      else
        puts "\n l.l,Have You init \e[33m#{repos}\e[0m Repository?\n\n"
        return false
      end
    end
  end
end
