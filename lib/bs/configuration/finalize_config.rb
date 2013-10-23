# encoding: utf-8
require_relative 'local_repository'

module BS::Configuration
  class FinalizeConfig

    def initialize

      Settings.finally do |config|
        exit_if_unknown_args(config)
        exit_if_empty_arguments(config)
        exit_if_version_present(config)
        resolve_ref_to_full_sha(config)
        use_debug_log_level_if_verbose(config)
        exit_on_missing_ref(config)
      end

      Settings.resolve!

    rescue RuntimeError => e
      print_feedback_and_exit(e.message)
    end

    private

    def exit_if_unknown_args(config)
      unknown = config.unknown_argvs
      if unknown && unknown.length >= 1
        print_feedback_and_exit("unknown argument: #{unknown.join(', ')}")
      end
    end

    def exit_if_empty_arguments(config)

      # XXX --ref e1e2e2, missing the '=' char will yeild config.ref == true
      missing_value =  config.github_password == true ||
                       config.github_user == true ||
                       config.log_level == true ||
                       config.owner == true ||
                       config.repo == true ||
                       config.reporter == true ||
                       config.ref == true

      if missing_value
        print_feedback_and_exit('an argument is missing a value')
      end
    end

    def exit_if_version_present(config)
      if config.version
        puts "version: #{BS::VERSION}"
        exit(2)
      end
    end

    def exit_on_missing_ref(config)
      unless config.ref
        print_feedback_and_exit('run in a repo with github remote'\
                                ', or set --owner, --repo & --ref')
      end
    end

    def resolve_ref_to_full_sha(config)
      if config.ref && looks_like_sha(config.ref)
        local_repo = LocalRepository.new
        config.ref = local_repo.resolve_sha(config.ref)
      end
    end

    def looks_like_sha(ref)
      /^[0-9a-f]{6,39}$/ === ref
    end

    def use_debug_log_level_if_verbose(config)
      config.log_level = :DEBUG if config.verbose
    end

    def print_feedback_and_exit(msg)
      puts ''
      puts "error: #{msg}"
      puts ''
      exit(2)
    end
  end
end
