# encoding: UTF-8
# jobs with description
FactoryGirl.define do
  factory :job_description_w_adress, parent: :job do
    description IO.read('spec/factories/jobs/tmp.html')
  end
  factory :job_description_w_tags, parent: :job do
    description IO.read('spec/factories/jobs/tmp2.html')
  end
  factory :job_description_w_special, parent: :job do
    description IO.read('spec/factories/jobs/tmp3.html')
  end

  factory :job_description_w_code_token, parent: :job do
    description IO.read('spec/factories/jobs/tmp.html')
  end
  factory :job_description_w_gender, parent: :job do
    description IO.read('spec/factories/jobs/tmp.html')
  end
end