$LOAD_PATH.unshift("#{ENV['HOME']}/.eo/scm/",File.join(File.dirname(__FILE__),'scm'))

class Repository
  attr_accessor :repo,:path,:_name_,:autorun

  def initialize(opt={})

    ['repo','path','_name_','autorun'].each do |x|
      eval "self.#{x} = opt.delete('#{x}')"
    end

    begin
      scm = opt['scm'] || 'git'
      require scm
      extend eval "Scm::#{scm.capitalize}"
    rescue LoadError
      puts <<-DOC.gsub(/^(\s*\|)/,'')
        |\e[33m#{opt[:_name_]}\e[0m
        |   \e[31mSorry,doesn't support < #{scm} > now.\e[0m
        |   \e[31mYou can define your Scm-Type in ~/.eo/scm.\e[0m
        DOC
      exit 0
    end

    if opt['cmd']                   # Define Your Methods
      opt['cmd'].each do |key,value|
        self.class.send(:define_method, key, lambda { eval(value) } )
        (@defined_methods ||= [] ) << [key,value]
      end
    end
  end

  def help
    if @defined_methods
      printf("Your Defined Methods :\n")
      @defined_methods.each do |x|
        puts "  %-18s: %s" % [x.first, x.last]
      end
    end

    puts <<-DOC.gsub(/^\s*\|/,'')
    |Usage:
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
    system("sh")
  end
  alias sh shell

  def method_missing(m,*args)
    # method missing -> shell command
    result = system(m + " " + args.join(' '))
    puts "\e[31mlol, Some Wrong?\e[0m" unless result
  end
end
