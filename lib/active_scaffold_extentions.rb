module ActiveScaffold
  module Helpers
    # Helpers that assist with the rendering of a Form Column
    module FormColumns
      def active_scaffold_input_time_zone(column, options)
        time_zone_select :record, column.name, TZInfo::Timezone.us_zones, :model => TZInfo::Timezone
      end
    end
  end
end

