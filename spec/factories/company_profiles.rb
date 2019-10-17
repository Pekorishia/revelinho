include ActionDispatch::TestProcess
FactoryBot.define do
  factory :company_profile do
    company
    full_description { 'Emprega pessoase faz uns serviços' }
    benefits { 'vt e vr' }
    logo do
      fixture_file_upload(Rails.root.join('spec', 'support', 'images',
                                          'gatinho.jpg'))
    end

    trait :with_blank_field do
      benefits { nil }
      full_description { nil }
      logo { nil }
    end
  end
end
