#$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),'scm'))
#FIXME only load scm ~/.eo/scm
#TODO add macro

class Repository < Hash
  attr_accessor :repo,:path,:_name_

  def initialize(opt={})
    begin
      #require opt[:scm] ? opt[:scm] : 'git'
      require File.join(File.dirname(__FILE__),'scm','git')
      #FIXME find file,first ~/.eo/scm then above
      extend Scm
      #TODO Switch method_missing to define scm methods
    rescue LoadError
      puts <<-DOC.gsub(/^(\s*\|)/,'')
        |\e[33m#{opt[:name]}\e[0m
        |   \e[31mSorry,doesn't support < #{opt[:scm]} > now.\e[0m
        DOC
        #TODO -t for all support type
      exit 0
    end

    ['repo','path','_name_'].each do |x|
      eval "self.#{x} = opt.delete('#{x}')"
    end

    if opt['cmd']                   # Define Your Methods
      opt['cmd'].each do |key,value|
        self.class.send(:define_method, key, lambda { eval(value) } )
      end
    end
  end

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

  def shell
    system("sh")
  end
  alias sh shell

  def method_missing(m,*args)
    # method missing -> shell command
    result = system(m + " " + args.join(' '))
    puts "\e[31mlol, Some Wrong?\e[0m" unless result
  end
end
