# encoding: utf-8

module BS
  module Base
    module Github
      class CommitBuilder

        attr_accessor :response

        def initialize(response)
          @response = response
        end

        def sha
          response[:sha]
        end

        def commit
          response[:commit]
        end

        def message
          commit[:message] if commit
        end

        def url
          response[:html_url]
        end

        def commiter
          UserBuilder.new(commit[:committer],  response[:committer]).commiter
        end

        def author
          UserBuilder.new(commit[:author],  response[:author]).author
        end

        private

        class UserBuilder

          attr_accessor :name, :email, :login, :id, :html_url, :avatar_url

          def initialize(commit, user)
            if commit
              @name  = commit[:name]
              @email = commit[:email]
            end

            if user
              @login      = user[:login]
              @id         = user[:id]
              @html_url   = user[:html_url]
              @avatar_url = user[:avatar_url]
            end
          end

          def commiter
            Commiter.new(avatar_url: avatar_url,
                         url:        html_url,
                         id:         id,
                         login:      login,
                         name:       name,
                         email:      email)
          end

          def author
            Author.new(avatar_url: avatar_url,
                       url:        html_url,
                       id:         id,
                       login:      login,
                       name:       name,
                       email:      email)
          end
        end
      end
    end
  end
end
