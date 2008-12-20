module Scm
  def init
    system("git clone #{self['repo']} #{self['path']}")
  end

  def update
    old_commit = now_commit
    system("git pull")
    new_commit = now_commit
    if new_commit != old_commit && self['autorun']
      self['autorun'].split(';').each do |x|
        eval x
      end
    end
  end

  def now_commit
    return `git log --pretty=format:%H -1`
  end
end
