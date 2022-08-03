module Lokap
  module Trackable
    module TableUtilities
      def trackable_method?(method)
        method.to_s.split('_').first == 'trackable'
      end

      def trackable_table_name(class_name=nil)
        return class_name.tableize unless class_name.nil?
        [arel_table.name.singularize, "activities"].join('_')
      end

      def trackable_class_name(class_name=nil)
        return class_name.classify unless class_name.nil?
        "Activity".classify
      end
    end
  end
end

