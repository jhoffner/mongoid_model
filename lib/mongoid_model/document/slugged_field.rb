module MongoidModel
  module Document
    module SluggedField
      extend ActiveSupport::Concern

      module ClassMethods
        #def slugged_field(field_name, options = {})
        #
        #  include Mongoid::Slug
        #
        #  field field_name, options.slice(:type, :default, :denorm)
        #  slug field_name, options.slice(:history, :scope, :reserve, :permanent, :as, :index)
        #  validates_presence_of field_name
        #
        #  scope :slug, lambda {|slug| where(slug: slug)}
        #  scope :any_slug, lambda {|slugs| where(:slug.in => slugs)}
        #
        #  if options[:scope]
        #    #TODO: make this support relationships - currently only supports fields
        #    scope :scoped_slug, lambda {|scoped_value, slug| where(options[:scope] => scoped_value, :slug.in => slug)}
        #  end
        #end
      end
    end
  end
end