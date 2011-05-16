# About

StateAttr is an minimalistic state machine approach for rails allowing multiple state attributes at the same time.

# Installation

    gem install state_attr

# Examples

    state_attr :state, {
      nil => :first,
      :first => [:second, :third],
      :second => :last,
      :third => nil,
    }

    state_attr :invitation_state, {
      :invited => %w{approved rejected},
      :approved => :rejected,
      :rejected => :approved,
    }, :initial => :invited

    state_attr :progress, {
      nil => :one,
      :one => :two,
      :two => :three
    } do |old, new|
      if new == :three
        send_mail "You just finished."
      else
        send_mail "You just made to #{new}."
      end
    end

# Options

 - :initial => :value - initial `value` (not yet implemented)
 - :setter => :exception - raise exception when calling `state=`
 - :switch_not_allowed => :silent - do not raise exception when switch is not allowed
