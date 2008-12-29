module Gem
  def gemshow(args)
    puts "\e[33mAll Gems match < #{args} > :\e[0m"
    format_display(scangem(args))
  end

  def gemopen(args)
    gem = choose_one(scangem(args))
    if gem
      filepath = `gem content #{gem} | sed -n 1p`
      system("vi #{filepath.match(/(.*?\w-\d.*?\/)/).to_s}")
    end
  end

  def gemchoose(args)
    gem = choose_one(scangem(args))
    if gem
      filepath = `gem content #{gem} | sed -n 1p`
      Dir.chdir(filepath.match(/(.*?\w-\d.*?\/)/).to_s)
      system('sh')
    end
  end

  def scangem(args)
    result = []
    gemlist = `gem list | grep '#{args}'`
    gemlist.scan(/^(\w.*?)\s/) do
      result << $1
    end
    return result
  end
end
