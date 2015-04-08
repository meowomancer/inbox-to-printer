# Inbox To Printer
Inbox To Printer is a simple Ruby utility to help accomplish the task of automatically printing recieved e-mails. This project was started to replace the functionality of an extremly buggy piece of software used at Chemeketa Community College. Currently this system can connect to any IMAP server with TLS support.

Currently Inbox to Printer checks an inbox, prints all email, and deletes the email after printing. E-Mails that are not printed because of the blacklist will be deleted as well. 

##Current features
* Ability to check multiple email inboxes and print all emails from each inbox. Each inbox:
 * will only print email from senders on a whitelist. To whitelist all senders simply whitelist "." (wildcard)
 * will not print emails with terms in their subject lines from the black list
 * will print only to the specified printer

##Requirements
* Linux based host system
* Ruby v1.8.7 - v2.1
* [Bundler](http://bundler.io/)
* Printer installed to the server/system and connected to the [lp system](http://www.cups.org/documentation.php/options.html)

##Setup
* Ensure that your system is running a version of Ruby between v1.8.7 and v2.1
* Ensure that Bundler is installed on your system
* Clone this repo to your system
* Open the cloned directory and run "bundle" to install all required gems
* Setup the conf.rb file
* Run inbox-to-printer.rb

##Configuration Options
All configuration takes place inside of conf.rb. Current configurables are:
* **$delay** - (int) The time between checking inboxes in seconds
* **@inboxes** - This array contains hash tables for each inbox that you would like to check. Each hash table has the following key value pairs:
 * **:host** - (string) The address of the IMAP server
 * **:port** - (string) The TLS port of the IMAP server
 * **:user** - (string) The username of the email inbox
 * **:pass** - (string) The password of the email inbox
 * **:printer** - (string) The name of the printer, as reported by 'lpstat -p', to print email from this account to
 * **:valid_senders** - (string, arr) An array containing regex compatible strings to match againt from addresses. Only emails from addresses matching this string. If both valid\_senders and invalid\_subjects are empty, then all email will be printed.
 * **:invalid_subjects** - (string, arr) An array containing regex compatible strings to match against subjects. E-mails with subjects matching any of these expres. If both valid\_senders and invalid\_subjects are empty, then all email will be printed.

##Example configuration
    $delay = 15
    @inboxes = [
        {
            :host  => "imap.example.com",
            :port => "993",
            :user => "user01",
            :pass => "somepassword",
            :printer => "HP-Color-LaserJet-3800",
            :valid_senders => ["emailaccount@example.com","@gmail.com$"],
            :invalid_subject => ["drugs", ".iagra", "free"]
        },
        {
            :host  => "imap.example.com",
            :port => "993",
            :user => "user02",
            :pass => "somepassword",
            :printer => "HP-Color-LaserJet-3800",
            :valid_senders => ["ourschool.edu$"],
            :invalid_subject => []
        }
    ]


##Upcoming features
* Google OAUTH for gmail accounts
* Non TLS server support
* Multi-threading to check inboxes simultaneously
