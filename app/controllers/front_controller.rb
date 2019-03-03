class FrontController < ActionController::Base
    skip_before_action :verify_authenticity_token

    def redirect
        render file: Rails.root.join('public/index')
    end
  end