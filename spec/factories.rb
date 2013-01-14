require 'factory_girl'
require 'ostruct'

FactoryGirl.define do
  factory :qc_job_check, class: OpenStruct do
    wrong_industry_id nil
    wrong_function_id 4
    wrong_career_level nil
  end
  factory :job, class: OpenStruct do
    title "Meh"
    description "Foo Bar"
    summary "Really lot of work to do"
    qc_job_check
    original_industry_id 1423
  end

  factory :data, class: PreprocessedData do
    data ["haus fooo garten baaz pferd fooo"]
    career_level_id 7
    label true
  end
  factory :data_w_short_words, parent: :data do
    data ["auto foo pferd bz gooo fooo 2"]
  end
  factory :data_w_multiple_sections, parent: :data do
    data ["meeh foo auto","bz baaz fooo 2"]
  end

  sequence(:value) {|i| [OpenStruct.new(cost: i*10, gamma: i*(-5)), i*11] }
  factory :future, class: OpenStruct do
    value
  end
end
