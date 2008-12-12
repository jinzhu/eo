class Scm < Hash

  def update
    Dir.chdir(File.expand_path(self['path']))
    puts "\e[31m" + self['path'] + "\e[0m"

    old_commit = `git log --pretty=format:%H -1` #TODO SVN
    system("git pull")
    new_commit = `git log --pretty=format:%H -1`
    if new_commit == old_commit
      puts "NO Update"
    else
      eval self['autorun'] if self['autorun']
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
