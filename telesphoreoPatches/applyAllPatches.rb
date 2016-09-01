require 'pp'

patchesDirectory = File.expand_path(File.dirname(__FILE__))
repoDirectory = File.expand_path(File.join(patchesDirectory, "/.."))
Dir.chdir(patchesDirectory)

allFiles = Dir.glob(File.join(patchesDirectory, "*.diff"))

allFiles.each do |file|
  # run patch with patch's root directory removed
  # skip applying if already applied
  # from the repo directory
  output = `patch -p1 -N -i #{file} -d #{repoDirectory}`
  puts output
end
