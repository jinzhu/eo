class Scm < Hash

  def update
    Dir.chdir(File.expand_path(self['path']))
    puts self['path']

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
    system("sh") #TODO source ~/.bashrc
  end

  alias sh shell

  def method_missing(m,*args)
    m = m.to_s
    methods = self['cmd'].keys.grep(m)

    if methods.size == 1
      eval self['cmd'][m]    #TODO shell git/svn commands
    else
      puts "No Methods"
    end
  end
end
