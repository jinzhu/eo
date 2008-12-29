module Gem
  def gemshow(args)
    puts "\e[33mAll Gems match < #{args} > :\e[0m"
    format_display(scangem(args))
  end

  def gemopen(args)
    path = gempick(args)
    system("vi #{path}") if path
  end

  def gemshell(args)
    path = gempick(args)
    system("cd #{path} && sh") if path
  end

  protected

  def scangem(args)
    result = []
    gemlist = `gem list | grep '#{args}'`
    gemlist.scan(/^(\w.*?)\s/) do
      result << $1
    end
    return result
  end

  def gempick(args)
    gems = scangem(args)
    if gems.size > 0
      gem = choose_one(gems)
      gem ? `gem content #{gem} | sed -n 1p`.match(/(.*?\w-\d.*?\/)/) : false
    else
      return false
    end
  end
end
