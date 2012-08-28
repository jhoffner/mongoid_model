module MongoidModel
  module Document
    module DenormField
      extend ActiveSupport::Concern

      module ClassMethods
        def denorm_fields
          @denorm_fields ||= []
        end

        #def field(field_name, options = {})
        #  denorm_fields.push field_name if options[:denorm] == true
        #
        #  options.delete(:denorm)
        #  super(field_name, options)
        #end

        def denorm_field(field_name, options = {})

          field field_name, options

          denorm_fields.push field_name
        end
      end

      def denorm_fields
        self.class.denorm_fields
      end
    end
  end
end

Mongoid::Fields.option :denorm do |model, field, value|
  model.denorm_fields.push field.name
end