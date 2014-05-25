# encoding: UTF-8
# job with title
FactoryGirl.define do
  factory :entry_title_w_gender, parent: :entry do
    title 'Berater m/w Citrix'
    clean_title 'berater citrix'
  end
  factory :entry_title_w_gender_brackets, parent: :entry do
    title 'SAP BW Senior Consultant (w/m)'
    clean_title 'sap bw senior consultant'
  end
  factory :entry_title_w_gender_pipe, parent: :entry do
    title 'Key Account Manager m|w'
    clean_title 'key account manager'
  end
  factory :entry_title_w_gender_pipe_brackets, parent: :entry do
    title 'Key Account Manager (m|w)'
    clean_title 'key account manager'
  end
  factory :entry_title_w_gender2, parent: :entry do
    title 'Projektleiter/in Kundenprojekte'
    clean_title 'projektleiter kundenprojekte'
  end
  factory :entry_title_w_gender2_dash, parent: :entry do
    title 'Projektleiter/-in Kundenprojekte'
    clean_title 'projektleiter kundenprojekte'
  end
  factory :entry_title_w_gender2_brackets, parent: :entry do
    title 'Senior JEE Entwickler(in)'
    clean_title 'senior jee entwickler'
  end
  factory :entry_title_w_code, parent: :entry do
    title 'Hardware Engineer Digital 10344jr'
    clean_title 'hardware engineer digital'
  end
  factory :entry_title_w_code2, parent: :entry do
    title 'Hardware Engineer Digital  [SNr. 11739]'
    clean_title 'hardware engineer digital'
  end
  factory :entry_title_w_code3, parent: :entry do
    title 'Hardware Engineer Digital (fimad:3154)'
    clean_title 'hardware engineer digital'
  end
  factory :entry_title_w_dash, parent: :entry do
    title 'Leiter Packmittelentwicklung - Kunststoffverpackungen für Medizin'
    clean_title 'leiter packmittelentwicklung kunststoffverpackungen für medizin'
  end
  factory :entry_title_w_slash, parent: :entry do
    title 'MS Sharepoint Developer / Senior Developer'
    clean_title 'ms sharepoint developer senior developer'
  end
  factory :entry_title_w_senior_brackets, parent: :entry do
    title '(Senior) Developer'
    clean_title 'senior developer'
  end
  factory :entry_title_var_0, parent: :entry do
    title 'Baustellenleiter / Baustellenkoordinator (m/w) – Arbeiten weltweit!'
    clean_title 'baustellenleiter baustellenkoordinator arbeiten weltweit'
  end
  factory :entry_title_w_special, parent: :entry do
    title '++ Sharepoint Developer: Senior Developer!'
    clean_title 'sharepoint developer senior developer'
  end
  factory :entry_title_w_percent, parent: :entry do
    title 'Sharepoint Developer (100%)'
    clean_title 'sharepoint developer'
  end
  factory :entry_title_downcasing, parent: :entry do
    title 'Sharepoint Developer'
    clean_title 'sharepoint developer'
  end
end
