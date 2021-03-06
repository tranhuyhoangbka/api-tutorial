module Authenticable
  module ClassMethods

  end

  module InstanceMethods
    # Devise methods overwrites
    def current_user
      @current_user ||= User.find_by_auth_token request.headers['Authorization']
    end

    def authenticate_with_token!
      render json: {errors: "Not authenticated"}, status: :unauthorized unless user_signed_in?
    end

    def user_signed_in?
      current_user.present?
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
