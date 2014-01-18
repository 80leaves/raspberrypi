raspberrypi
===========

A set of tipps &amp; tricks regarding experiments with a raspberry Pi.

I'm currently using a 
> RaspberryPi Model B 512MB RAM 

and a 

> EDIMAX EW-7811UN Wireless USB Adapter, 150 Mbit/s, IEEE802.11b/g/n 

[Edimax at Amazon.de] [1]


#DEV Environment#

I'm actually ssh-ing to my raspberryPi and doing all the main work on my developer machine in OSX. 
To get some extra comfort I did following entries at my ```/etc/hosts```
```bash
## pimote
192.168.178.xxx pi # eth0
192.168.42.1 pifi # wlan0
```

##Install Raspbian##
###Download latest Raspian###
Download the [latest Raspbian Image]

###Bring it to your SD-Card###
First determ your SD card
```sh
df -h
```
then unmount it
```bash
sudo diskutil unmount /dev/disk4s1
```
copy Raspbian to it
```bash
sudo dd bs=1m if=2013-02-09-wheezy-raspbian.img of=/dev/rdisk4
```
eject it
```bash
diskutil eject /dev/rdisk4
```
> Hint: With ```ctrl + T``` you can see the current progress
    

###First Boot###
The first boot will prompt you straight to the raspi-config. If however you might want to call it up again, simply use 
```sh
sudo raspi-config
```
I usually change following settings:
  * update the config
  * expand_rootfs
  * configure_keyboard
  * change_pass <b style="color:red">! important !</b>
  * memory_split -> 16MB
  * overclock -> Turbo 1000Mhz
  * ssh -> enable
  

###Second Boot###
Now its time to copy our public key from the Developer machine to have eassier ssh access.

Create rsa_pub Keys if not already done yet ```ssh-keygen -t rsa -C "yourname@yourdomain.ext"```
	
At your Host: 
```sh 
ssh pi@192.168.178.xxx
```
Pi: 
```sh 
mkdir ~/.ssh
```
Host: 
```sh
scp ~/.ssh/id_rsa.pub pi@pi:/home/pi/.ssh/authorized_keys
```

Now edit ```~/.ssh/config``` at your Host machine
```bash
HOST pi
	HostName 192.168.178.xxx
	Port 22
	User pi
```
	
From now on you can simply use ```ssh pi``` without being prompted for a password
	
Now, let's update
```bash
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get clean
```
and install some basics
```bash
sudo apt-get install -y vim iw screen avahi-daemon htop dnsmasq tree git-core	
```

###Wireless USB Adapter###
  
EDIMAX EW-7811UN Wireless USB Adapter, 150 Mbit/s, IEEE802.11b/g/n 

First make sure an existing hostapd is removed as we need to replace it by a modified version.
```bash
sudo apt-get autoremove hostapd
```
Now download and install a modified version. Thanks @[segersjens]
```bash
wget https://github.com/segersjens/RTL8188-hostapd/archive/v1.0.tar.gz
tar -zxvf v1.0.tar.gz
cd RTL8188-hostapd-1.0/hostapd
sudo make
sudo make install
```
Now hostapd can be started by
```bash
sudo service hostapd start
```
To get our access point up and running, some configrations need to be done

Edit ```/etc/hosts``` and add hostname to first line after localhost
```bash
sudo vim /etc/hosts
```
```bash
127.0.0.1       localhost YOUR_HOST
::1             localhost ip6-localhost ip6-loopback
fe00::0         ip6-localnet
ff00::0         ip6-mcastprefix
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters

127.0.1.1       YOUR_HOST    
```
Edit ```/etc/hostname```
```bash
sudo vim /etc/hostname
```
```bash
YOUR_HOST
```
	
Edit ```/etc/avahi/avahi-daemon.conf```
```bash
sudo vim /etc/avahi/avahi-daemon.conf
```
Change ```host-name=YOUR_HOST``` if prefered to be different from your hostname

