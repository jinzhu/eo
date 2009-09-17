module Gem
  def gemshow(args)
    gems = scangem(args)
    format_display(gems) if gems
  end

  def gemopen(args)
    path = gempick(args)
    system([Eo::Config['open'],path].join(' ')) if path
  end

  def gemshell(args)
    path = gempick(args)
    system("cd #{path} && #{Eo::Config['shell']}") if path
  end

  protected
  def gempick(args)
    gem = choose_one( scangem(args) )
    # Got The Gem's Path
    gem ? `gem content #{gem} | sed -n 1p`.match(/(.*?\w-\d.*?\/)/):false
  end

  def scangem(args)
    puts "\e[33mAll Gems match < #{args} > :\e[0m"

    result = []
    `gem list | grep -iP '#{args}'`.scan(/^(\w.*?)\s/) do
      result << $1
    end

    return !result.empty? ? result : (puts("\e[31mNo Result About < #{args} >\e[0m");false)
  end
end
