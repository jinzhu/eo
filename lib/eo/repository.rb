$LOAD_PATH << File.join(File.dirname(__FILE__),'scm')
#FIXME only load scm ~/.eoscm

class Repository < Hash

  def initialize(opt={})
    begin
      require opt[:scm] ? opt[:scm] : 'git'
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
    super
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
    m = m.to_s
    methods = self['cmd'] ? self['cmd'].keys.grep(m) : []

    if methods.size == 1
      eval self['cmd'][m]
    else
      result = system(m + " " + args.join(' '))
      puts "\e[31mlol, Some Wrong?\e[0m" unless result
    end
  end
end
