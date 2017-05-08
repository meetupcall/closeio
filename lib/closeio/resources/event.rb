module Closeio
  class Client
    module Event
      def list_events(params = nil, paginate = false)

    	if paginate
          paginate_events(event_path, params)
        else
          get(event_path, params)
        end
      end

      private

      def paginate_events(path, options={})
      results = []
      cursor    = nil

      begin
      	#binding.pry
        res   = get(path, options.merge!(_cursor: cursor))
        unless res.cursor_next.nil? || res.cursor_next.empty?
          results.push res.data
          cursor = res.cursor_next
        end
      end while res.cursor_next
      json = {has_more: false, total_results: res.total_results, data: results.flatten}
      Hashie::Mash.new json
    end

      def event_path(id=nil)
        id ? "event/#{id}/" : "event/"
      end
    end
  end
end
