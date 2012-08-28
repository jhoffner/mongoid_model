
module MongoidModel
  module Document
    extend ActiveSupport::Concern

    included do
      include Mongoid::Document
      include MongoidModel::Document::Atomic

      include MongoidModel::Document::DenormField
      include MongoidModel::Document::EnumField
      include MongoidModel::Document::TagField
      #include MongoidModel::Document::SluggedField

    end

    def stale?
      @stale == true
    end

    # determines if a value is present - useful for bypassing a lazy attribute from automatically loading an object from storage
    def has_value?(name)
      !self.instance_variable_get("@#{name}").nil?
    end

    def slice(*syms)
      result = {}
      syms.each do |sym|
        result[sym] = self.send sym
      end
      result
    end

    def to_hash
      hash = JSON.parse(to_json)
    end

    def raw_save(opts = {})
      return true if !changed? && !opts.delete(:force)

      if (opts.delete(:validate) != false || valid?)
        self.collection.save(raw_attributes, opts)
        true
      else
        false
      end
    end
  end
end