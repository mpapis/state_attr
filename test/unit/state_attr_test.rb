require 'test_helper'

class FakeModel < ActiveRecord::Base
  state_attr :state1, {
    nil => :a,
    :a => :b,
  }, :setter => :exception

  state_attr :state2, {
    nil => [:d,:f],
    :d => [:e,:f],
    :f => [:d,:e],
    :e => nil,
  }, :setter => :exception

  state_attr :state3, {
    nil => :g,
    :g => :h,
  }
end

class StateAttrTest < Test::Unit::TestCase
  def test_single_set_read
    model = FakeModel.new
    assert_equal nil, model.state1.value
    assert_equal "", model.state1.to_s
    model.state1.switch(:a)
    assert_equal :a, model.state1.value
    assert_equal "a", "#{model.state1}"
  end
  def test_single_set_fail
    model = FakeModel.new
    assert_raises RuntimeError do
      model.state1.switch(:c)
    end
    assert_equal nil, model.state1.value
  end
  def test_single_assignment_fail
    model = FakeModel.new
    assert_raises RuntimeError do
      model.state1=:a
    end
    assert_equal nil, model.state1.value
  end
  def test_single_assignment_success
    model = FakeModel.new
    model.state3=:g
    assert_equal :g, model.state3.value
  end
  def test_single_set_nil
    model = FakeModel.new
    model.state2.switch(:d)
    model.state2.switch(:e)
    assert_equal :e, model.state2.value
    model.state2.switch(nil)
    assert_equal nil, model.state2.value
  end
  def test_double_set
    model = FakeModel.new
    model.state1.switch(:a)
    model.state2.switch(:d)
    assert_equal :a, model.state1.value
    assert_equal :d, model.state2.value
  end
  def test_single_is?
    model = FakeModel.new
    model.state2.switch(:d)
    assert model.state2.is?(:d)
    assert !model.state2.is?(:e)
    assert model.state2.is?(:d,:e)
  end
  def test_single_allowed?
    model = FakeModel.new
    model.state2.switch(:d)
    assert !model.state2.allowed?(nil)
    assert model.state2.allowed?(:d)
    assert model.state2.allowed?(:e)
  end
end
