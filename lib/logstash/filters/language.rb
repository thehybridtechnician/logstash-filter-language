# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

# This example filter will replace the contents of the default
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an example.
class LogStash::Filters::Language < LogStash::Filters::Base

require 'whatlanguage'

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #   example {
  #     message => "My message..."
  #   }
  # }
  #
  config_name "language"

  # Replace the message with this value.
  config :fields, :validate => :array

  public
  def register
    @whatLang = WhatLanguage.new(:all)
  end # def register

  public
  def filter(event)

    ## Concatinate fields

    checkValue = []

    @fields.each { |v|
      checkValue << event[v]
    }


    event['detected_lang'] = @whatLang.language(checkValue.join(' '))
    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::Example
