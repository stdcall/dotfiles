require 'rake'
require 'fileutils'
date = Time.now.strftime "%Y-%m-%d_%H-%M"
BAKDIR = File.join ENV["HOME"],"BAK-#{date}"
desc "install the dot files into user's home directory"
task :install do
  Dir.mkdir BAKDIR if !File.directory? BAKDIR
  init_home
  link_dir "." , ENV["HOME"]
end

def init_home
  begin
    Dir.mkdir File.join(ENV["HOME"],"bin")
    Dir.mkdir File.join(ENV["HOME"],".vim")
    Dir.mkdir File.join(ENV["HOME"],".vim/bundle")
  rescue
  end
end
def link_dir(from,to)
  Dir.chdir from
  Dir.glob("*",File::FNM_DOTMATCH).each do |file|
    next if %w[. .. Rakefile README.md .git .gitignore].include? file
    if File.exist?(File.join(to, file)) 
      if File.directory?  File.join(to, file) and not(File.symlink?(File.join(to, file)))
        backup = to.sub(/#{ENV["HOME"]}/,'')
        puts "backup: #{ File.join(BAKDIR,backup,file)}"
        Dir.mkdir File.join(BAKDIR,backup,file)
        copy_to = File.join to, file
        link_dir(file,copy_to) 
      else
        if File.symlink?(File.join(to, file))
          File.unlink(File.join(to, file)) 
        else
          FileUtils.mv(File.join(to, file), File.join(BAKDIR, backup), force: true) 
        end
        link_file(file,to)
      end
    else
      link_file(file, to)
    end
  end
  Dir.chdir ".."
end

def link_file(file, to)
  File.symlink(File.expand_path(file), File.join(to, file))  
end
