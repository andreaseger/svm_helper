# encoding: UTF-8
# jobs with text
FactoryGirl.define do
  factory :entry_text_w_adress, parent: :entry do
    text IO.read('spec/factories/jobs/tmp.html')
  end
  factory :entry_text_w_tags, parent: :entry do
    text IO.read('spec/factories/jobs/tmp2.html')
  end
  factory :entry_text_w_special, parent: :entry do
    text IO.read('spec/factories/jobs/tmp3.html')
  end

  factory :entry_text_w_code_token, parent: :entry do
    text IO.read('spec/factories/jobs/tmp.html')
  end
  factory :entry_text_w_gender, parent: :entry do
    text IO.read('spec/factories/jobs/tmp.html')
  end
end
