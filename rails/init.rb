require 'state_attr'
ActiveRecord::Base.send( :include, StateAttr )
