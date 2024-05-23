#!/bin/bash

clear

echo Steam Deck vangogh_oc_fix kernel module installer - script by ryanrudolf
echo https://github.com/ryanrudolfoba/SteamDeck-vangogh_oc_fix-installer
echo Credits to https://github.com/badly-drawn-wizards/vangogh_oc_fix
echo
echo The script has sanity checks and will install the precompiled vangogh_oc_fix kernel module.
echo You can also build the kernel module from source and install manually - this script takes care of the manual process.
sleep 2

# Password sanity check - make sure sudo password is already set by end user!
if [ "$(passwd --status $(whoami) | tr -s " " | cut -d " " -f 2)" == "P" ]
then
	read -s -p "Please enter current sudo password: " current_password ; echo
	echo Checking if the sudo password is correct.
	echo -e "$current_password\n" | sudo -S ls &> /dev/null

	if [ $? -eq 0 ]
	then
		echo -e "$GREEN"Sudo password is good!
	else
		echo -e "$RED"Sudo password is wrong! Re-run the script and make sure to enter the correct sudo password!
		exit
	fi
else
	echo -e "$RED"Sudo password is blank! Setup a sudo password first and then re-run script!
	passwd
	exit
fi

kernel_version=$(uname -r)
kernel1=5.13.0-valve37-1-neptune
kernel2=6.1.52-valve3-1-neptune-61
kernel3=6.1.52-valve9-1-neptune-61
kernel4=6.1.52-valve16-1-neptune-61
kernel5=6.5.0-valve5-1-neptune-65-g6efe817cc486

# sanity check - make sure kernel version is supported
echo Checking kernel version ...
sleep 2
if [ $kernel_version = $kernel1 ] || [ $kernel_version = $kernel2 ] || [ $kernel_version = $kernel3 ] || [ $kernel_version = $kernel4 ] \
	|| [ $kernel_version = $kernel5 ]
then 
	echo Kernel version $kernel_version is supported by this script!
else
	echo Kernel version $kernel_version is NOT supported by this script! Exiting immediately!
	exit
fi

# Let's copy the kernel module to the correct location
echo Copying the kernel module to the correct location ...
sleep 2
sudo steamos-readonly disable &> /dev/null
sudo cp -R module/$kernel_version/extra /lib/modules/$kernel_version
sudo depmod -a
sudo steamos-readonly enable &> /dev/null

echo ALL DONE! ENJOY!
