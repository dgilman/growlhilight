# Maybe this will save you a second or two!  
# Get Mac::Growl with
# perl -MCPAN -e 'install Mac::Growl'
#
# Shamelessly ripped from http://www.leemhuis.info/files/fnotify/fnotify
# Doesn't work with Unicode.  Took some naive stabs at it a while back (without knowing Perl) with no success.  Cluelessness reigns.

use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '0.0.3';
%IRSSI = (
	authors     => 'dgilman',
	contact     => 'richardus on freenode',
	name        => 'growlhilight',
	description => 'Send a growl notification in case of hilight',
	url         => '',
	license     => 'GNU General Public License',
	changed     => '$Date: 2010-09-13 12:00:00 +0100 (Mon, 13 September 2007) $'
);

#--------------------------------------------------------------------
# Private message parsing
#--------------------------------------------------------------------

use Mac::Growl;

my(@notifications) = ("hilight","pm");
Mac::Growl::RegisterNotifications("irssi", \@notifications, \@notifications, "Terminal.app");

sub priv_msg {
	my ($server,$msg,$nick,$address,$target) = @_;
	Mac::Growl::PostNotification("irssi", "pm", "New message from ".$nick, $msg, 1);
	#iirc the last arg (1) makes it float forever
}

#--------------------------------------------------------------------
# Printing hilights
#--------------------------------------------------------------------

sub hilight {
    my ($dest, $text, $stripped) = @_;
    if ($dest->{level} & MSGLEVEL_HILIGHT) {
		Mac::Growl::PostNotification("irssi", "hilight", "Hilight", $stripped, 1);
    }
}

#--------------------------------------------------------------------
# Irssi::signal_add_last / Irssi::command_bind
#--------------------------------------------------------------------

Irssi::signal_add_last("message private", "priv_msg");
Irssi::signal_add_last("print text", "hilight");
