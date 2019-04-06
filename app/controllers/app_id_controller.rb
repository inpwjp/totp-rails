class AppIdController < ApplicationController
  def app_id

    @urls = Settings.common.my_domains.map { |domain| ["https://" , Settings.common.domain].join }.compact
    app_id = { 
      trustedFacets: 
      [

        {
          version:
          {
            major: 1,
            minor: 0
          },
          ids: @urls
        }
      ]
    }
    respond_to do |format|
      format.json { render json: app_id }
    end
  end
end
