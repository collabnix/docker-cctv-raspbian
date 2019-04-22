# Docker, Raspberry & Amazon Rekoginition Service


### Description

Pi-detector is used  to search motion generated images for face matches by leveraging AWS Rekognition. In its current state, matches are wrote to event.log. With some additional creativity and work, you could send out a notification or allow/deny access to a room with minimal changes. The install script will place the appropriate files in /etc/rc.local to start on boot.  

### Build Requirements

Raspberry Pi (Tested with Rpi 3) <br />
Picamera <br />
AWS Rekognition Access (Free tier options available) <br />

As an alternative, this set of scripts can be modified to watch any directory that contains images. For example, if you collect still images from another camera and save them to disk, you can alter the image path to run facial recognition against any new photo that is created.

### Install

## Setup a Raspberry Pi with Raspbian Jessie <br />

https://www.raspberrypi.org/downloads/raspbian/ <br />

## Clone this repo and install:<br />
```
git clone https://github.com/af001/pi-detector.git<br />
cd pi-detector/scripts<br />
sudo chmod +x install.sh<br />
sudo ./install<br />

```
```
root@node2:~# systemctl start docker
root@node2:~# docker version
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
root@node2:~# clear
root@node2:~# docker version
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
```

```
root@node2:~# ls
docker-cctv-raspbian              portainer-agent-stack.yml      tiny-cloud
dockerlabs                        real_time_object_detection.py  v19.03.0-beta1.zip
MobileNetSSD_deploy.prototxt.txt  rpi-motion-mmal
pi_object_detection.py            tf-opencv
```

```
root@node2:~# git clone https://github.com/collabnix/pi-detector
Cloning into 'pi-detector'...
remote: Enumerating objects: 156, done.
remote: Total 156 (delta 0), reused 0 (delta 0), pack-reused 156
Receiving objects: 100% (156/156), 27.45 KiB | 0 bytes/s, done.
Resolving deltas: 100% (69/69), done.
```

```
root@node2:~# cd pi-detector/
root@node2:~/pi-detector# cd scripts/
root@node2:~/pi-detector/scripts# chmod +x install.sh
```

## Executing the script

```
root@node2:~/pi-detector/scripts# ./install.sh
[+] Updating and installing dependencies...
Get:1 http://archive.raspberrypi.org/debian stretch InRelease [25.4 kB]
Get:2 https://download.docker.com/linux/raspbian stretch InRelease [31.1 kB]
Get:3 http://raspbian.raspberrypi.org/raspbian stretch InRelease [15.0 kB]
Get:4 http://archive.raspberrypi.org/debian stretch/main armhf Packages [222 kB]
Get:5 http://raspbian.raspberrypi.org/raspbian stretch/main armhf Packages [11.7 MB]
Get:6 http://archive.raspberrypi.org/debian stretch/ui armhf Packages [44.9 kB]
Fetched 12.0 MB in 19s (627 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree
...
INFO  : New Install rclone is installed at /usr/bin/rclone
rclone v1.46
- os/arch: linux/arm
- go version: go1.11.5

-----------------------------------------------
INFO  : New Install Complete ver 10.x
-----------------------------------------------
Minimal Instructions:
1 - It is suggested you run sudo apt-get update and sudo apt-get upgrade
    Reboot RPI if there are significant Raspbian system updates.
2 - If config.py already exists then latest file is config.py.new
3 - To Test Run pi-timolo execute the following commands in RPI SSH
    or terminal session. Default is Motion Track On and TimeLapse On

    cd ~/pi-timolo
    ./pi-timolo.py

4 - To manage pi-timolo, Run menubox.sh Execute commands below

    cd ~/pi-timolo
    ./menubox.sh

For Full Instructions See Wiki at https://github.com/pageauc/pi-timolo/wiki

Good Luck Claude ...
Bye
[+] Adding auto launch for pi-timolo to start on boot
[+] Adding cronjob and changing file permissions...
[+] Done!
```

### Getting started

First, you need to create a new collection on AWS Rekognition. Creating a 'home' collection would look like:

```
cd pi-detector/scripts<br />
python add_collection.py -n 'home'<br />
```

Next, add your images to the pi-detector/faces folder. The more images of a person the better results you will get for detection. I would recommend several different poses in different lighting.

```
cd pi-detector/faces<br />
python ../scripts/add_image.py -i 'image.jpg' -c 'home' -l 'Tom'<br />
```

I found the best results by taking a photo in the same area that the camera will be placed, and by using the picam. If you want to do this, I created a small python script to take a photo with a 10 second delay and then puts it into the pi-detector/faces folder. To use it:

```
cd pi-detector/scripts<br />
python take_selfie.py<br />
```

Once complete, you can go back and rename the file and repeat the steps above to add your images to AWS Rekognition. Once you create a new collection, or add a new image, two reference files will be created as a future reference. These are useful if you plan on deleting images or collections in the future.

## To delete a face from your collection, use the following:

 ```
 cd pi-detector/scripts<br />
python del_faces.py -i '000-000-000-000' -c 'home'<br />
```

If you need to find the image id or a collection name, reference your faces.txt and collections.txt files.

## To remove a collection:

```
cd pi-detector/scripts<br />
python del_collections.py -c 'home'<br />
```

Note that the above will also delete all the faces you have stored in AWS. 

The last script is facematch.py. If you have images updated and just want to test static photos against the faces you have stored on AWS, do the following:

```
cd pi-detector/scripts<br />
python facematch.py -i 'tom.jpg' -c 'home'<br />
```

The results will be printed to screen, to include the percentage of similarity and confidence. 