Edit ```dnsmasq.conf``` and add after last line:
```bash
sudo vim /etc/dnsmasq.conf
```
```bash
domain=local
dhcp-range=192.168.42.10,192.168.42.10
dhcp-host=80:1f:02:87:7b:a7,192.168.42.1,pi
dhcp-option=3,192.168.42.10
dhcp-option=6,192.168.42.11,8.8.8.8,8.8.4.4,192.168.42.1
```
	
Edit ```/etc/network/interfaces```
```bash
sudo vim /etc/network/interfaces
```
```bash
auto lo

iface lo inet loopback
iface eth0 inet dhcp

allow-hotplug wlan0
iface wlan0 inet static
address 192.168.42.1
netmask 255.255.255.0

#wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
#iface default inet dhcp
```
	
Edit ```/etc/hostapd/hostapd.conf```
```bash
sudo vim /etc/hostapd/hostapd.conf
```
```bash
# Basic configuration

interface=wlan0
ssid=wifi
channel=1
#bridge=br0

# Hardware configuration

driver=rtl871xdrv
ieee80211n=1
hw_mode=g
device_name=RTL8192CU
manufacturer=Realtek

# pimote settings
#country_code=DE
max_num_sta=2
wpa=2
#rsn_preauth=1
#rsn_preauth_interfaces=wlan0
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
wpa_pairwise=CCMP
wpa_passphrase=balloon1
```
You can check your connected devices by 
```bash
arp -n
```

##Install libgphoto2 & gphoto2##
! This is work in progress
```bash
sudo apt-get install -y libusb-dev libusb-1.0-0-dev 
```

```bash
sudo apt-get install -y libexif-dev
```

```bash
sudo apt-get install -y libpopt-dev
```

```bash
sudo apt-get install -y libfuse-dev
```

```bash
sudo apt-get install -y mono-devel
```

```bash
sudo apt-get install -y monodoc-base
```

```bash
sudo apt-get install -y libmono-2.0.1
```

```bash
sudo apt-get install -y mono-gmcs
```

```bash
sudo apt-get install -y python-pyrex
```
```bash
sudo apt-get install -y libtool
```
Error:
gphoto2: error while loading shared libraries: libgphoto2.so.6: cannot open shared object file: No such file or directory
Problem:
ldd /usr/local/bin/gphoto2
	/usr/lib/arm-linux-gnueabihf/libcofi_rpi.so (0xb6f55000)
	libgphoto2.so.6 => not found
	libgphoto2_port.so.10 => not found
	libltdl.so.7 => /usr/lib/arm-linux-gnueabihf/libltdl.so.7 (0xb6f3a000)
	libdl.so.2 => /lib/arm-linux-gnueabihf/libdl.so.2 (0xb6f2f000)
	libpthread.so.0 => /lib/arm-linux-gnueabihf/libpthread.so.0 (0xb6f10000)
	libexif.so.12 => /usr/lib/arm-linux-gnueabihf/libexif.so.12 (0xb6ed4000)
	libpopt.so.0 => /lib/arm-linux-gnueabihf/libpopt.so.0 (0xb6ec1000)
	libm.so.6 => /lib/arm-linux-gnueabihf/libm.so.6 (0xb6e50000)
	libc.so.6 => /lib/arm-linux-gnueabihf/libc.so.6 (0xb6d21000)
	/lib/ld-linux-armhf.so.3 (0xb6f63000)
	libgcc_s.so.1 => /lib/arm-linux-gnueabihf/libgcc_s.so.1 (0xb6cf8000)
shows 'not found'

Solution:

```bash
sudo vim /etc/ld.so.conf
```
```bash
include /etc/ld.so.conf.d/*.conf
/usr/local/lib
```
Link: http://lonesysadmin.net/2013/02/22/error-while-loading-shared-libraries-cannot-open-shared-object-file/
[1]:http://www.amazon.de/EDIMAX-EW-7811UN-Wireless-Adapter-IEEE802-11b/dp/B003MTTJOY/ref=sr_1_1?s=computers&ie=UTF8&qid=1388835255&sr=1-1&keywords=edimax+ew-7811un
[segersjens]:[http://jenssegers.be/blog/43/Realtek-RTL8188-based-access-point-on-Raspberry-Pi]
[latest Raspbian image]:[http://downloads.raspberrypi.org/raspbian_latest]
