require 'rails_helper'

RSpec.describe FileEntry, type: :model do
  describe 'associations' do
    it { should belong_to(:directory) }
  
    it 'permite criar um arquivo via ActiveStorage' do
      directory = Directory.create!(name: 'Teste Directório')
      file_entry = FileEntry.new(name: 'file.txt', directory: directory)

      file_entry.file.attach(
        io: StringIO.new('Conteúdo do arquivo'), 
        filename: 'file.txt', 
        content_type: 'text/plain'
      )

      expect(file_entry.file).to be_attached
    end
  end
end
