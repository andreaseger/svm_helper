#!/usr/bin/env ruby
require 'svm_helper'
require 'json'

data = JSON.parse(IO.read(File.join(__dir__, '../tmp/function_data.5k.json')))

data = data.shuffle.first(1_000).map.with_index do |e, i|
  {
    text:  e['title'] + e['description'],
    id:    i.even? ? e['function_id'].to_i : ((1..19).to_a - [4]).sample,
    label: i.even? ? true : false
  }
end

preprocessor = SvmHelper::Preprocessor::Simple.new
p_data = preprocessor.process(data)

d_builder = SvmHelper::DictionaryBuilder::BiNormalSeparation.new(p_data, count: 500)
dictionary = d_builder.dictionary

selector = SvmHelper::Selector.new(dictionary)
feature_vectors = selector.generate(p_data)

puts feature_vectors.first
