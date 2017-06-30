class FrontendMailer < ActionMailer::Base
  default from: TradeTariffFrontend.from_email,
          to: TradeTariffFrontend.to_email

  def new_feedback(message, name = nil, email = nil)
    @message = message
    @name = name
    @email = email

    mail subject: "New Feedback"
  end
end
