module MongoidModel
  module Document
    module EnumField
      extend ActiveSupport::Concern

      module ClassMethods

        def enum_field(field_name, options = {type: Symbol})
          raise "values option is required" unless options.has_key? :values

          field_options = options.slice(:type, :default, :index, :required, :denorm)

          field field_name, field_options

          values = options[:values]
          actual_values = values.is_a?(Array) ? values : values.values

          validates_inclusion_of field_name,
                                 in: actual_values,
                                 message: options.has_key?(:message) ? options[:message] : "invalid value",
                                 allow_nil: options[:allow_nil]

          ## define the is_? and text based methods if the values is a hash
          if values.is_a? Hash

            suffix = options[:is_a_suffix] == false ? "" : "_#{field_name}"
            values.keys.each do |key|
              define_method "is_#{key}#{suffix}?" do
                val = self.send field_name
                val == values[key]
              end
            end

            define_method "#{field_name}_name" do
              val = self.send field_name
              values.each do |key, value|
                return key.to_s if value == val
              end
              nil
            end

            # allow key to be used to set value
            #define_method "#{field_name}=" do |val|
            #  unless actual_values.include? val
            #    values.each do |key, value|
            #      if key == val or key.to_s == val
            #        return self[field_name] = value
            #      end
            #    end
            #  end
            #
            #  self[field_name] = val
            #end

            define_method "#{field_name}_name=" do |val|
              if val.blank?
                self[field_name] = nil
              else
                values.each do |key, value|
                  if key == val or key.to_s == val
                    self[field_name] = value
                    return
                  end
                end

                raise "invalid enum name value"
              end
            end
          end

          define_singleton_method "#{field_name}_values" do
            values
          end
        end
      end
    end
  end
end