# encoding: utf-8

module BS
  module Base
    class Creator

      attr_reader :gravatar_id
      attr_reader :avatar_url
      attr_reader :url
      attr_reader :id
      attr_reader :login

      def initialize(attr)
        @gravatar_id = attr[:gravatar_id]
        @avatar_url  = attr[:avatar_url]
        @url         = attr[:url]
        @id          = attr[:id]
        @login       = attr[:login]
      end
    end
  end
end
