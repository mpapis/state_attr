module StateAttr
  module ClassMethods
    class State

      def initialize(parent, field, machine, logger, options, callback)
        @parent = parent
        @field = field
        #convert different types of input to array of symbols
        @machine = Hash[machine.map { |key, value| [key, value.nil? ? [nil] : Array(value).map(&:to_sym)] }]
        @logger = logger
        @callback = callback
        @options = options
      end

      def to_s
        read_state.to_s
      end

      # current state value
      def value
        read_state
      end
      alias_method :current, :value

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
        if @callback
          unless @callback.call(read_state, state)
            @logger.warn "#{@parent.class.name}: change #{@field} from '#{read_state}' to '#{state}' was rejected by callback"
            return false
          end
        end
        @logger.debug "#{self.class.name}: changing state from '#{read_state}' to '#{value}'"
        @parent.write_attribute(@field, state.try(:to_s))
        true
      end
    end
  end
end
