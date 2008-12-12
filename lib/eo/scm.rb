class Scm < Hash

  def update
    #FIXME DIR.pwd()
    old_commit = `git log --pretty=format:%H -1` #TODO SVN
    system("git pull")
    new_commit = `git log --pretty=format:%H -1`
    if new_commit == old_commit
      "NO Update" #TODO
    else
      eval self['autorun'] if self['autorun'] #FIXME
      "Update Log" #TODO
    else
    end
  end

  def shell
   "GOTO The Shell"
   #TODO source ~/.bashrc
  end

  alias sh shell

  def method_missing(m,*args)
    m = m.to_s
    methods = self['cmd'].keys.grep(m)

    if methods.size == 1
      eval self['cmd'][m]
      #TODO shell git/svn commands
    else
        puts "No Methods"
    end
  end
end
