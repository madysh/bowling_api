class ApplicationController < ActionController::Base
  private

  def api_agent
    @api_agent ||= ApiAgent.new(root_url)
  end
end
