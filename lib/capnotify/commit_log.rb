require "capnotify/commit_log/version"
require "capnotify/commit_log/component"

module Capnotify
  module CommitLog
    def self.load_into(config)
      config.load do
        capnotify.load_plugin(:capnotify_commit_log, ::Capnotify::CommitLog)
      end
    end

    def init
      capnotify.components << Capnotify::CommitLog::Component.new(:capnotify_commit_log) do |c|
        c.header = 'Log'

        c.css_class = 'commit-log'
        c.custom_css = <<-CSS
          .commit-log ul {
            font-family: monospace;

            list-style: none;
            margin: 0;
            padding: 0;
          }

          .commit-log ul li {
            margin: 5px;
          }

          .commit-log ul li a {
            font-weight: bold;
            padding: 2px 5px;
            background-color: #eee;
            color: #666;
            text-decoration: none;
          }

          .commit-log ul li a:hover {
            text-decoration: underline;
            color: black;
          }
        CSS


        c.content = commit_log('d7f8b9fb9757f00d69ac1657270b9fc29d15b7aa', '3ba4cdf61018daff0c4cdfef4ba0e65f600ba4e4')
      end
    end

    def unload
      capnotify.delete_component :capnotify_commit_log
    end

    # git log between +first_ref+ to +last_ref+
    # memoizes the output so this function can be called multiple times without re-running
    # FIXME: memoization does not account for arguments
    # FIXME: this should probably use the git gem
    # FIXME: this only supports git.
    #
    # returns an array of 2-element arrays in the form of
    # [ ref, log_text ]
    def commit_log(first_ref, last_ref)
      puts "running commit log"
      return @commit_log unless @commit_log.nil?

      begin
        raise "Ref missing" if first_ref.nil? || last_ref.nil? # jump to rescue block.

        log_output = run_locally("git log --oneline #{ first_ref }..#{ last_ref }")

        puts "Got log output: #{ log_output }"

        @commit_log = log_output.split("\n").map do |line|
          fields = line.split("\s", 2)
          [ fields[0], fields[1] ]
        end
      rescue
        [ [ 'n/a', 'Log output not available.' ] ]
      end
    end

  end
end

if Capistrano::Configuration.instance
  Capnotify::CommitLog.load_into(Capistrano::Configuration.instance)
end

