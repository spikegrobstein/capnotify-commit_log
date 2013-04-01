module Capnotify
  module CommitLog
    class Component < Capnotify::Component

      # default_template_path File.join( File.dirname(__FILE__), '../templates' )

      # default_render :html, '_commit_log.html.erb'
      # default_render :txt, '_commit_log.txt.erb'

      # def content(format=:txt)
        # @content.map do |row|
          # sha = row[0]
          # msg = row[1]
          # if format == :txt
            # [ sha, msg ].join(' - ')
          # elsif format == :html
            # "<a href='http://github.com/#{sha}'>#{ sha }</a> #{ msg }"
          # end
        # end
      # end
    end
  end
end
