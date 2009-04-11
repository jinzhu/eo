class Eo
  extend Gem

  class << self
    def type
      puts "\e[33mAll Scm-type :\e[0m"

      ["#{ENV['HOME']}/.eo/scm/",File.dirname(__FILE__) + '/scm' ].each do |x|
        next if !File.exist?(x)
        (@scm ||= []).concat(Dir.new(x).entries.reject {|i| i =~/^\.+$/})
      end

      @scm.uniq.map do |x|
        (@formated_scm ||= []) << File.basename(x,".rb")
      end
      format_display(@formated_scm)
    end

    def show(args,opt={})
      puts "\e[33mAll Repo match < #{args} > :\e[0m"
      repos = pick(:key => args,:plural => true,:skip => opt[:skip])
      format_display(repos) if repos
    end

    def open(args)
      repos = pick(:key => args)
      system([Config['open'],Repos[repos.first].path].join(' ')) if repos
    end

    def choose(args)
      repos = pick(:key => args)

      if repos && repos = repos.first    # Get First Array
        return false unless exist_path(repos)
        loop do
          input = (readline("\e[01;34m#{repos} (h:help)>> \e[0m",true) || exit).rstrip

          break if input =~ /\A\s*q\s*\Z/
          exit if input =~ /\A\s*Q\s*\Z/
          Repos[repos].send(input) unless input.empty?
        end
      end
    end

    def init(args,opt={})
      repos = pick(:key => args,:plural => true,:skip => opt[:skip])

      repos.each do |x|
        if Repos[x].path && File.exist?(Repos[x].path)
          puts "\e[32m %-18s: already Initialized\e[0m" % [x]
        else
          puts "\e[32m %-18s: Initializing\e[0m" % [x]
          Repos[x].init
        end
      end
    end

    def push(args)
      repos = pick(:key => args,:plural => true,:pushable => true)
      repos.each do |x|
        puts "\e[32m %-18s: Pushing\e[0m" % [x]
        Dir.chdir(Repos[x].path) if Repos[x].path
        Repos[x].push if Repos[x].respond_to?(:push)
      end
    end

    def delete(args,opt={})
      repos = pick(:key => args,:plural => true)

      repos.each do |x|
        puts "\e[32m Deleting #{Repos[x]._name_}:\e[0m"
        Repos[x].delete
      end
    end

    def update(args,opt={})
      repos = pick(:key => args,:plural => true,:skip => opt[:skip])

      repos.each do |x|
        puts "\e[32m Updating #{Repos[x]._name_}:\e[0m"
        next if !exist_path(x)
        Repos[x].update
      end
    end

    protected
    #Pick one or more repositories to operate,if single is true only pick one
    def pick(opt={}) #args,single=true
      repos = Repos.keys.grep(/#{opt[:key]}/)

      if repos.empty?
        puts("\e[31mNo Result About < #{opt[:key]} >\e[0m")
        return false
      end

      repos = repos.select {|x| !Repos[x].skip}    if opt[:skip]
      repos = repos.select {|x| Repos[x].pushable} if opt[:pushable]

      return opt[:plural] ? repos : choose_one(repos)
    end

    def choose_one(args)
      return false unless args

      puts "\e[33mPlease Choose One of them : \e[0m"
      format_display(args)

      args.size > 1 ? (num = choose_range(args.size)) : (return args)
      return num ? [args[num-1]] : false
    end

    def choose_range(size)
      num = (readline("\e[33mPlease Input A Valid Number (1-#{size}) (q:quit): \e[0m",true) || exit)
      return false if num =~ /q/i
      num = num.strip.empty? ? 1 : num.to_i
      return (1..size).member?(num) ? num : choose_range(size)
    end

    # If have path method
    # and the directory exist,switch current path to the repository's path
    # if doesn't exist then return false
    # if doesn't have path method return true
    def exist_path(repos)
      if Repos[repos].path
        if File.exist?(Repos[repos].path)
          Dir.chdir(Repos[repos].path)
        else
          puts "\n l.l,Have You init \e[33m#{repos}\e[0m Repository?\n\n"
          return false
        end
      end
      return true
    end

    def format_display(args)
      args.each_index do |x|
        # truncate
        str = args[x].rstrip
        str = str.size > 23 ? str[0,21] + '..' : str
        printf "\e[32m%-3d\e[0m%-23s" % [x+1,str]
        printf "\n" if (x+1)%3 == 0
      end
      puts "\n" if args.size%3 != 0
    end
  end
end
