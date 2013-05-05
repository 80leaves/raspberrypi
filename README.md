raspberrypi
===========

A set of tipps &amp; tricks regarding experiments with a raspberry Pi
* **Configurate DEV Environment**
	
	I'm actually ssh-ing to my raspberryPi and doing all the main work on my developer machine. So get some extra comfort I did following entries at my 
	/etc/hosts
	```bash
	## pimote
	192.168.178.54 pi # eth0
	192.168.42.1 pifi # wlan0
	```

* **Install Raspbian**

	First determ your SD card
	```bash
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
	Hint: With ```ctrl + T``` you can see the current progress

* **First Boot**
  ```sudo raspi-config```
  * update
  * expand_rootfs
  * configure_keyboard
  * change_pass
  * memory_split -> 16MB
  * overclock -> Turbo 1000Mhz
  * ssh -> enable
  

* **Second Boot**
  
	Host: ```ssh pi@192.168.178.54```
	Pi: ```mkdir ~/.ssh```
	Host: ```scp ~/.ssh/id_rsa.pub pi@pi:/home/pi/.ssh/authorized_keys```
	
	From now on you can simply use ssh pi without being prompted for a password
	
	Now, let's update and install some basics:
	```bash
	sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get clean
	```
	```bash
	sudo apt-get install -y vim
	sudo apt-get install -y iw
	sudo apt-get install -y screen
	sudo apt-get install -y avahi-daemon
	sudo apt-get install -y htop
	sudo apt-get install -y dnsmasq
	sudo apt-get install -y tree
	sudo apt-get install -y git-core	
	```
	

* **Wireless USB Adapter**
  
  EDIMAX EW-7811UN Wireless USB Adapter, 150 Mbit/s, IEEE802.11b/g/n 

	```bash
	wget https://github.com/segersjens/RTL8188-hostapd/archive/v1.0.tar.gz
	tar -zxvf v1.0.tar.gz
	cd RTL8188-hostapd-1.0/hostapd
	sudo make
	sudo make install
	```
	Edit ```sudo vim /etc/hosts``` and add hostname to first line after localhost
	Edit ```sudo vim /etc/hostname``` edit hostname
