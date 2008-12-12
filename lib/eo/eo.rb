require 'eo/scm'
class Eo
  Repo = Hash.new
  YAML.load_file(File.join(ENV['HOME'],".eorc")).each_pair do |keys,value|
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
        when /Q/i then exit(0)
        else help
        end
      end
    end

    def help
      #TODO Add
    end

    def show(*args)
      repos = pick(args,false)
      repos.each_index do |x|
        printf "\e[32m%-2d\e[0m %-15s\t" % [x+1,repos[x].rstrip]
        printf("\n") if (x+1)%4==0
      end
      printf "\n" if (repos.size + 1)%4 != 0
    end

    def choose(*args)
      repos = pick(args)
      if repos
        loop do
          printf("\e[01;34m#{repos.first} $ \e[0m")
          input = STDIN.gets.strip
          break if input =~ /\A\s*q\s*\Z/
          exit if input =~ /\A\s*Q\s*\Z/
          Repo[repos.first].send(input)
        end
      end
    end

    def update(*args)
      repos = pick(args,false)
      repos.each do |x|
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
      puts "\e[32mPlease Choose One of them :\e[0m"
      args.each_index do |x|
        printf "%-3s" % (x+1).to_s
        printf "\e[33m%-15s\e[0m\t" % [args[x].rstrip]
        printf "\n" if (x+1)%4 == 0
      end
      num = choose_range(args.size)
      return num ? [args[num-1]] : false
    end

    def choose_range(size)
      num = STDIN.gets
      return false if num =~ /q/i
      choosed_num = num.strip.empty? ? 1 : num.to_i
      (1..size).member?(choosed_num) ? (return choosed_num) : choose_range(size)
    end
  end
end
