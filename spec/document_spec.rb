require 'spec_helper'

class TestModel
  include MongoidModel::Document

  enum_field :role, type: Symbol, default: :s, allow_nil: true, is_a_suffix: false, values: {
    admin: :a,
    standard: :s
  }

  field :age, denorm: true
  enum_field :bin, type: Symbol, values: [:hungry, :bored], denorm: true

  tag_field :tags

  tag_field :syms, type: Symbol


end

describe MongoidModel::Document do

  let(:model) { TestModel.new }

  describe MongoidModel::Document::DenormField do
    it "should have a populated denorm_fields array" do
      model.denorm_fields.size.should == 2
    end
  end

  describe MongoidModel::Document::EnumField do
    it "should have mongoid fields" do
      model.respond_to?(:role).should be_true
      model.respond_to?(:bin).should be_true
    end

    it "should provide is_a? fields for hash based values" do
      model.respond_to?(:is_admin?).should be_true
      model.is_standard?.should be_true

      # array based values should not provide accessors
      model.respond_to?(:is_hungry_bin?).should be_false
    end

    it "should provide role_name field since it uses hash based values" do
      model.role_name.should == "standard"
    end

    it "should allow assignment through the name field" do
      model.role_name = "admin"
      model.is_admin?.should be_true

      model.role_name = :standard
      model.is_standard?.should be_true
    end
  end

  describe MongoidModel::Document::TagField do
    let(:existing_model) { TestModel.create! bin: :hungry, tags: 'a,b,c,d', syms: [:a, :b], name: 'testname'}

    it "should show as changed when field is modified" do
      model.tags_changed?.should be_false
      model.tags = "a,b, c"
      model.tags_changed?.should be_true
    end

    it "should convert string tags into an array when being set" do
      model.tags = "a,b, c"
      model.tags.first.should == "a"
      model.tags.last.should == "c"
    end

    it "should remove duplicate values from an array when being set" do
      model.tags = "a,b,c,b,a,a"
      model.tags.size.should == 3
    end

    it "should implement #add_tags method" do
      existing_model.tags = "a,b,c"
      existing_model.add_tags("c,d")
      existing_model.tags.size.should == 4
      existing_model.tags.last.should == 'd'
    end

    it "should implement #tags_added method" do
      existing_model.tags = "a,c,e"
      existing_model.tags_added.first.should == "e"
    end

    it "should implement #tags_removed method" do
      existing_model.tags = "a,c,e"
      existing_model.tags_removed.first.should == "b"
    end

    it "should implement tags scope" do
      existing_model
      TestModel.any_in(tags: ['a']).count.should > 0
      TestModel.any_tags("a, z").count.should > 0

      TestModel.all_tags("a, z").count.should == 0
      TestModel.all_tags("a, b").count.should > 0
      TestModel.all_tags(["a", "b"]).count.should > 0
    end

    it "should support special symbol array type" do
      existing_model.syms.include?(:a).should be_true
    end
  end
end