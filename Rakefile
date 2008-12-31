require 'rubygems'
require 'rake'
require 'echoe'
require File.dirname(__FILE__) + '/lib/version'

Echoe.new('easyoperate', Easyoperate::VERSION) do |p|
  p.description     = "Eo_oE"
  p.url             = "http://www.zhangjinzhu.com"
  p.author          = "Jinzhu Zhang"
  p.email           = "wosmvp@gmail.com"
  p.ignore_pattern  = ["TODO"]
  p.rubyforge_name  = "easyoperate"

#FIXME############################## 
  p.install_message = "\e[31m

 Attention Please ( <= v0.3.0 ):
   ~/.eorc renamed to ~/.eo/repos
   Add new config file ~/.eo/config

 #{require 'fileutils'
 FileUtils.mkdir_p(File.join("#{ENV['HOME']}",".eo"))

 origin = File.join("#{ENV['HOME']}",".eorc")
 repos = File.join("#{ENV['HOME']}",".eo/repos")
 config = File.join("#{ENV['HOME']}",".eo/config")

 if File.exist?(origin) && !File.exist?(repos)
   FileUtils.cp(origin,repos)
 end

 if !File.exist?(config)
   example = File.join(File.dirname(__FILE__),'example/config')
   FileUtils.cp(example,config)
 end
 }
                  \e[0m"
########################################
end
