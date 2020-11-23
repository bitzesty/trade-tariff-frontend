class FrontendMailer < ActionMailer::Base
  default from: TradeTariffFrontend.from_email,
          to: TradeTariffFrontend.to_email

  def new_feedback(message, name = nil, email = nil)
    @message = message
    @name = name.presence
    @email = email.presence || TradeTariffFrontend.from_email

    mail subject: "Trade Tariff Feedback",
         reply_to: @email
  end
end
