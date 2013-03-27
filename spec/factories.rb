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
    data ["haus fooo garten baaz pferd fooo"]
    id 7
    label true
  end
  factory :data_w_short_words, parent: :data do
    data ["auto fo pferd bz gooo fooo 2"]
    label false
  end
  factory :data_w_multiple_sections, parent: :data do
    data ["meeh fo auto","bz baaz fooo 2"]
  end
end
