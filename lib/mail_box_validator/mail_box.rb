require 'net/telnet'

module MailBoxValidator
  class MailBox
    include Singleton

    def valid?(mail_address)
      domain = mail_address.slice(/@(.*)/, 1)
      mx = mail_exchanger_record_for(domain)
      mx.present? && mx.all?(&return_valid?(mail_address))
    end

    private

    def return_valid?(mail_address)
      Proc.new do |host|
        response_for(mail_address, host).match(/^2\d{2}/).present?
      end
    end

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
