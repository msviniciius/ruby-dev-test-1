FactoryBot.define do
  factory :file_entry do
    sequence(:name) { |n| "Arquivo #{n}" }
    file { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/test_file.txt"), "text/plain") }
    association :directory
  end
end
