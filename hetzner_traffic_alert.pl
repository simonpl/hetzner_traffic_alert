#!/usr/bin/perl -w

#
#    hetzner_traffic_alert informs you about how much traffic you have left at Hetzner.
#    Copyright (C) 2013 Simon Plasger
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

use JSON::Any;
use LWP;
use POSIX qw/strftime/;
use warnings;
use strict;
use traffic_alert_configuration;
my $browser = LWP::UserAgent->new;
$browser->agent($traffic_alert_configuration::agent);
$browser->credentials(
    $traffic_alert_configuration::server.":".$traffic_alert_configuration::port,
    $traffic_alert_configuration::realm,
    $traffic_alert_configuration::user,
    $traffic_alert_configuration::password
);
my $response = $browser->post($traffic_alert_configuration::url,
    [
        "type" => "month",
        "from" => strftime("%Y-%m", localtime)."-01",
        "to" => strftime("%Y-%m", localtime)."-31",
        "ip[]" => $traffic_alert_configuration::ip
    ],
);
my $j = JSON::Any->new;
my $obj = $j->jsonToObj($response->content);
print "Outgoing traffic this month so far: ".$obj->{"traffic"}->{"data"}->{"176.9.101.132"}{"out"}." GB\n";
my $left = $traffic_alert_configuration::allowed - $obj->{"traffic"}->{"data"}->{"176.9.101.132"}{"out"};
print "You have ".$left." GB of outgoing traffic remaining this month.";
print "\n";
if($left < $traffic_alert_configuration::warn_threshold * $traffic_alert_configuration::allowed * 0.01)
{
    print "Warning: You have less than ".$traffic_alert_configuration::warn_threshold."% of your monthly allowd traffic amount left!\n";
    if($traffic_alert_configuration::trigger)
    {
        system($traffic_alert_configuration::triggercom);
    }
}
