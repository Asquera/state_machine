require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

require 'couch_potato'

module CouchPotatoTest
  class BaseTestCase < Test::Unit::TestCase
    def default_test
    end
    
    protected
      # Creates a new ActiveRecord model (and the associated table)
      def new_model(&block)
        
        model = Class.new do
          include CouchPotato::Persistence
        end
        model.class_eval(&block) if block_given?
        model
      end
  end
  
  class IntegrationTest < BaseTestCase
    def test_should_have_an_integration_name
      assert_equal :couch_potato, StateMachine::Integrations::CouchPotato.integration_name
    end
    
    def test_should_be_available
      assert StateMachine::Integrations::CouchPotato.available?
    end
    
    def test_should_match_if_class_includes_data_mapper
      assert StateMachine::Integrations::CouchPotato.matches?(new_model)
    end
    
    def test_should_not_match_if_class_does_not_include_data_mapper
      assert !StateMachine::Integrations::CouchPotato.matches?(Class.new)
    end
    
    def test_should_have_defaults
      assert_equal({:static => false}, StateMachine::Integrations::CouchPotato.defaults)
    end
  end
  
  class MachineWithoutPropertyTest < BaseTestCase
    def setup
      @model = new_model
      StateMachine::Machine.new(@model, :status)
    end
    
    def test_should_define_field_with_string_type
      property = @model.properties.detect {|property| property.name == :status}
      assert_not_nil property
      assert_equal String, property.type
    end
  end
  
  
end
