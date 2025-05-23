module DirectoriesHelper
  def render_directory_tree(directory)
    content_tag(:li) do
      concat(content_tag(:strong, directory.name))
      if directory.file_entries.any?
        concat(content_tag(:ul) do
          directory.file_entries.each do |file|
            concat content_tag(:li, file.name)
          end
        end)
      end
      if directory.subdirectories.any?
        concat(content_tag(:ul) do
          directory.subdirectories.each do |sub|
            concat render_directory_tree(sub)
          end
        end)
      end
    end
  end
end
