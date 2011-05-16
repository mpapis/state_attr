require 'test/unit'
require 'state_attr'

# fake rails
class << nil
  def try *args
    nil
  end
end

class Object
  def try *args
    send *args
  end
end

class Logger
  def info msg
  end
  def warn msg
  end
  def error msg
  end
  def debug msg
  end
end
RAILS_DEFAULT_LOGGER = Logger.new

module ActiveRecord
  class Base
    def write_attribute(name, value)
      @attributes ||= {}
      @attributes[name] = value
    end
    def read_attribute(name)
      attributes[name]
    end
    def attributes
      @attributes || {}
    end
    def logger
      RAILS_DEFAULT_LOGGER
    end
    include StateAttr
  end
end
