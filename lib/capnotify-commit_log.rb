require 'git'
require "capnotify"
require "capnotify-commit_log/version"

module Capnotify
  module CommitLog

    DEFAULT_COMMIT_LOG_ENTRY = {
        :author  => 'n/a',
        :date    => 'n/a',
        :email   => 'n/a',
        :sha     => 'n/a',
        :message => 'Log output not available.'
      }

    def self.load_into(config)
      config.load do
        on(:load) do
          capnotify.load_plugin(:capnotify_commit_log, ::Capnotify::CommitLog)
        end
      end
    end

    def init
      capnotify.components << Capnotify::Component.new(:capnotify_commit_log) do |c|
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

        c.template_path = File.join( File.dirname(__FILE__), 'templates' )

        c.render_for :html => '_commit_log.html.erb', :txt => '_commit_log.txt.erb'

        c.content = commit_log(fetch(:previous_revision, nil), fetch(:real_revision, nil))
      end
    end

    def unload
      capnotify.delete_component :capnotify_commit_log
    end

    # locate the git repository for the project
    # starting with the local_git_repository_path
    # or current working directory (or path, if specified),
    # traverse the filesystem going up until we hit a git repository.
    # returns nil if one is not found. otherwise returns a Git object
    def find_git_repo(path=nil)
      # use local_git_repository_path or Dir.pwd if path is not specified
      path = fetch(:local_git_repository_path, Dir.pwd) if path.nil?

      # expand the path
      path = File.expand_path(path)

      return nil if path == '/'

      # try to open the current path
      # if fail, go up a directory
      begin
        ::Git.open(path)
      rescue ArgumentError
        find_git_repo(File.join(path, '..'))
      end
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

      git = find_git_repo

      begin
        raise "Ref missing" if first_ref.nil? || last_ref.nil? # jump to rescue block.

        log_results = git.log(first_ref, last_ref)

        @commit_log = log_results.map do |log|
          {
            :author  => log.author,
            :date    => log.date,
            :email   => log.email,
            :sha     => log.sha,
            :message => log.message
          }
        end

      rescue
        [ DEFAULT_COMMIT_LOG_ENTRY ]
      end
    end

  end
end

if Capistrano::Configuration.instance
  Capnotify::CommitLog.load_into(Capistrano::Configuration.instance)
end

