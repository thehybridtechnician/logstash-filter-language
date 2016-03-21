# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/filters/language"

describe LogStash::Filters::Language do

  describe "defaults" do
    config <<-CONFIG
      filter {
        language { }
      }
    CONFIG

    sample "Logstash-filter-language creates a field with detected language." do
      insist { subject["detected_lang"] } == "en"
    end
  end
end
