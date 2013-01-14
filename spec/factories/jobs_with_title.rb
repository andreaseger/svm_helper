# encoding: UTF-8
# job with title
FactoryGirl.define do
  factory :job_title_w_gender, parent: :job do
    title "Berater m/w Citrix"
    clean_title "berater citrix"
  end
  factory :job_title_w_gender_brackets, parent: :job do
    title "SAP BW Senior Consultant (w/m)"
    clean_title "sap bw senior consultant"
  end
  factory :job_title_w_gender_pipe, parent: :job do
    title 'Key Account Manager m|w'
    clean_title 'key account manager'
  end
  factory :job_title_w_gender_pipe_brackets, parent: :job do
    title 'Key Account Manager (m|w)'
    clean_title 'key account manager'
  end
  factory :job_title_w_gender2, parent: :job do
    title 'Projektleiter/in Kundenprojekte'
    clean_title 'projektleiter kundenprojekte'
  end
  factory :job_title_w_gender2_dash, parent: :job do
    title 'Projektleiter/-in Kundenprojekte'
    clean_title 'projektleiter kundenprojekte'
  end
  factory :job_title_w_gender2_brackets, parent: :job do
    title "Senior JEE Entwickler(in)"
    clean_title "senior jee entwickler"
  end
  factory :job_title_w_code, parent: :job do
    title 'Hardware Engineer Digital 10344jr'
    clean_title 'hardware engineer digital'
  end
  factory :job_title_w_code2, parent: :job do
    title 'Hardware Engineer Digital  [SNr. 11739]'
    clean_title 'hardware engineer digital'
  end
  factory :job_title_w_code3, parent: :job do
    title 'Hardware Engineer Digital (fimad:3154)'
    clean_title 'hardware engineer digital'
  end
  factory :job_title_w_dash, parent: :job do
    title 'Leiter Packmittelentwicklung - Kunststoffverpackungen für Medizin'
    clean_title 'leiter packmittelentwicklung kunststoffverpackungen für medizin'
  end
  factory :job_title_w_slash, parent: :job do
    title 'MS Sharepoint Developer / Senior Developer'
    clean_title 'ms sharepoint developer senior developer'
  end
  factory :job_title_w_senior_brackets, parent: :job do
    title '(Senior) Developer'
    clean_title 'senior developer'
  end
  factory :job_title_var_0, parent: :job do
    title 'Baustellenleiter / Baustellenkoordinator (m/w) – Arbeiten weltweit!'
    clean_title 'baustellenleiter baustellenkoordinator arbeiten weltweit'
  end
  factory :job_title_w_special, parent: :job do
    title '++ Sharepoint Developer: Senior Developer!'
    clean_title 'sharepoint developer senior developer'
  end
  factory :job_title_w_percent, parent: :job do
    title 'Sharepoint Developer (100%)'
    clean_title 'sharepoint developer'
  end
  factory :job_title_downcasing, parent: :job do
    title 'Sharepoint Developer'
    clean_title 'sharepoint developer'
  end
end