#####
# Inbox To Printer configuration file. Details regarding configuration can be
# found at https://github.com/zyamada/inbox-to-printer/wiki/Detailed-Configuration
#####

# Can be set to either "all", "error", "none". If set to "all", all activity will
# be written to the log file. If set to "error", only errors will be written to the
# log file. If set to "none", nothing will be written to the log file
$log_level = "error"

# If this value is true, then the program will slowly decrease the amount of
# delay between checking inboxes until there is no delay between going from
# one inbox to another. If an error is encoutered the delay is reset to its
# default value. 
$speedup = true

# The amount of time between
$delay = 15 

#Array containing all configued inboxes
@inboxes = [
	{
		:host  	=> "",		#IP or Hostname of IMAP server
		:port 	=> "",		#Port of the IMAP server
		:user 	=> "",		#Username of IMAP account
		:pass 	=> "",		#Password of IMAP account
		:printer => "",		#CUPS name of printer to print to
		:valid_senders => [],	#Array of valid senders (RegEx OK)
		:invalid_subjects => []	#Array of invalid subject terms (Regex OK)
	},

	{
		:host  	=> "",
		:port 	=> "",
		:user 	=> "",
		:pass 	=> "",
		:printer => "",
		:valid_senders => [],
		:invalid_subjects => []
	},

]
