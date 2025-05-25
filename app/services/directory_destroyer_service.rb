class DirectoryDestroyerService
  attr_reader :directory

  # realiza a exclusão condicional do diretório
  # caso tenha subdiretórios ou arquivos, exige confirmação explícita
  def initialize(directory)
    @directory = directory
  end

  # verifica se o diretório contém subdiretórios ou arquivos
  def confirmation?
    directory.subdirectories.any? || directory.file_entries.any?
  end

  # realiza a exclusão do diretório
  def destroy!
    directory.destroy
  end
end
