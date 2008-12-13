require 'eo/scm'
class Eo
  Repo = Hash.new

  Config_file = File.join("#{ENV['HOME']}",".eorc")

  unless File.exist?(Config_file)
    puts " \e[31m;( No config file\e[0m \n\nexample file:"
    puts File.read(File.join(File.dirname(__FILE__),'../../example/eorc'))
    exit
  end

  YAML.load_file(Config_file).each_pair do |keys,value|
    Repo[keys] = Scm.new.merge(value)
  end

  class << self
    def run
      loop do
        printf("\e[33mInput Commands (q to quit| h for help) : \e[0m")
        input = STDIN.gets.split(' ',2)
        input[1].strip!
        case input[0].to_s
        when /S/i then show(input[1])
        when /C/i then choose(input[1])
        when /U/i then update(input[1])
        when /I/i then init(input[1])
        when /Q/i then exit(0)
        else help
        end
      end
    end

    def help
      puts "Usage:"
      puts "  S /args/ : Show matched repositories <Regexp>"
      puts "  C /args/ : Choose Some Repository <Regexp>"
      puts "  U /args/ : Update matched Repository <Regexp>"
      puts "  I /args/ : Initialize matched Repository <Regexp>"
      puts "  Q        : Quit"
      puts "  H        : Show this help message."
      puts "e.g:\n  \e[32m s v.*m\e[0m"
    end

    def show(*args)
      repos = pick(args,false)
      puts "\e[33mAll Repo match < #{args} > :\e[0m"
      repos.each_index do |x|
        printf "\e[32m %-15s\t\e[0m" % [repos[x].rstrip]
        printf("\n") if (x+1)%4==0
      end
      puts "\n" if repos.size%4 != 0
    end

    def choose(*args)
      repos = pick(args)
      if repos && repos = repos.to_s
        return false unless exist_path(repos)
        loop do
          printf("\e[01;34m#{repos.first} $ \e[0m")
          input = STDIN.gets.strip
          break if input =~ /\A\s*q\s*\Z/
          exit if input =~ /\A\s*Q\s*\Z/
          Repo[repos].send(input) unless input.empty?
        end
      end
    end

    def init(*args)
      repos = pick(args,false)
      repos.each do |x|
        if File.exist?(File.expand_path(Repo[x]['path']))
          puts "\e[32m %-18s: already Initialized\e[0m" % [x]
          next
        end
        puts "\e[32m %-18s: Initializing\e[0m" % [x]
        Repo[x].init
      end
    end

    def update(*args)
      repos = pick(args,false)
      repos.each do |x|
        puts "\e[32mUpdating #{Repo[x]['path']} :\e[0m"
        next if !exist_path(x)
        Repo[x].update
      end
    end

    protected
    def pick(args,only_one=true)
      repos = Repo.keys.grep(/#{args}/)
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
        printf "\e[32m%-2d\e[0m %-15s\t" % [x+1,args[x].rstrip]
        printf "\n" if (x+1)%4 == 0
      end
      printf "\n" if args.size%4 != 0

      num = choose_range(args.size)
      return num ? [args[num-1]] : false
    end

    def choose_range(size)
      printf "\e[33mPlease Input A Valid Number (1..#{size}) (q to quit): \e[0m"
      num = STDIN.gets
      return false if num =~ /q/i
      choosed_num = num.strip.empty? ? 1 : num.to_i
      (1..size).member?(choosed_num) ? (return choosed_num) : choose_range(size)
    end

    def exist_path(repos)
      if File.exist?(File.expand_path(Repo[repos]['path']))
        Dir.chdir(File.expand_path(Repo[repos]['path']))
      else
        puts "\n l.l,Have You init \e[33m#{repos}\e[0m Repository?\n\n"
        return false
      end
    end

  end
end
