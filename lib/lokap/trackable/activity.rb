module Lokap
  module Trackable
    module Activity
      def actor_name
        actor ? actor.name : 'n/a'
      end

      def to_s
        "#{created_at.strftime('%m/%d/%Y %l:%M%P')} - #{event_to_s} by #{actor_name}"
      end

      def event_to_s
        event.split('.').last.titleize
      end
      alias :event_name :event_to_s
    end
  end
end

