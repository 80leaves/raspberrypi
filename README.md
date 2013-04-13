raspberrypi
===========

A set of tipps &amp; tricks regarding experiments with a raspberry Pi

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


* **Wireless USB Adapter**
  
  EDIMAX EW-7811UN Wireless USB Adapter, 150 Mbit/s, IEEE802.11b/g/n 

	```bash
	wget https://github.com/segersjens/RTL8188-hostapd/archive/v1.0.tar.gz
	tar -zxvf v1.0.tar.gz
	cd RTL8188-hostapd-1.0/hostapd
	sudo make
	sudo make install
	```
