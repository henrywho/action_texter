module ActionTexter
  class TwilioDelivery
    attr_reader :client

    def initialize(config = {})
      sid = config[:account_sid]
      token = config[:account_token]
      raise ArgumentError, "you must specify config.action_texter.twilio_settings to contain a :account_sid" unless sid
      raise ArgumentError, "you must specify config.action_texter.twilio_settings to contain a :account_token" unless token
      @client = Twilio::REST::Client.new(sid, token)
    end

    def deliver(message)
      client.account.messages.create(
        :from => message.from,
        :to => message.to,
        :body => message.body.strip
      )
    end
  end
end
