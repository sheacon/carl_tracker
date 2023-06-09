# carl_tracker

This project contains a bash script that collects Apple AirTag data on a regular interval and a Jupyter Notebook for creating maps from that data. I developed this to track my outdoor cat [Carl](https://www.instagram.com/carl37209/).

Instructions:
- `Find My` app must be running to refresh AirTag locations
- In Terminal, navigate to project directory and run script `./run_tracking.sh`
  - Include an optional argument to change recording frequency in seconds (default 60), e.g. `./run_tracking.sh 30`
  - Note, you need to change permissions for the script to be executable and give Terminal full disk access in settings (or run sudo)
- While running, the script prevents system sleep 

Dependencies:
- [`jq`](https://formulae.brew.sh/formula/jq)

Credit:
This project builds on work by [AirtagAlex](https://github.com/icepick3000/AirtagAlex).

Disclaimer:
Tracking adheres to [Apple's privacy standards](https://www.apple.com/newsroom/2022/02/an-update-on-airtag-and-unwanted-tracking/) and only user-owned AirTags can be tracked.

![carl](images/carl.jpg)

![heatmap](images/heatmap.jpg) ![tracemap](images/tracemap.jpg)


