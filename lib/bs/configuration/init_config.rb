# encoding: utf-8
require 'configliere'
require_relative 'log_handler'
require_relative '../version'
require_relative '../reporters/report_handler'

module BS::Configuration

  class InitConfig

    def initialize
      init_settings
      define_default_settings
      define_output_settings
      define_github_auth
      define_github_repo
      define_config_file_settings
    end

    private

    def init_settings
      Settings.use :env_var, :commandline
      Settings.description = 'A script to fetch continous integraton build '\
                             'status for a github commit'\
                             "\n\n"\
                             "version: #{BS::VERSION}"
    end

    def define_default_settings
      Settings(settings_from_local_repository)
    end

    def settings_from_local_repository
      local_repo = LocalRepository.new
      {
        owner: local_repo.owner,
        repo:  local_repo.repo,
        ref:   local_repo.head_sha
      }
    end

    def define_output_settings
      Settings.define :verbose,
                      type:        :boolean,
                      env_var:     'BS_VERBOSE',
                      default:     false,
                      required:    false,
                      flag:        'V',
                      description: 'Print more commit status information'

      Settings.define :version,
                      type:        :boolean,
                      env_var:     'BS_VERBOSE',
                      default:     false,
                      required:    false,
                      flag:        'v',
                      description: 'Print version'

      log_levels = LogHandler::LOG_LEVELS.join(', ')

      Settings.define :log_level,
                      env_var:     'BS_LOG_LEVEL',
                      default:     :WARN,
                      flag:        'l',
                      required:    false,
                      description: "Try: #{log_levels}"

      reporters = BS::Reporters::ReportHandler.new.reporters
      reporters = reporters.map do |reporter|
        reporter.config_name
      end.join(', ')

      Settings.define :reporter,
                      env_var:     'BS_REPORTER',
                      default:     'default',
                      required:    false,
                      description: "Try: #{reporters}"

    end

    def define_github_auth
      Settings.define :github_user,
                      env_var:     'BS_GITHUB_USER',
                      description: 'Github username to use for authentication',
                      flag:        'u',
                      required:    false

      Settings.define :github_password,
                      env_var:     'BS_GITHUB_PASSWORD',
                      description: 'Github password to use for authentication',
                      flag:        'p',
                      required:    false

    end

    def define_github_repo
      Settings.define :owner,
                      env_var:     'BS_OWNER',
                      description: 'Github repository owner/username',
                      flag:        'o',
                      required:     true

      Settings.define :repo,
                      env_var:     'BS_REPO',
                      description: 'Github repository name',
                      flag:        'r',
                      required:    true

      Settings.define :ref,
                      env_var:     'BS_REF',
                      description: 'Commit sha, branch or tag '\
                                   ' (or partial sha for local repo)',
                      flag:        's',
                      required:    false

      Settings.define :limit,
                      type:        Integer,
                      env_var:     'BS_LIMIT',
                      default:     1,
                      flag:        'c',
                      required:    false,
                      description: 'Number of commits to fetch status from,'\
                                   'up to sha'

    end

    def define_config_file_settings
      config_lambda = -> { Settings.read(Settings.config) if Settings.config }
      Settings.define :config,
                      type:        :filename,
                      env_var:     'BS_CONFIG',
                      description: 'Custom config file',
                      flag:        'f',
                      required:    false,
                      finally:     config_lambda

    end
  end
end
