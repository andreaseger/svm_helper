require 'factory_girl'
require 'ostruct'

FactoryGirl.define do
  factory :qc_job_check, class: OpenStruct do
    wrong_industry_id nil
    wrong_function_id 4
    wrong_career_level nil
  end
  factory :job, class: Hash do
    title "Meh"
    description "Foo Bar"
    id 4
    label true

    initialize_with { attributes }
  end


  factory :data, class: PreprocessedData do
    data %w(haus fooo garten baaz pferd fooo)
    id 7
    label true
  end
  factory :data_w_short_words, parent: :data do
    data %w(auto pferd gooo fooo)
    label false
  end
  factory :data_w_multiple_sections, parent: :data do
    data [%w(meeh auto),%w(baaz fooo)]
  end
end
