require 'factory_girl'
require 'ostruct'

FactoryGirl.define do
  factory :qc_job_check, class: OpenStruct do
    wrong_industry_id nil
    wrong_function_id 4
    wrong_career_level nil
  end
  factory :entry, class: Hash do
    title 'Meh'
    text 'Foo Bar'
    id 4
    label true

    initialize_with{attributes}
  end

  factory :data, class: PreprocessedData do
    token %w(haus fooo garten baaz pferd fooo)
    id 7
    correct true
  end
  factory :data_w_short_words, parent: :data do
    token %w(auto pferd gooo fooo)
    correct false
  end
  factory :data_w_multiple_sections, parent: :data do
    token [%w(meeh auto), %w(baaz fooo)]
  end

  factory :vector, class: FeatureVector do
    text_features %w(haus fooo garten baaz pferd fooo)
    classification_array [0, 0, 1, 0]
    classification 3
    correct true
  end
  factory :vector_false, parent: :vector do
    text_features %w(some more words)
    correct false
  end
end
