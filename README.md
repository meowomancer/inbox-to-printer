# Inbox To Printer
Inbox To Printer is a simple ruby utility to help accomplish the task of automatically printing recieved e-mails. This project was started to replace the functionality of an extremly buggy piece of software used at Chemeketa Community Co
llege. Currently this system can connect to any IMAP server with TLS support.

Currently Inbox to Printer checks an inbox, prints all email, and deletes the email after printing. 

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
* **$delay** - The time between checking inboxes in seconds
* **@inboxes** - This array contains hash tables for each inbox that you would like to check. Each hash table has the following key value pairs:
 * **:host** - The address of the IMAP server
 * **:port** - The TLS port of the IMAP server
 * **:user** - The username of the email inbox
 * **:pass** - The password of the email inbox

##Example configuration
    $delay = 15
    @inboxes = [
        {
            :host  => "imap.example.com",
            :port => "993",
            :user => "user01",
            :pass => "somepassword",
        },
        {
            :host  => "imap.example.com",
            :port => "993",
            :user => "user02",
            :pass => "somepassword",
        }
    ]

##Current features
Ability to check an email inbox and print all email

##Upcoming features
* Google OAUTH for gmail accounts
* Non TLS server support
* Specify seperate printers for seperate inboxes
* Whitelist for email address

