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

use JSON;
use LWP;
use HTTP::Request;
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
); # Initialize user agent with options defined in configuration
my $request = new HTTP::Request('POST',$traffic_alert_configuration::url);
$request->content_type("application/x-www-form-urlencoded"); # Initialize Request
my $content = 'type=month&from='.strftime("%Y-%m", localtime).'-01&to='.strftime("%Y-%m", localtime).'-31';
foreach(@traffic_alert_configuration::ips)
{
    $content .= '&ip[]='.$_;
}
foreach(@traffic_alert_configuration::subnets)
{
    $content .= '&subnet[]='.$_;
}
$request->content($content); # Put IPs and subnets into the POST request
my $response = $browser->request($request); # Execute the POST request
my $obj = JSON->new->utf8->decode($response->content); # Get the JSON Data as an object
my $sumtraffic = 0;
my $key;
while($key = each $obj->{"traffic"}->{"data"}) # Count the outgoing traffic
{
    $sumtraffic += $obj->{"traffic"}->{"data"}->{$key}->{"out"};
}
print "Outgoing traffic this month so far: ".$sumtraffic." GB\n";
my $left = $traffic_alert_configuration::allowed - $sumtraffic; # Calculate how much traffic is left for this month
print "You have ".$left." GB of outgoing traffic remaining this month.";
print "\n";
if($left < $traffic_alert_configuration::warn_threshold * $traffic_alert_configuration::allowed * 0.01) # Is the threshold reached?
{
    print "Warning: You have less than ".$traffic_alert_configuration::warn_threshold."% of your monthly allowd traffic amount left!\n";
    if($traffic_alert_configuration::trigger) # Should a command be triggered?
    {
        system($traffic_alert_configuration::triggercom);
    }
}
