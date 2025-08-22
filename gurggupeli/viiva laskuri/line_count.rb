$lines = 0
$loc = 0
$chars = 0
$filec = 0
$scenes = 0
$pngs = 0

root_dir = Dir.pwd

def process(file)
  $lines += file.count("\n")
  $loc += file.count("\n")
  $chars += file.length
  $filec += 1

  file.split("\n").each do |row|
    if row.length == 0 || row.chomp[0] == "#"
      $loc -= 1
    end
  end
end

def dirs_at(dir)
  Dir.chdir(dir)
  var = Dir["*"].reject{|o| !File.directory?(o) }
  Dir.chdir("..")
  return var
end

def fn(dir)
  Dir.chdir(dir)

  Dir["*"].reject{|o| !File.directory?(o) || o == "." || o == ".." || o == "addons" }.each do |ndir|
    fn(ndir)
  end

  Dir.entries(".").select{ |f| !File.directory?(f) && (f.end_with?(".gd") || f.end_with?(".tscn") || f.end_with?(".png")) }.each do |file|
    begin
      if file.end_with?(".gd")
        process File.read(file)
      elsif file.end_with?(".tscn")
        $scenes += 1
      elsif file.end_with?(".png")
        $pngs += 1
      end
    rescue => e
      puts("error: #{e.to_s}")
    end
  end

  Dir.chdir("..")
end

fn("..")

puts("lines: #{$lines}\nloc: #{$loc}\ncode files: #{$filec}\ncode chars: #{$chars}\nscenes: #{$scenes}\ntextures: #{$pngs}\n")
Dir.chdir(root_dir)
File.open("loc_history.txt", "a") do |file|
  file.write("#{Time.now.to_s}:\n  lines: #{$lines}\n  loc: #{$loc}\n  code files: #{$filec}\n  code chars: #{$chars}\n  scenes: #{$scenes}\n  textures: #{$pngs}\n")
end
