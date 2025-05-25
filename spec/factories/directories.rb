FactoryBot.define do
  factory :directory do
    sequence(:name) { |n| "Diretório #{n}" }
    parent { nil }

    trait :with_subdirectories do
      after(:create) do |directory|
        create_list(:directory, 3, parent: directory)
      end
    end

    trait :with_files do
      after(:create) do |directory|
        create_list(:file_entry, 3, directory: directory)
      end
    end
  end
end
