require 'net/telnet'

module MailBoxValidator
  class MailBox
    include Singleton

    def valid?(mail_address)
      domain = mail_address.slice(/@(.*)/, 1)
      mx = mail_exchanger_record_for(domain)
      return false unless mx.present?
      mx.all? {|host| response_for(mail_address, host).match(/^2\d{2}/).present? }
    end

    private

    def response_for(mail_address, host)
      response = ''
      telnet = Net::Telnet::new(
        'Host' => host,
        'Port' => 25,
        'Telnetmode' => true,
        'Prompt' => /\d{3}.*/n
        )
      telnet.cmd('helo hi')
      telnet.cmd("mail from: <#{mail_address}>")
      telnet.cmd("rcpt to: <#{mail_address}>") { |c| response = c }
      telnet.close
      response
    end

    def mail_exchanger_record_for(domain)
      Resolv::DNS.open do |dns|
        dns.getresources(domain, Resolv::DNS::Resource::IN::MX).map { |r| r.exchange.to_s }
      end
    end
  end
end