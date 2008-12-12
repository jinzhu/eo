class Scm < Hash

  def update
    Dir.chdir(File.expand_path(self['path']))
    puts "\e[31m" + self['path'] + "\e[0m"

    old_commit = now_commit
    scm_update
    new_commit = now_commit
    if new_commit == old_commit
      puts "NO Update"
    else
      eval self['autorun'] if self['autorun']
    end
  end

  def scm
    Dir.chdir(File.expand_path(self['path']))
    return 'git' if !Dir.entries('.').grep(".git").empty?
    return 'svn' if !Dir.entries('.').grep(".svn").empty?
  end

  def scm_update
    Dir.chdir(File.expand_path(self['path']))
    case scm
    when /git/ if system("git pull")
    when /svn/ if system("svn update")
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
      puts "Some Wrong?" unless result
    end
  end
end
