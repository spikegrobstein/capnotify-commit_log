module Capnotify
  module CommitLog
    class Component < Capnotify::Component

      def content(format=:txt)
        @content.map do |row|
          sha = row[0]
          msg = row[1]
          if format == :txt
            [ sha, msg ].join(' - ')
          elsif format == :html
            "<a href='http://github.com/#{sha}'>#{ sha }</a> #{ msg }"
          end
        end
      end
    end
  end
end
