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
    gem = gem && gem[0]
    # Got The Gem's Path
    gem ? `gem content #{gem} #{RUBY_VERSION > "1.9" ? '' : '--prefix'} | sed -n 1p`.match(/(.*?#{gem}-\d.*?\/)/).to_s : false
  end

  def scangem(args)
    puts "\e[33mAll Gems match < #{args} > :\e[0m"

    result = []
    `gem list | grep -iP '#{args}'`.scan(/^(\w.*?)\s/) do
      result << $1
    end

    if !result.empty?
      return result
    else
      puts "\e[31mNo Result About < #{args} >\e[0m"
      return false
    end
  end
end
