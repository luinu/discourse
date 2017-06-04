require 'open-uri'
# Below you can enter any name of catalog you would like to inspect
directory_name = "Blog"

# Show all files locations
Dir.glob(File.join(directory_name, "**", "*.*")).each do |file_name|
  puts file_name
end

# Count quantity of extension appearence
file_data = Dir.glob(File.join(directory_name, "**", "*.*")).inject({}) do |hash, file_name|
  ext = File.extname(file_name)
  hash[ext] ||= 0
  hash[ext] += 1
  hash
end

# Save to file
File.open("raport.txt", "w") do |file|
  file_data.each do |k, v|
    file.puts "#{k}\t#{v}"
  end
end

# Take ten most popular extensions and write them to file
rows = File.open("raport.txt") { |f| f.readlines }.map {|e|
  e.chomp.split("\t")
}.sort_by { |e| e.last.to_i }.reverse.take(10)
  puts rows.inspect

# Make a chart with google chart api and save it as png
values = rows.map { |e| e.last }.join(",")
labels = rows.map { |e| e.first }.join("|")
url = "https://chart.googleapis.com/chart?cht=p&chdl=#{labels}&chtt=File+types+in+app&chd=t:#{values}&chs=500x350&chl=#{labels}"
image_content = open(url).read
File.open("raport.png", "w") { |f| f.write(image_content) }
