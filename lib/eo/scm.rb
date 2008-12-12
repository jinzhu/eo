class Scm < Hash

  def help
    if self['cmd'] && cmd = self['cmd'].keys
      printf("\e[33mYour Defined Methods\e[0m :\n")
      cmd.each_index do |x|
        puts "\e[32m%-18s:\e[0m %s" % [cmd[x].rstrip,self['cmd'][cmd[x]]]
      end
    end

    puts "\e[33mUsage: \e[0m"
    puts "\e[32m%-18s: \e[0m%s." % ["update","Update All Repositories"]
    puts "\e[32m%-18s: \e[0m%s." % ["shell/sh","Goto the Repository's shell"]
    puts "\e[32m%-18s: \e[0m%s." % ["help/h","Show this help message"]
    puts "\e[32m%-18s: \e[0m%s." % ["q","quit this shell"]
    puts "\e[32m%-18s: \e[0m%s." % ["Q","exit this program"]
    puts "\e[32m%-18s: \e[0m%s." % ["<Hash Methods>","Run"]
    puts "\e[32m%-18s: \e[0m%s." % ["<Your Methods>","Run.if undefined by above"]
    puts "\e[32m%-18s: \e[0m%s." % ["<Shell Commands>","Run.if undefined by above"]

  end
  alias h help

  def update
    Dir.chdir(File.expand_path(self['path']))
    puts "\e[31m" + self['path'] + "\e[0m"

    old_commit = now_commit
    scm_update
    new_commit = now_commit
    if new_commit == old_commit
      puts "NO Update"
    else
      if self['autorun']
        self['autorun'].split(';').each do |x|
          eval x
        end
      end
    end
  end

  def shell
    Dir.chdir(File.expand_path(self['path']))
    system("sh")
  end
  alias sh shell

  def method_missing(m,*args)
    Dir.chdir(File.expand_path(self['path']))
    m = m.to_s
    methods = self['cmd'] ? self['cmd'].keys.grep(m) : []

    if methods.size == 1
      eval self['cmd'][m]
    else
      result = system(m + " " + args.join(' '))
      puts "\e[31mlol, Some Wrong?\e[0m" unless result
    end
  end

  protected
  def scm
    return 'git' if !Dir.entries('.').grep(".git").empty?
    return 'svn' if !Dir.entries('.').grep(".svn").empty?
  end

  def scm_update
    case scm
    when /git/ then system("git pull")
    when /svn/ then system("svn update")
    end
  end

  def now_commit
   case scm
   when /git/ then return `git log --pretty=format:%H -1`
   when /svn/ then return `svn -l 1 log -q | grep "\w" | awk '{print $1}'`
   else
     puts "\e[31mSorry,RightNow Only Support SVN/GIT\e[0m"
     return false
   end
  end
end
