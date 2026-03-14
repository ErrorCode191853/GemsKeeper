require 'fileutils'

class GemsKeeper
  # Define 'boxes' for files
  # A Hash (similar to Dictionary) to store rules and quick lookup.
  RULES = {
    '.txt'  => 'Documents',
    '.rb'   => 'Scripts',
    '.jpg'  => 'Images',
    '.png'  => 'Images',
    '.pdf'  => 'Books'
  }

  def initialize(path)
    @path = path
  end

  def organize
    puts "--- GemsKeeper is sorting... ---"

    files = Dir.children(@path)

    files.each do |file_name|
      # Acquiring the full path of files
      full_path = File.join(@path, file_name)

      # Ignore it if it is a directory or the main file of the project.
      next if File.directory?(full_path) || file_name == 'keeper.rb'

      extension = File.extname(file_name).downcase

      # Check the extension of the file. If it is not in the rules, it will be ignored.
      folder_name = RULES[extension] || 'Others'

      # Create folders if not exist
      dest_folder = File.join(@path, folder_name)
      FileUtils.mkdir_p(dest_folder)

      # Move files to boxes
      FileUtils.mv(full_path, File.join(dest_folder, file_name))
      puts "✨ moved [#{file_name}] to [#{folder_name}]"
    end

    puts "--- finished! Directory is 'cleaned'. ---"
  end

  private
  def unique_path(folder, name)
    base_name = File.basename(name, ".*")
    extension = File.extname(name)
    target_path = File.join(folder, name)
    counter = 1

    # While the file exists, keep incrementing the counter
    while File.exist?(target_path)
      target_path = File.join(folder, "#{base_name}_#{counter}#{extension}")
      counter += 1
    end

    target_path
  end
end

# Carries out the task.
keeper = GemsKeeper.new(".")
keeper.organize