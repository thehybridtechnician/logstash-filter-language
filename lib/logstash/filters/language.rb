# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

class LogStash::Filters::Language < LogStash::Filters::Base

require 'cld'
  # This filter is designed to detect the language of a given field or fields
  # Example configuration
  # ------------------------------------
  # filter {
  #   language {
  #     fields => ['message']
  #     amount_of_chars => 100
  #   }
  # }
  # -----------------------------------
  #
  # The 'fields' variable takes 1 or more fields and uses the cld to determine
  # the language.
  # The 'amount_of_chars' field allows you to specify to run the check only if
  # a certain amount of characters are present
  # The 'concat_fields' field will create a new field with all fields specified
  # in 'fields'
  # The 'concat_prefix' field will prefix the field name for concat_fields.  for
  # example, the concat field name would look like 'language_en' or 'language_es'
  # Example run
  # -------------------------------------------------------------------------
  # bin/logstash agent -e 'input { stdin { } } filter { language { concat_fields => true } } output { stdout { codec => rubydebug } }'
  # Example: "Logstash and logstash-filter-language is awesome"
  # -------------------------------------------------------------------------
  #
  # -------------------------------------------------------------------------
  # {
  #          "message" => "Logstash and logstash-filter-language is awesome",
  #         "@version" => "1",
  #    "detected_lang" => "en",
  # "lang_reliability" => true,
  #      "language_en" => "Logstash and logstash-filter-language is awesome"
  # }
  # -------------------------------------------------------------------------
  config_name "language"

  # Replace the message with this value.
  config :fields, :validate => :array, :default => 'message'
  config :amount_of_chars, :validate => :number, :default => 0
  config :concat_fields, :validate => :boolean
  config :concat_prefix, :validate => :string, :default => 'language'

  public
  def register
  end # def register

  public
  def filter(event)
    ## Concatinate fields
    checkValue = []

    @logger.debug("Checking language in #{@fields}")

    # Put all fields for language detection into checkValue
    @fields.each { |v|
      unless event[v].nil?
        checkValue << event[v]
      end
    }

    unless checkValue.nil?
      if checkValue.join(' ').length >= @amount_of_chars
        language = CLD.detect_language(checkValue.join(' '))
        @logger.debug("Language values are #{language}")
        event['detected_lang'] = language[:code]
        event['lang_reliability'] = language[:reliable]
        if @concat_fields
          event["#{@concat_prefix}_#{language[:code]}"] = checkValue.join(' ')
        end
      end
    end
    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::Language
