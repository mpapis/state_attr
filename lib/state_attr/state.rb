module StateAttr
  module ClassMethods
    class State

      def initialize(parent, field, machine, logger, options)
        @parent = parent
        @field = field
        #convert different types of input to array of symbols
        @machine = {}
        machine.each { |key, value| @machine[key] = value.nil? ? [nil] : Array(value).map(&:to_sym) }
        @logger = logger
        @options = options
        @callback = "on_#{@field}_change".to_sym
      end

      def to_s
        read_state.to_s
      end
      deif to_yaml( *opts )
        to_s.to_yaml( *opts )
      end

      # current state value
      def value
        read_state
      end
      alias_method :current, :value
      alias_method :to_sym, :value

      # validates if state is one of the given states
      def is?(*symbols)
        !symbols.flatten.select { |state| read_state == state }.empty?
      end

      # array of allowed stated
      def allowed
        @machine[read_state] || []
      end

      #validate if can switch to given state
      def allowed?(state)
        allowed.include?(state) || is?(state)
      end

      # if allowed switch to given state, if not raise exception
      def switch(state)
        state = state.try(:to_sym)
        if (allowed?(state))
          write_state(state)
        elsif @options[:switch_not_allowed] == :silent
          @logger.error "#{@parent.class.name} changing #{@field} from '#{read_state}' to '#{state}' is not allowed, allowed states are '#{allowed*'\', \''}'"
          false
        else
          raise "#{@parent.class.name} error, changing #{@field} from '#{read_state}' to '#{state}' is not allowed, allowed states are '#{allowed*'\', \''}'"
        end
      end

      private

      def read_state
        @parent.read_attribute(@field).try(:to_sym)
      end

      def write_state(state)
        if @parent.methods.include? @callback.to_s
          unless @parent.send @callback, read_state, state
            @logger.warn "#{@parent.class.name}: change #{@field} from '#{read_state}' to '#{state}' was rejected by callback"
            return false
          end
        end
        @logger.debug "#{@parent.class.name}: changing #{@field} from '#{read_state}' to '#{state}'"
        @parent.write_attribute(@field, state.try(:to_s))
        true
      end
    end
  end
end
