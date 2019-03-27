# Docker Image for Low-cost HD surveillance Camera Module on Raspberry Pi 3

This runs a motion-detecting camera connected to a Raspberry Pi. The videos are saved into a folder on the host machine (i.e. outside of the Docker container), and can be streamed over the network too.

## Pre-requisite:

### Hardware

- Raspberry Pi 3 ( You can order it from Amazon in case you are in India for 2590 INR)
- Micro-SD card reader ( I got it from here )
- Any Windows/Linux/MacOS
- HDMI cable ( I used the HDMI cable of my plasma TV)
- Internet Connectivity(WiFi/Broadband/Tethering using Mobile) – to download Docker 18.09.0 package
- Keyboard & mouse connected to Pi’s USB ports

### Software

- SDFormatter - to Format SD card
- Win32DiskImager - To Flash Raspbian OS onto SD card


## Steps to Install Docker 18.09.0 on Pi Box

- Format the microSD card using SD Formatter as shown below:</li></ol>
-  Download Raspbian OS from <a href="https://downloads.raspberrypi.org/raspbian_full_latest">here</a> and use Win32 imager(in case you are on Windows OS  running on your laptop) to burn it on microSD card.</p>
- Insert the microSD card into your Pi box. Now connect the HDMI cable  from one end of Pi’s HDMI slot to your TV or display unit and mobile charger(recommended 5.1V@1.5A)
- Let the Raspbian OS boot up on your Pi box. It takes hardly 2 minutes for OS to come up.</p>
- Configure WiFi via GUI. All you need is to input the right password for your WiFi.</p>
- The default username is "pi" and password is "raspberry". You can use this credentials to login into the Pi system.</p>
- You can use "FindPI" Android application to search for IP address if you don't want to look out for Keyboard or mouse to search for the right IP address.</p>


## Enable SSH to perform remote login</h3>

To login via your laptop, you need to allow SSH service running. You can verify IP address command via ifconfig command.

```
[Captains-Bay]🚩 >  ssh pi@192.168.1.5
pi@192.168.1.5's password:
Linux raspberrypi 4.14.98-v7+ #1200 SMP Tue Feb 12 20:27:48 GMT 2019 armv7l

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Tue Feb 26 12:30:00 2019 from 192.168.1.4
pi@raspberrypi:~ $ sudo su
root@raspberrypi:/home/pi# cd

```
## Verifying Raspbian OS Version

```
root@raspberrypi:~# cat /etc/os-release
PRETTY_NAME="Raspbian GNU/Linux 9 (stretch)"
NAME="Raspbian GNU/Linux"
VERSION_ID="9"
VERSION="9 (stretch)"
ID=raspbian
ID_LIKE=debian
HOME_URL="http://www.raspbian.org/"
SUPPORT_URL="http://www.raspbian.org/RaspbianForums"
BUG_REPORT_URL="http://www.raspbian.org/RaspbianBugs"
root@raspberrypi:~#
</code></pre>
```

```
root@raspberrypi:~# curl -sSL https://get.docker.com/ | sh
# Executing docker install script, commit: 40b1b76
+ sh -c apt-get update -qq >/dev/null
+ sh -c apt-get install -y -qq apt-transport-https ca-certificates curl >/dev/null
+ sh -c curl -fsSL "https://download.docker.com/linux/raspbian/gpg" | apt-key add -qq - >/dev/null
Warning: apt-key output should not be parsed (stdout is not a terminal)
+ sh -c echo "deb [arch=armhf] https://download.docker.com/linux/raspbian stretch edge" > /etc/apt/sources.list.d/docker.list
+ sh -c apt-get update -qq >/dev/null
+ sh -c apt-get install -y -qq --no-install-recommends docker-ce >/dev/null
+ sh -c docker version
Client:
 Version:           18.09.0
 API version:       1.39
 Go version:        go1.10.4
 Git commit:        4d60db4
 Built:             Wed Nov  7 00:57:21 2018
 OS/Arch:           linux/arm
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          18.09.0
  API version:      1.39 (minimum version 1.12)
  Go version:       go1.10.4
  Git commit:       4d60db4
  Built:            Wed Nov  7 00:17:57 2018
  OS/Arch:          linux/arm
  Experimental:     false
If you would like to use Docker as a non-root user, you should now consider
adding your user to the "docker" group with something like:

  sudo usermod -aG docker your-user

Remember that you will have to log out and back in for this to take effect!

WARNING: Adding a user to the "docker" group will grant the ability to run
         containers which can be used to obtain root privileges on the
         docker host.
         Refer to https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface
         for more information.

** DOCKER ENGINE - ENTERPRISE **

If you’re ready for production workloads, Docker Engine - Enterprise also includes:

  * SLA-backed technical support
  * Extended lifecycle maintenance policy for patches and hotfixes
  * Access to certified ecosystem content

** Learn more at https://dockr.ly/engine2 **

ACTIVATE your own engine to Docker Engine - Enterprise using:

  sudo docker engine activate
```

```
root@raspberrypi:~# docker version
Client:
 Version:           18.09.0
 API version:       1.39
 Go version:        go1.10.4
 Git commit:        4d60db4
 Built:             Wed Nov  7 00:57:21 2018
 OS/Arch:           linux/arm
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          18.09.0
  API version:      1.39 (minimum version 1.12)
  Go version:       go1.10.4
  Git commit:       4d60db4
  Built:            Wed Nov  7 00:17:57 2018
  OS/Arch:          linux/arm
  Experimental:     false
root@raspberrypi:~#
```

## Enabling Camera Interfacing

```
raspi-config
```

Select Interfacing option to enable camera.

## Load the Broadcom Module

```
sudo modprobe bcm2835-v4l2
```

## Building CCTV Cam Docker Image

```
docker build . -t collabnix/docker-cctv-raspbi
```

## Bringing up Docker Container

Before you execute run.sh script, you will need the camera module driver by running the below script:

```
sudo modprobe bcm2835-v4l2
```

Run the below command to bring up Docker container

```
./run.sh
```

This will connect to a webcam via /dev/video0, create and mount the video directory in a directory called videos within the current cdirectory, and start running as a daemon.

