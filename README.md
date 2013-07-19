Hetzner_traffic_alert
=====================

Setup
-----

Note: The tool was tested with Perl v5.14.2. Other versions may cause problems or not work at all.

1. Get a username and a password you can use with the Hetzner API. See http://wiki.hetzner.de/index.php/Robot_Webservice/en for further information about the Hetzner API.

2. Copy the file `traffic_alert_configuration.pm.dist` to `traffic_alert_configuration.pm`.

3. Adjust `traffic_alert_configuration.pm` to the values that fit with your setup and with your requirements.

4. Mark `hetzner_traffic_alert.pl` as executable (`chmod +x hetzner_traffic_alert.pl`).

Usage
-----

Execute `hetzner_traffic_alert.pl`.

Requirements
------------

* Perl 5 (tested with Perl v5.14.2)
* The Perl-module JSON::Any
* The Perl-module POSIX
* The Perl-module LWP

License
-------

hetzner_traffic_alert informs you about how much traffic you have left at Hetzner.
Copyright (C) 2013 Simon Plasger

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

See COPYING for details.
