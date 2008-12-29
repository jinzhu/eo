class Eo
  extend Gem
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
    def run
      loop do
        printf("\e[33mInput Commands (q:quit h:help): \e[0m")
        input = STDIN.gets.split(' ',2)
        input[1].strip!

        case input[0].to_s
        when /GS/i then gemshow(input[1])
        when /GC/i then gemchoose(input[1])
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

    def type
      ["#{ENV['HOME']}/.eo/scm/",File.join(File.dirname(__FILE__),'scm')].each do |x|
        next if !File.exist?(x)
        (@scm ||= []).concat(Dir.new(x).entries.reject {|i| i =~/^\.+$/})
      end

      puts "\e[33mAll Scm-type :\e[0m"
      @scm.uniq.map do |x|
        (@formated_scm ||= []) << File.basename(x,".rb")
      end
      format_display(@formated_scm)
    end

    def show(*args)
      repos = pick(args,false)
      puts "\e[33mAll Repo match < #{args} > :\e[0m"
      format_display(repos)
    end

    def open(args)
      repos = pick(args)
      system("vi #{Repos[repos.to_s].path}") if repos
    end

    def choose(*args)
      repos = pick(args)

      if repos && repos = repos.to_s    # Convert Array To String
        return false unless exist_path(repos)
        loop do
          printf("\e[01;34m#{repos} (h:help)>> \e[0m")
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
        if Repos[x].path && File.exist?(Repos[x].path)
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
        puts "\e[32m Updating #{Repos[x]._name_}:\e[0m"
        next if !exist_path(x)
        Repos[x].update
      end
    end

    protected
    #Pick one or more repositories to operate,if single is true only pick one
    def pick(args,single=true)
      repos = Repos.keys.grep(/#{args}/)
        if single
          if repos.size == 1
            return repos
          elsif repos.empty?
            printf("\e[31mNo Result About < #{args} >.\n\e[0m")
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

      format_display(args)

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
      if Repos[repos].path
        if File.exist?(Repos[repos].path)
          # Switch current path to the repository's path
          Dir.chdir(Repos[repos].path)
        else
          puts "\n l.l,Have You init \e[33m#{repos}\e[0m Repository?\n\n"
          return false
        end
      else
        return true
      end
    end

    def format_display(args)
      args.each_index do |x|
        printf "\e[32m%-2d\e[0m %-22s" % [x+1,args[x].rstrip]
        printf "\n" if (x+1)%3 == 0
      end
      puts "\n" if args.size%3 != 0
    end
  end
end
