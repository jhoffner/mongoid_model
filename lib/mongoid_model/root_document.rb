module MongoidModel
  module RootDocument
    extend ActiveSupport::Concern

    included do
      include MongoidModel::Document
      include Mongoid::Timestamps::Created
    end

    module ClassMethods

    end
  end
end