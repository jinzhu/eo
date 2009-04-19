module Scm
  module GitSvn
    def init
      system("git svn clone #{self.repo} #{self.path}")
    end

    def update
      old_commit = now_commit
      system("git svn rebase")
      new_commit = now_commit
      if new_commit != old_commit && self.autorun
        self.autorun.split(';').each do |x|
          eval x
        end
      end
    end

    def push
      system("git svn dcommit")
    end

    def now_commit
      return `git log --pretty=format:%H -1`
    end
  end
end
