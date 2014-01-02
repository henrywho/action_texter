module ActionTexter
  class TwilioDelivery
    attr_reader :account

    def initialize(config = {})
      if config[:sid] || config[:token]
        # use old config parameters
        sid = config[:sid]
        token = config[:token]
        subaccount = config[:subaccount]
        raise ArgumentError, "you must specify config.action_texter.twilio_settings to contain a :sid" unless sid
        raise ArgumentError, "you must specify config.action_texter.twilio_settings to contain a :token" unless token
        client = Twilio::REST::Client.new(sid, token)
        if subaccount
          @account = client.accounts.find(subaccount)
        else
          @account = client.account
        end
      else
        # use new config parameters
        sid = config[:account_sid]
        token = config[:account_token]
        raise ArgumentError, "you must specify config.action_texter.twilio_settings to contain a :account_sid" unless sid
        raise ArgumentError, "you must specify config.action_texter.twilio_settings to contain a :account_token" unless token
        @account = Twilio::REST::Client.new(sid, token).account
      end
    end

    def deliver(message)
      account.messages.create(
        :from => message.from,
        :to => message.to,
        :body => message.body.strip
      )
    end
  end
end
