require 'state_attr/state'
module StateAttr

  module ClassMethods
    def state_attr(attr, machine, options={}, &block)
      #attr, initial = attr
      self.send :define_method, attr do
        @state_handlers ||= {}
        @state_handlers[attr] ||= State.new(self, attr, machine, logger, options)
        @state_handlers[attr]
      end

      if options[:setter] == :exception
        self.send :define_method, "#{attr}=".to_sym do |state|
          raise "#{self.class.name} error, manual setting of state is not allowed (new value '#{state}')"
        end
      else
        self.send :define_method, "#{attr}=".to_sym do |state|
          @state_handlers ||= {}
          @state_handlers[attr] ||= State.new(self, attr, machine, logger, options)
          @state_handlers[attr].switch(state)
        end
      end

      if block_given?
        self.send :define_method, "on_#{attr}_change".to_sym, block
      end
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end
end
