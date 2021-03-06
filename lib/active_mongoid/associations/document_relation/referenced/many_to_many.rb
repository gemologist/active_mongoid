module ActiveMongoid
  module Associations
    module DocumentRelation
      module Referenced
        class ManyToMany < Associations::Many

          private

          def criteria
            ManyToMany.criteria(__metadata__, base.send(__metadata__.primary_key), base.class)
          end

          def binding
            Bindings::ManyToMany.new(base, target, __metadata__)
          end

          class << self

            def stores_foreign_key?
              false
            end

            def foreign_key(name)
              "#{name.singularize}#{foreign_key_suffix}"
            end

            def foreign_key_default
              nil
            end

            def foreign_key_suffix
              "_ids"
            end

            def primary_key_default
              "id"
            end

            def macro
              :has_and_belongs_many_documents
            end

            def builder(base, meta, object)
              ActiveMongoid::Associations::Builders::Many.new(base, meta, object || [])
            end

            def criteria(metadata, object, type = nil)
              crit = metadata.klass.where(metadata.foreign_key => object)
              if metadata.polymorphic?
                crit = crit.where(metadata.type => type.name)
              end
              crit
            end

          end

        end
      end
    end
  end
end
