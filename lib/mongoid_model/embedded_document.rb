module Model
  module EmbeddedDocument
    extend ActiveSupport::Concern

    included do
      include MongoidModel::Document
    end

  end
end