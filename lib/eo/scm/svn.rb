module Scm
  def init
    system("svn co #{self['repo']} #{self['path']}")
  end

  def update
    old_commit = now_commit
    system("svn update")
    new_commit = now_commit
    if new_commit != old_commit && self['autorun']
      self['autorun'].split(';').each do |x|
        eval x
      end
    end
  end

  protected

  def now_commit
    `svn -l 1 log -q | grep "\w" | awk '{print $1}'`
  end
end
