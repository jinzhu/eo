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
  def gempick(args)
    gems = scangem(args)
    if gems.size > 0
      gem = choose_one(gems)
      if gem
	puts "\e[34m#{gem}\e[0m"
	# Got The Gem's Path
	return `gem content #{gem} | sed -n 1p`.match(/(.*?\w-\d.*?\/)/)
      end
    end
    return false
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
