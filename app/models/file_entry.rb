class FileEntry < ApplicationRecord
  belongs_to :directory
  has_one_attached :file # vamos usar ActiveStorage para armazenar os arquivos

  validates :name, presence: true
end
