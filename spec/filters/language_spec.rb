# encoding: utf-8
require 'spec_helper'
require "logstash/filters/example"

describe LogStash::Filters::Language do
  describe "Set Language Checker" do
    let(:config) do <<-CONFIG
      filter {
        language {
          fields => ["message"]
        }
      }
    CONFIG
    end

    sample("message" => "Logstash-filter-language creates a field with detected language.") do
      expect(subject).to include("message")
      expect(subject['detected_lang']).to eq('en')
    end
  end
end
