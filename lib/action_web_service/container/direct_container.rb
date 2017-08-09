module ActionWebService # :nodoc:
  module Container # :nodoc:
    module Direct # :nodoc:
      class ContainerError < ActionWebServiceError # :nodoc:
      end

      def self.included(base) # :nodoc:
        base.extend(ClassMethods)
      end
  
      module ClassMethods
        # Attaches ActionWebService API +definition+ to the calling class.
        #
        # Action Controllers can have a default associated API, removing the need
        # to call this method if you follow the Action Web Service naming conventions.
        #
        # A controller with a class name of GoogleSearchController will
        # implicitly load <tt>app/apis/google_search_api.rb</tt>, and expect the
        # API definition class to be named <tt>GoogleSearchAPI</tt> or
        # <tt>GoogleSearchApi</tt>.
        #
        # ==== Service class example
        #
        #   class MyService < ActionWebService::Base
        #     web_service_api MyAPI
        #   end
        #
        #   class MyAPI < ActionWebService::API::Base
        #     ...
        #   end
        #
        # ==== Controller class example
        #
        #   class MyController < ActionController::Base
        #     web_service_api MyAPI
        #   end
        #
        #   class MyAPI < ActionWebService::API::Base
        #     ...
        #   end
        cattr_accessor "web_service_api_callbacks"
        cattr_accessor "web_service_api"
        def web_service_api(definition=nil)
          if definition.nil?
            send("web_service_api")
          else
            if definition.is_a?(Symbol)
              raise(ContainerError, "symbols can only be used for #web_service_api inside of a controller")
            end
            unless definition.respond_to?(:ancestors) && definition.ancestors.include?(ActionWebService::API::Base)
              raise(ContainerError, "#{definition.to_s} is not a valid API definition")
            end
            send("web_service_api=", definition)
            call_web_service_api_callbacks(self, definition)
          end
        end
  
        def add_web_service_api_callback(&block) # :nodoc:
          send("web_service_api_callbacks=", [block])
          #write_inheritable_array("web_service_api_callbacks", [block])
        end
  
        private
          def call_web_service_api_callbacks(container_class, definition)
            (send("web_service_api_callbacks") || []).each do |block|
            #(read_inheritable_attribute("web_service_api_callbacks") || []).each do |block|
              block.call(container_class, definition)
            end
          end
      end
    end
  end
end
