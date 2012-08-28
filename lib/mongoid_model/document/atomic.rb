module MongoidModel
  module Document
    module Atomic
      extend ActiveSupport::Concern

      module ClassMethods
        def find!(*args)
          find(*args) || raise(Mongoid::Errors::DocumentNotFound.new(self, args))
        end

        def inc(conditions, update)
          _apply_modifier('$inc', conditions, update)
        end

        def dec(conditions, update)
          update.each do |k, v|
            update[k] = -v.abs
          end

          _apply_modifier('$inc', conditions, update)
        end

        def set(conditions, update)
          _apply_modifier('$set', conditions, update)
        end

        def unset(conditions, update)
          _apply_modifier('$unset', conditions, update)
        end

        def push(conditions, update)
          _apply_modifier('$push', conditions, update)
        end

        def push_all(conditions, update)
          _apply_modifier('$pushAll', conditions, update)
        end

        def add_to_set(conditions, update)
          _apply_modifier('$addToSet', conditions, update)
        end

        def pull(conditions, update)
          _apply_modifier('$pull', conditions, update)
        end

        def pull_all(conditions, update)
          _apply_modifier('$pullAll', conditions, update)
        end

        def pop(conditions, update)
          _apply_modifier('$pop', conditions, update)
        end

        private

        def _apply_modifier(modifier, conditions, update)
          collection.update(conditions, {modifier => update}, :multi => true)
        end
      end

      def atomic_modifier(modifier_name, update)
        self.class.send(modifier_name, atomic_selector, update)
      end

      def atomic_update(update)
        collection.update(atomic_selector, update)
      end

    end

  end
end