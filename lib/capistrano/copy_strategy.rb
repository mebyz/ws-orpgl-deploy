    module GitCopyStrategy
      def git(*args)
        args.unshift :git
        context.execute *args
      end

      def test
        test! " [ -f #{repo_path}/HEAD ] "
      end

      def check
        test! :git, :'ls-remote -h', repo_url
      end

      def clone
        git :clone, '--mirror', repo_url, repo_path
      end

      def update
        git :remote, :update
      end

      def release
        git :clone, repo_path, release_path
        # We are already in repo_path (from git.rake),
        # within joins paths, so we must be explicit
        context.execute <<-EOCOMMAND
          cd #{release_path} && git checkout #{fetch(:branch)} && git remote set-url origin #{repo_url}
        EOCOMMAND
      end

      def fetch_revision
        context.capture(:git, "rev-parse --short #{fetch(:branch)}")
      end
    end
