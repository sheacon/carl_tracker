# airtag tracker

This is a fork of https://github.com/icepick3000/AirtagAlex


## AirtagAlex
Get all metadata from the Airtags (lat, lon, geocoding information, precision range, battery status).
This script is a very basic script to write the data to a CSV for processing in Excel or Numbers. I am sure many rewrites will be done by other folks but anyone with some programming experience will have a good starting point with this script. 

Steps to get this script to work;

Create a folder on your desktop called <i>Airtags</i> (case sensitive)<BR>
Install brew (<A HREF="wwww.brew.sh" TARGET=new>www.brew.sh</A>)<BR>
  Install the jq utility (<i>brew install jq</I>)<BR>
  Change the directory to the newly created Airtags folder by typing <i>cd ~/Desktop/Airtags</I><BR>
  Clone this repo by typing <i>git clone https://github.com/icepick3000/AirtagAlex.git</I><BR>
  Go into the repo directory by typing <i>cd ~/Desktop/Airtags/AirtagAlex</I><BR>
  Make the shell file executable by typing <I>chmod 700 AirtagAlex.sh</I><BR>
  
  You can start the script by typing;
  
  <B><I>./AirtagAlex.sh</I></B>
