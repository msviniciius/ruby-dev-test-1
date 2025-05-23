require 'rails_helper'

RSpec.describe Directory, type: :model do
  describe 'associations' do
    it { should belong_to(:parent).class_name('Directory').optional }
    it { should have_many(:subdirectories).class_name('Directory').with_foreign_key('parent_id').dependent(:destroy) }
    it { should have_many(:file_entries).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'nested directories' do
    it 'permitir criar subdiretórios em cadeia' do
      directory_root = Directory.create(name: 'Diretório Root')
      clild = Directory.create(name: 'Diretório Filho', parent: directory_root)
      grandchild = Directory.create(name: 'Diretório Neto', parent: clild)

      expect(directory_root.subdirectories).to include(clild)
      expect(clild.subdirectories).to include(grandchild)
    end
  end
end
