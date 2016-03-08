# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

# This example filter will replace the contents of the default
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an example.
class LogStash::Filters::Language < LogStash::Filters::Base

require 'cld'

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
  config :fields, :validate => :array, :required => true
  config :amount_of_chars, :validate => :number, :required => true
  config :concat_fields, :validate => :boolean
  config :concat_prefix, :validate => :string

  public
  def register
  end # def register

  public
  def filter(event)

    ## Concatinate fields

    checkValue = []

    @fields.each { |v|
      unless event[v].nil?
        checkValue << event[v]
      end
    }
    unless checkValue.nil?
      if checkValue.join(' ').length >= @amount_of_chars
        language = CLD.detect_language(checkValue.join(' '))
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
end # class LogStash::Filters::Example
