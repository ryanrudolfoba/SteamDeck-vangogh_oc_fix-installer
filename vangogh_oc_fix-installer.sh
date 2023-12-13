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


bios_version=$(sudo dmidecode -s bios-version)
kernel_version=$(uname -r)

# sanity check - exit immediately if BIOS version is 118

echo Checking BIOS version ...
sleep 2
if [ $bios_version = F7A0118 ]
then 
	echo BIOS version 118 detected! We can\'t overclock BIOS 118. You need to downgrade the BIOS first! Exiting immediately!
	echo Please visit "https://youtu.be/GLvpBQX1pmI?si=jZbG6lNR4pRZowVl" for instructions on how to downgrade.
	exit

elif [ $bios_version = F7A0116 ] || [ $bios_version = F7A0115 ] || [ $bios_version = F7A0113 ] || [ $bios_version = F7A0110 ]
then
	echo BIOS version $bios_version is supported by this script!
else
	echo BIOS version $bios_version is NOT supported by this script! Exiting immediately!
	exit
fi

echo Checking kernel version ...
sleep 2
if [ $kernel_version = 6.1.52-valve9-1-neptune-61 ] || [ $kernel_version = 6.1.52-valve3-1-neptune-61 ] || [ $kernel_version = 5.13.0-valve37-1-neptune ]
then 
	echo Kernel version $kernel_version is supported by this script!
else
	echo Kernel version $kernel_version is NOT supported by this script! Exiting immediately!
	exit
fi

# All the sanity checks seems good let's go!

# Let's backup the BIOS first!
echo Let\'s backup the BIOS first!
sleep 2
mkdir ~/BIOS 2> /dev/null
sudo /usr/share/jupiter_bios_updater/h2offt ~/BIOS/jupiter-$bios_version-bios-backup.bin -O
ls -l ~/BIOS/jupiter-$bios_version-bios-backup.bin &> /dev/null
if [ $? -eq 0 ]
then
	echo BIOS has been backed up successfully!
else
	echo Something went wrong during the BIOS backup process! Exiting immediately!
	exit
fi

# Let's unlock the BIOS!
echo Let\'s unlock the BIOS ...
sleep 2
rm jupiter-bios-unlock &> /dev/null
wget https://gitlab.com/evlaV/jupiter-PKGBUILD/-/raw/master/bin/jupiter-bios-unlock &> /dev/null
chmod +x jupiter-bios-unlock
sudo ./jupiter-bios-unlock

# Let's copy the kernel module to the correct location
echo Copying the kernel module to the correct location ...
sleep 2
sudo steamos-readonly disable
sudo cp -R module/$kernel_version/extra /lib/modules/$kernel_version
sudo depmod -a
sudo steamos-readonly enable

echo ALL DONE! ENJOY!
