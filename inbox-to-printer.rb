require 'net/imap'
require 'mail'
require 'wicked_pdf'
require './conf.rb'

while true
	@inboxes.each do |mailserver|
		#Create IMAP object and connect to remote server
		p "Attempting to connect to "+mailserver[:host]+":"+mailserver[:port]
		imap = Net::IMAP.new(mailserver[:host],{:port=>mailserver[:port],:ssl=>true})

		#Authenticate against the remote server
		p "Attempting to authenticate user: "+mailserver[:user]
		imap.login(mailserver[:user], mailserver[:pass])

		#Select the inbox
		imap.select("INBOX")

		#Get number of emails in inbox
		data = imap.status("Inbox", ["MESSAGES"]);

		#Process each email
		if data["MESSAGES"] >= 1
			for msg_id in 1..data["MESSAGES"]
				msg = imap.fetch(msg_id, 'RFC822')[0].attr['RFC822']
				mail = Mail.read_from_string msg

				#Convert email to PDF
				p "Preparing to print email"
				mail_body = mail.html_part.body.to_s
				pdf = WickedPdf.new.pdf_from_string(mail_body)
				file_path = Dir.pwd+"/out.pdf"
				File.open(file_path, 'wb')do |file|
					file << pdf
				end

				p "Attempting to print email..."
				if system("lpr "+file_path) 
					p 'Email printed successfully'
					imap.store(msg_id, "+FLAGS", [:Deleted]);
				else
					p 'Coult not print email. Will try again next time.'
				end
			end	
		else
			p "No new messages"
		end	

		#Close connection
		imap.close()
	
		sleep($delay)
	end
end
