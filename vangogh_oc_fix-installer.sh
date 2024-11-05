#!/bin/bash

clear

echo Steam Deck vangogh_oc_fix kernel module installer - script by ryanrudolf
echo https://github.com/ryanrudolfoba/SteamDeck-vangogh_oc_fix-installer
echo YT - 10MinuteSteamDeckGamer
echo Credits to https://github.com/badly-drawn-wizards/vangogh_oc_fix
echo
echo The script has sanity checks and will install the precompiled vangogh_oc_fix kernel module.
echo You can also build the kernel module from source and install manually - this script takes care of the manual process.
sleep 2

# define variables here
steamos_version=$(cat /etc/os-release | grep -i version_id | cut -d "=" -f2)
kernel_version=$(uname -r | cut -d "-" -f 1-5 )
stable_kernel1=6.1.52-valve16-1-neptune-61
stable_kernel2=6.5.0-valve22-1-neptune-65

# sanity check - make sure kernel version is supported
echo Checking kernel version ...
sleep 2
if [ $kernel_version = $stable_kernel1 ] || [ $kernel_version = $stable_kernel2 ]
then 
	echo SteamOS $steamos_version - Kernel version $kernel_version is supported by this script!
else
	echo SteamOS $steamos_version - Kernel version $kernel_version is NOT supported by this script! Exiting immediately!
	exit
fi

# sanity check - make sure sudo password is already set
if [ "$(passwd --status $(whoami) | tr -s " " | cut -d " " -f 2)" == "P" ]
then
	read -s -p "Please enter current sudo password: " current_password ; echo
	echo Checking if the sudo password is correct.
	echo -e "$current_password\n" | sudo -S -k ls &> /dev/null

	if [ $? -eq 0 ]
	then
		echo Sudo password is good!
	else
		echo Sudo password is wrong! Re-run the script and make sure to enter the correct sudo password!
		exit
	fi
else
	echo Sudo password is blank! Setup a sudo password first and then re-run script!
	passwd
	exit
fi

# Let's copy the kernel module to the correct location
echo Copying the kernel module to the correct location ...
sleep 2
echo -e "$current_password\n" | sudo -S steamos-readonly disable &> /dev/null
echo -e "$current_password\n" | sudo -S cp -R module/$kernel_version/extra /lib/modules/$(uname -r)
if [ $? -eq 0 ]
then
	echo Kernel module copied successfully!
	echo -e "$current_password\n" | sudo -S depmod -a
	echo -e "$current_password\n" | sudo -S modprobe vangogh_oc_fix
	lsmod | grep vangogh_oc_fix
	if [ $? -eq 0 ]
	then
		echo Kernel module loaded successfully!
	else
		echo Error loading kernel module.
		echo Deleteing kernel module.
		echo -e "$current_password\n" | sudo -S rm -rf /lib/modules/$(uname -r)/extra
		echo -e "$current_password\n" | sudo -S steamos-readonly enable &> /dev/null
		exit
	fi
else
	echo Error copying kernel module.
	exit
fi

echo -e "$current_password\n" | sudo steamos-readonly enable &> /dev/null

echo ALL DONE! ENJOY!
