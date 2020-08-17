class PagesController < ApplicationController
  include StaticPages
  around_action :cache_static_page, only: %i[show]

  def home
    render template: "pages/home"
  end

  def scribble
    render template: "pages/scribble"
  end

  def privacy_policy
    policy_id = params[:id]

    @privacy_policy = if policy_id
                        GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_privacy_policy(policy_id)
                      else
                        GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
                      end

    render template: "pages/privacy_policy"
  end

  def accessibility
    render template: "pages/accessibility"
  end

  def show
    render template: content_template(params[:page]), layout: "layouts/application"
  rescue ActionView::MissingTemplate
    respond_to do |format|
      format.html do
        render \
          template: "errors/not_found",
          status: :not_found
      end

      format.all do
        render status: :not_found, body: nil
      end
    end
  end

  def showblank
    render template: "content/#{params[:page]}", layout: "layouts/blank"
  rescue ActionView::MissingTemplate
    respond_to do |format|
      format.html do
        render \
          template: "errors/not_found",
          status: :not_found
      end

      format.all do
        render status: :not_found, body: nil
      end
    end
  end

private

  def content_template(requested_page)
    "content/#{requested_page}"
  end
end
