# class Class # :nodoc:
#   def class_inheritable_option(sym, default_value=nil)
#     cattr_accessor sym #, default_value
#     send("#{sym}=", default_value) if default_value.present?

#     class_eval <<-EOS
#       def self.#{sym}(value=nil)
#         if !value.nil?
#           send('#{sym}=', value)
#         else
#           send(:#{sym})
#         end
#       end

#       def self.#{sym}=(value)
#         send('#{sym}=', value)
#       end
#     EOS
#   end
# end

# class Class # :nodoc:
#   def class_inheritable_option(sym, default_value=nil)
#     class_attribute sym #, default_value
#     send("#{sym}=", default_value) if default_value.present?

#     class_eval <<-EOS
#       def self.#{sym}(value=nil)
#         if !value.nil?
#           send('#{sym}=', value)
#           write_inheritable_attribute(:#{sym}, value)
#         else
#           read_inheritable_attribute(:#{sym})
#         end
#       end

#       def self.#{sym}=(value)
#         write_inheritable_attribute(:#{sym}, value)
#       end

      def #{sym}
        self.class.#{sym}
      end

      def #{sym}=(value)
        self.class.#{sym} = value
      end
    EOS
  end
end
