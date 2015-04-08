# Inbox To Printer
Inbox To Printer is a simple Ruby utility to help accomplish the task of automatically printing recieved e-mails. This project was started to replace the functionality of an extremly buggy piece of software used at Chemeketa Community College. Currently this system can connect to any IMAP server with TLS support.

Currently Inbox to Printer checks an inbox, prints all email, and deletes the email after printing. E-Mails that are not printed because of the blacklist will be deleted as well. 

##Usage
ruby inbox-to-printer.rb [options]

* Options
 * --verbose, -v - Write log output to STDOUT

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
[Detailed install and setup information can be found here.](https://github.com/zyamada/inbox-to-printer/wiki/Detailed-Install)

* Ensure that your system has all of the following installed:
 * Ruby (version >= 1.8.7 && <= 2.1)
 * Bundler
 * cups
 * cups-client
 * make 
 * build-essential
 * zlibc
 * zlib-dev
* Clone this repo to your system
* Open the cloned directory and run "bundle install" to install all required gems
* Edit the conf.rb file to fit your needs
* Run inbox-to-printer.rb

##Configuration Options
[Detailed configuration options information can be found here.](https://github.com/zyamada/inbox-to-printer/wiki/Detailed-Configuration)

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
