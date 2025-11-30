def dirs_at(dir)
  Dir.chdir(dir)
  var = Dir["*"].reject{|o| !File.directory?(o) }
  Dir.chdir("..")
  return var
end

def fn(dir)
  Dir.chdir(dir)
  
  Dir["*"].reject{|o| !File.directory?(o) || o == "." || o == ".." }.each do |ndir|
    fn(ndir)
  end

  Dir.entries(".").select{ |f| !File.directory?(f) && f.end_with?(".tmp") }.each do |file|
    begin
      File.delete(file)
      puts("deleted temp file #{Dir.getwd}/#{file}")
    rescue => e
      puts("could not delete file #{Dir.getwd}/#{file}")
    end
  end

  Dir.chdir("..")
end

fn("..")

# BE VERY CAREFUL WITH THIS FILE
# IF WE CD BACK ONE TOO MANY TIMES, THE SCOPE MIGHT CHANGE TO THE ENTIRE DRIVE
