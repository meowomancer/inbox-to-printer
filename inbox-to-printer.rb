#!/usr/bin/ruby

require 'net/imap'
require 'optparse'
require 'mail'
require 'wicked_pdf'
require './conf.rb'

#Read and parse CLI arguments
options = {}
OptionParser.new do |opts|
	opts.banner = "Usage: inbox-to-mail.rb [options]"
	opts.on("-v", "--verbose", "Run verbosely") do |v|
		options[:v] = true
	end
end.parse!

#Helper function for logging to STD (and eventually file)
def log(msg, level, options)
	time = Time.new	
	output = time.strftime("%b  %d %H:%M:%S")+" "+msg+"\n"

	#Log to console if -v flag is in use
	if options[:v] 
		if msg == ""
			if options [:v] then print "\n" end
		else
			print output
		end
	end

		
	if $log_level != "none" && msg != ""
		log_file = open("app.log", 'a')

		if $log_level == "all" ||
		   $log_level == level ||
		   level == "system" 
			log_file.write output
		end 

		log_file.close
	end
end

if $speedup
	default_delay = $delay
	$delay += 1
end

log "Inbox to Printer Started", "system", options

while true
	@inboxes.each do |mailserver|
		begin
			#Create IMAP object and connect to remote server
			log "Attempting to connect to #{mailserver[:host]}:#{mailserver[:port]}", "info", options
			imap = Net::IMAP.new(mailserver[:host],{:port=>mailserver[:port],:ssl=>true})

			#Authenticate against the remote server
			log "Attempting to authenticate user: #{mailserver[:user]}", "info", options
			imap.login(mailserver[:user], mailserver[:pass])

			#Select the inbox
			imap.select("INBOX")

			#Get number of emails in inbox
			data = imap.status("Inbox", ["MESSAGES"]);

			#Process each email
			if data["MESSAGES"] >= 1
				for msg_id in 1..data["MESSAGES"]
					#Get sender information
					envelope  = imap.fetch(msg_id, 'ENVELOPE')[0].attr['ENVELOPE']
					sender = "#{envelope.from[0].mailbox}@#{envelope.from[0].host}"
					log "Checking #{envelope.subject} from #{sender}", "info", options

					#Check if sender is whitelisted
					valid = false
					mailserver[:valid_senders].each do |regex_addr| 				
						sender =~ /#{regex_addr}/ ? valid = true : false 
					end

					#Check if subject term is blacklisted
					mailserver[:invalid_subjects].each do |regex_sub|
						envelope.subject =~ /#{regex_sub}/ ? valid = false : false;
					end

					if mailserver[:valid_senders].length == 0 && mailserver[:invalid_subjects].length == 0
						valid = true
					end

					#If sender and subject is valid, proceed to print
					if valid
						
						#Grab the body of the email
						msg = imap.fetch(msg_id, 'RFC822')[0].attr['RFC822']
						mail = Mail.read_from_string msg

						#Convert email to PDF
						log "Preparing to print email", "info", options
						mail_body = mail.html_part.body.to_s
						pdf = WickedPdf.new.pdf_from_string(mail_body)
						file_path = Dir.pwd+"/out.pdf"
						File.open(file_path, 'wb')do |file|
							file << pdf
						end

						#Print email
						log "Attempting to print email...", "info", options
						if system("lp -d "+mailserver[:printer]+" "+file_path) 
							log 'Email printed successfully', "info", options
							imap.store(msg_id, "+FLAGS", [:Deleted]);
						else
							log 'Could not print email. Will try again next time.', "error", options
						end
					else
						log "E-Mail from #{sender} with subject \"#{envelope.subject}\" failed to match whitelist rules, or matched blacklist rules", "error", options
						imap.store(msg_id, "+FLAGS", [:Deleted]);
					end
				end	
			else
				log "No new messages", "info", options
			end	

			#Close connection
			imap.close()
		
			#Disconnect from server
			imap.disconnect()
		
		rescue Net::IMAP::NoResponseError
			log "Could not log into IMAP server", "error", options
			log "", "info", options
			$delay = default_delay	
		rescue Errno::ECONNREFUSED
			log "Could not connect to IMAP server", "error", options
			log "", "info", options
			$delay = default_delay
		else
			
			#If inbox was sucessfully checked and the user opts to use slow start we reduce the delay time
			if $speedup && $delay > 0 then $delay -= 1 end	
		end
		sleep($delay)
	end
end
