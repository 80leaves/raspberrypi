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
  ```bash
  sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get clean
  ```
	sudo apt-get install -y vim
	sudo apt-get install -y iw
	sudo apt-get install -y screen
	sudo apt-get install -y avahi-daemon
	sudo apt-get install -y htop
	sudo apt-get install -y dnsmasq
	sudo apt-get install -y tree
	sudo apt-get install -y git-core
	sudo apt-get install -y vim

	mkdir ~/.ssh
	execute from host
	```bash
	scp ~/.ssh/id_rsa.pub pi@pi:/home/pi/.ssh/authorized_keys
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
