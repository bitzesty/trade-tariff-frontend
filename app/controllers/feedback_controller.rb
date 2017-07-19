class FeedbackController < ApplicationController
  layout "pages"

  def new
  end

  def create
    FrontendMailer.new_feedback(params[:message], params[:name], params[:email]).deliver_now

    if request.xhr?
      head :ok
    else
      redirect_to action: :thanks
    end
  end

  def thanks
  end
end
