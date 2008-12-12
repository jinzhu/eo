require 'eo/scm'
class Eo

  Repo = Hash.new
  YAML.load_file(File.join(ENV['HOME'],".eorc")).each_pair do |keys,value|
    Repo[keys] = Scm.new.merge(value)
  end

  def self.run
    input = STDIN.gets.split(' ',2)
    input[1].strip!
    case input[0].to_s
    when /-s/ then show(input[1])
    when /-c/ then choose(input[1])
    when /-u/ then update(input[1])
    end
  end

  def self.show(*args)
    repos = pick(args,false)
    repos.each do |x|
      puts x
    end
  end

  def self.choose(*args)

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
    args.each_index do |x|
      printf "%2s" % (x+1).to_s
      printf "%-15s\t" % [args[x].rstrip]
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
