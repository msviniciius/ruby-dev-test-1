# GARANTIDNO LIMPEZA DOS DADOS EXISTENTES
puts "LIMPANDO DADOS EXISTENTES..."
FileEntry.destroy_all
Directory.destroy_all
puts "DADOS EXISTENTES APAGADOS..."


puts "SEED INICIADO!"
# CRIAR O DIRETÓRIO RAIZ
directory_root = Directory.create(name: 'Diretório Raiz')

# CRIAR SUBDIRETÓRIOS
directory_docs = Directory.create(name: 'Documentos', parent: directory_root)
directory_imgs = Directory.create(name: 'Imagens', parent: directory_root)
directory_projects = Directory.create(name: 'Projetos', parent: directory_docs)

# CRIA ARQUIVOS EM CONTEUDOS
arquivo_1 = FileEntry.create!(name: 'curriculo.txt', directory: directory_docs)
arquivo_2 = FileEntry.create!(name: 'imagem.png', directory: directory_imgs)
arquivo_3 = FileEntry.create!(name: 'anotacoes.md', directory: directory_projects)

# CRIA ARQUIVOS DE TEXTOS USANDO STRINGIO
arquivo_1.file.attach(
  io: StringIO.new("Curriculo para CLICKSIGN"),
  filename: 'curriculo.txt',
  content_type: 'text/plain'
)

arquivo_2.file.attach(
  io: StringIO.new("fakeimage"),
  filename: 'imagem.png',
  content_type: 'image/png'
)

arquivo_3.file.attach(
  io: StringIO.new("Anotações sobre o processo seletivo da CLICKSIGN"),
  filename: 'anotacoes.md',
  content_type: 'text/markdown'
)

puts "SEED FINALIZAD COM SUCESSO!"