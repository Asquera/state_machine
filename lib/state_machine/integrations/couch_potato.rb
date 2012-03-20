require 'state_machine/integrations/active_model'

module StateMachine
  module Integrations
    module CouchPotato
      include Base
      include ActiveModel

      @defaults = {:static => false}

      def self.matching_ancestors
        %w(CouchPotato::Persistence)
      end

      def define_state_accessor
        owner_class.property(attribute, :type => String) unless owner_class.properties.detect {|property| property.name == attribute}
      end

      def define_state_initializer
        define_helper :instance, <<-end_eval, __FILE__, __LINE__ + 1
          def initialize(*args)
            #self.class.state_machines.initialize_states(nil, :dynamic => false, :to => result)
            super
            if Hash === args.first && args.first[:_document] # document was deserialized
              self.class.state_machines.initialize_states(self, :static => false)
            else
              self.class.state_machines.initialize_states(self)
            end
          end
        end_eval
      end
    end
  end
end