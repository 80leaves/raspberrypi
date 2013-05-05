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
	
	Edit ```sudo vim /etc/avahi/avahi-daemon.conf```
	Change ```host-name=YOUR_HOST``` if prefered to be different from your hostname
	
	Edit ```dnsmasq.conf``` and add after last line:
	```bash
	domain=local
	dhcp-range=192.168.42.10,192.168.42.10
	dhcp-host=80:1f:02:87:7b:a7,192.168.42.1,pi
	dhcp-option=3,192.168.42.10
	dhcp-option=6,192.168.42.11,8.8.8.8,8.8.4.4,192.168.42.1
	```
	
	Edit ```sudo vim /etc/network/interfaces```
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
	
	Edit ```sudo vim /etc/hostapd/hostapd.conf```
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

