# 2018_Group_14
158.383 Information Technology Project

## Description
OpenStreetMap (OSM) is a collaborative project to create a free editable map of the world. Rather than the map itself, the data generated by the project is considered its primary output. The creation and growth of OSM has been motivated by restrictions on use or availability of map information across much of the world, and the advent of inexpensive portable satellite navigation devices. OSM is considered a prominent example of volunteered geographic information.

## Task One

### Usage

#### System required
AWS Instance - .NET Core 2.1 with Ubuntu Server 18.04 - Version 1.0  
* Our system does not require .NET support. So, although this system has prebuilt .NET Core, it still can be seen as a blank instance. We just need Ubuntu Server 18.04

#### Sercurity groups
> HTTP 			TCP 	80 		0.0.0.0/0  
> PostgreSQL 	TCP		5432	0.0.0.0/0  
> SSH			TCP		22		0.0.0.0/0  
> http 			TCP		443		0.0.0.0/0  

To install OpenStreetMap by default settings, run:  
> curl https://raw.githubusercontent.com/Damming/2018_Group_14/master/Ass1_Task1/set_up_OpenStreetMap.sh?token=AZvMHPvwl7Ghtf236MWGJ3gp8iN3W_Ywks5be6vzwA%3D%3D | bash

To install OpenStreetMap with your own password, run:  
> bash <(curl -s https://raw.githubusercontent.com/Damming/2018_Group_14/master/Ass1_Task1/set_up_OpenStreetMap_with_password.sh?token=AZvMHP_aR7L5HzGtqENV8DRs57KyngPzks5bhIBYwA%3D%3D) your_password

For example, if your password is 12345678, then run:  
> bash <(curl -s https://raw.githubusercontent.com/Damming/2018_Group_14/master/Ass1_Task1/set_up_OpenStreetMap_with_password.sh?token=AZvMHP_aR7L5HzGtqENV8DRs57KyngPzks5bhIBYwA%3D%3D) 12345678

### Test

OpenStreetMap server is ready when you see these lines  
> renderd[12266]: Starting stats thread  
> renderd[12266]: Using web mercator projection settings  
> renderd[12266]: Using web mercator projection settings  
> renderd[12266]: Using web mercator projection settings  
> renderd[12266]: Using web mercator projection settings  

Then open http://actual_ip/osm_tiles/0/0/0.png or http://autual_ip/ol.html  
If you want to see if the password is correctly set, press Control+C to interupt the server process, then enter 'cd ~' to go back to the user root directory, then enter 'vi .pgpass'. Then you will see your password after the last colon.


## Task Two

### Usage

### Test
