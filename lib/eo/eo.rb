require 'eo/scm'
class Eo

  Repo = Hash.new
  YAML.load_file(File.join(ENV['HOME'],".eorc")).each_pair do |keys,value|
    Repo[keys] = Scm.new.merge(value)
  end

  def self.run
    loop do
      printf("\e[33mInput Commands (q to quit| h for help) :\e[0m")
      input = STDIN.gets.split(' ',2)
      input[1].strip!
      case input[0].to_s
      when /S/i then show(input[1])
      when /C/i then choose(input[1])
      when /U/i then update(input[1])
      when /Q/i then exit(0)
        #FIXME Help
      end
    end
  end

  def self.show(*args)
    repos = pick(args,false)
    repos.each do |x|
      puts x
    end
  end

  def self.choose(*args)
    repos = pick(args)
    loop do
      printf("\e[01;34m#{repos.first} $ \e[0m")
      input = STDIN.gets.strip
      break if input =~ /q/i
      Repo[repos.first].send(input)
    end
  end

  def self.update(*args)
    repos = pick(args,false)
    repos.each do |x|
      Repo[x].update
    end
  end

  protected
  def self.pick(args,only_one=true)
    repos = Repo.keys.grep(/#{args}/)
    if only_one
      return repos if repos.size == 1
      return choose_one(repos)
    else
      return repos
    end
  end

  def self.choose_one(args)
    puts "\e[32mPlease Choose One of them :\e[0m"
    args.each_index do |x|
      printf "%-3s" % (x+1).to_s
      printf "\e[33m%-15s\e[0m\t" % [args[x].rstrip]
      printf "\n" if (x+1)%4 == 0
    end
    num = choose_range(args.size)
    return num ? [args[num-1]] : false
  end

  def self.choose_range(size)
    num = STDIN.gets
    return false if num =~ /q/i
    choosed_num = num.strip.empty? ? 1 : num.to_i
    (1..size).member?(choosed_num) ? (return choosed_num) : choose_range(size)
  end
end
