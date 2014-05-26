#!/usr/bin/env ruby
require 'svm_helper'

data = JSON.parse(IO.read('../tmp/function_data.5k.json'))

data.map! do |e|
  {
    text: e['title'] + e['description'],
    id: e['id'].to_i,
    label: true
  }
end

preprocessor = SvmHelper::Preprocessor::Simple.new
p_data = preprocessor.process(data)

d_builder = SvmHelper::DictionaryBuilder::InformationGain.new(p_data, count: 200)
dictionary = d_builder.dictionary

selector = SvmHelper::Selector.new(dictionary)
feature_vectors = selector.generate(p_data)

