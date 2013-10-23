# encoding: utf-8

module BS
  module Base
    class User

      attr_reader :avatar_url
      attr_reader :url
      attr_reader :id
      attr_reader :login
      attr_reader :name
      attr_reader :email

      def initialize(attr)
        @avatar_url = attr[:avatar_url]
        @url        = attr[:url]
        @id         = attr[:id]
        @login      = attr[:login]
        @name       = attr[:name]
        @email      = attr[:email]
      end

    end
    Commiter = User
    Author = User
  end
end
