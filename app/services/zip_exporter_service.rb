require "zip"

class ZipExporterService
  def initialize(directory)
    @directory = directory
  end

  def generate_zip
    buffer = Zip::OutputStream.write_buffer do |zip|
      add_directory_to_zip(@directory, zip)
    end

    buffer.rewind
    buffer
  end

  private

  def add_directory_to_zip(directory, zipfile, path_prefix = "")
    current_path = path_prefix.present? ? "#{path_prefix}/#{directory.name}" : directory.name

    # adiciona os arquivos deste diretório
    directory.file_entries.each do |file_entry|
      next unless file_entry.file.attached?

      file_path_in_zip = "#{current_path}/#{file_entry.name}"
      zipfile.put_next_entry(file_path_in_zip)
      zipfile.write file_entry.file.download
    end

    # de forma recursiva é adicionado os subdiretórios
    directory.subdirectories.each do |sub|
      add_directory_to_zip(sub, zipfile, current_path)
    end
  end
end
