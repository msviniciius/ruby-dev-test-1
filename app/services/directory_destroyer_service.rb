class DirectoryDestroyerService
  attr_reader :directory

  def initialize(directory)
    @directory = directory
  end

  def confirmation?
    directory.subdirectories.any? || directory.file_entries.any?
  end

  def destroy!
    directory.destroy
  end
end
