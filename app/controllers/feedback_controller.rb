class FeedbackController < ApplicationController
  layout "pages"

  def new
  end

  def create
    FrontendMailer.new_feedback(params[:message], params[:name], params[:email]).deliver_now

    respond_to do |format|
      format.html { redirect_to action: :thanks }
      format.json { head :ok }
    end
  end

  def thanks
  end
end
