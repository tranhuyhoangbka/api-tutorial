module Authenticable
  module ClassMethods

  end

  module InstanceMethods
    # Devise methods overwrites
    def current_user
      @current_user ||= User.find_by_auth_token request.headers['Authorization']
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
