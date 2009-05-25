$LOAD_PATH.unshift("#{ENV['HOME']}/.eo/",File.join(File.dirname(__FILE__)))

class Repository
  attr_accessor :repo,:path,:_name_,:autorun,:skip,:pushable

  def initialize(opt={})

    ['repo','_name_','autorun','skip','pushable'].each do |x|
      eval "self.#{x} = opt.delete('#{x}')"
    end

    self.path = File.expand_path(opt['path']) if opt['path']

    begin
      scm = opt['scm'] || 'git'
      require "scm/#{scm.downcase}"
      extend eval "Scm::#{scm.capitalize.gsub(/-(\w)/) { $1.to_s.upcase}}"
    rescue LoadError
      puts <<-DOC.gsub(/^(\s*\|)/,'')
        |\e[33m#{self._name_}\e[0m
        |   \e[31mSorry,doesn't support < #{scm} > now.\e[0m
        |   \e[31mYou can define your Scm-Type in ~/.eo/scm.\e[0m
      DOC
      exit 0
    end

    if opt['cmd']                       # Define Your Methods
      opt['cmd'].each do |key,value|
        # Hack, Can't use defined_method to replace a extend method
        eval("def self.#{key}; #{value} ; end")
        (@defined_methods ||= [] ) << [key,value]
      end
    end
  end

  def help
    if @defined_methods
      puts "Your Defined Methods :"
      @defined_methods.each do |x|
        puts "  %-18s %s" % [x.first, x.last]
      end
      puts "\n"
    end

    puts <<-DOC.gsub(/^\s*\|/,'')
    |Usage :
    |  update             Update
    |  shell/sh           Goto shell
    |  help/h             Show this help message
    |  q                  Quit this shell
    |  Q                  Exit this program
    |  <Hash Method>      Run
    |  <Your Method>      Run.if undefined by above
    |  <Shell Command>    Run.if undefined by above
    |e.g:\n  \e[32m pwd \e[0m => The repository's path
    DOC
  end
  alias h help

  def shell
    system(Eo::Config['shell'])
  end
  alias sh shell

  def delete
    if readline("\e[33mAre Your Sure ? \e[0m") !~ /q|n/i
      if self.path && !self.path.empty?
        FileUtils.rm_rf(self.path)
      else
        puts "\e[31mDon't know how to delete the repository!\e[0m"
      end
    end
  end

  def method_missing(m,*args)
    # method missing -> shell command
    result = system(m.to_s + " " + args.join(' '))
    puts "\e[31mlol, Some Wrong?\e[0m" unless result
  end
end
