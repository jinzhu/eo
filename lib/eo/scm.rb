class Scm < Hash

  def help
    if self['cmd'] && cmd = self['cmd'].keys
      printf("Your Defined Methods :\n")
      cmd.each_index do |x|
        puts "  %-18s: %s" % [cmd[x].rstrip,self['cmd'][cmd[x]]]
      end
      puts
    end

    puts "Usage: "
    puts "  %-18s: %s." % ["update","Update"]
    puts "  %-18s: %s." % ["shell/sh","Goto shell"]
    puts "  %-18s: %s." % ["help/h","Show this help message"]
    puts "  %-18s: %s." % ["q","Quit this shell"]
    puts "  %-18s: %s." % ["Q","Exit this program"]
    puts "  %-18s: %s." % ["<Hash Method>","Run"]
    puts "  %-18s: %s." % ["<Your Method>","Run.if undefined by above"]
    puts "  %-18s: %s." % ["<Shell Command>","Run.if undefined by above"]
    puts "e.g:\n  \e[32m pwd \e[0m => The repository's path"

  end
  alias h help

  def update
    old_commit = now_commit
    scm_update
    new_commit = now_commit
    if new_commit != old_commit && self['autorun']
      self['autorun'].split(';').each do |x|
        eval x
      end
    end
  end

  def shell
    system("sh")
  end
  alias sh shell

  def init
    command = case self['scm']
    when /svn/ then 'svn co'
    when /git/ then 'git clone'
    when nil   then 'git clone'
    end
    if command
      system("#{command} #{self['repo']} #{self['path']}")
    else
      puts "\e[31mSorry,Maybe doesn't support #{self['scm']} rightnow.\e[0m"
    end
  end

  def method_missing(m,*args)
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
     puts "\e[31mSorry,Only Support SVN/GIT\e[0m"
     exit
   end
  end
end
