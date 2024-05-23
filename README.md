# SteamDeck SteamOS vangogh_oc_fix kernel module installer

A simple shell script that installs a precompiled vangogh_oc_fix kernel module. \
I've built this for SteamOS 3.4.11 stable and the upcoming SteamOS 3.5 (currently in 3.5.1 Preview). \
As soon as more kernels are released by Valve for the SteamOS I will try to compile and update this accordingly.

Credits goes to [badly-drawn-wizards](https://github.com/badly-drawn-wizards/vangogh_oc_fix) for the source code of the kernel module!

<b> If you like my work please show support by subscribing to my [YouTube channel @10MinuteSteamDeckGamer.](https://www.youtube.com/@10MinuteSteamDeckGamer/) </b> <br>
<b> I'm just passionate about Linux, Windows, how stuff works, and playing retro and modern video games on my Steam Deck! </b>
<p align="center">
<a href="https://www.youtube.com/@10MinuteSteamDeckGamer/"> <img src="https://github.com/ryanrudolfoba/SteamDeck-Logo-Changer/blob/main/10minute.png"/> </a>
</p>

## Disclaimer
1. Do this at your own risk!
2. This is for educational and research purposes only!

## Video Tutorial - coming soon!

## What's New (as of May 23 2024)
1. Support for SteamOS 3.6 kernel 6.5.0-valve5-1-neptune-65-g6efe817cc486
2. Removed sanity checks for BIOS since we now have SREP method! [Use Steam Deck BIOS Manager instead to unlock!](https://github.com/ryanrudolfoba/SteamDeck-BIOS-Manager) [demo guide for Steam Deck BIOS Manager.](https://youtu.be/Q1965gH9xig?si=f2cU86hSj6b8FiYG) [Thanks to stanto and smokeless!](https://www.stanto.com/)
## What's New (as of March 02 2024)
1. SteamOS 3.5.17 support
2. OLED support on BIOS F7G0109

## What's New (as of December 13 2023)
1. SteamOS 3.5.7 support

## What's New (as of October 16 2023)
1. initial release

## Prerequisites for SteamOS
1. sudo password should already be set by the end user. If sudo password is not yet set, the script will ask to set it up.
2. the script has sanity checks and will execute on BIOS 116, 115, 113 and 110.
3. the script has sanity checks and will copy the kernel module only on kernels version 5.13 and 6.1.52.

## Installation Steps
1. Go into Desktop Mode and open konsole terminal.
2. Clone the Github repo - \
   `cd ~/` \
   `git clone https://github.com/ryanrudolfoba/SteamDeck-vangogh_oc_fix-installer`

3. Execute the script! \
   `cd SteamDeck-vangogh_oc_fix-installer` \
   `chmod +x vangogh_oc_fix-installer.sh` \
   `./vangogh_oc_fix-installer.sh`

4. Run it in the current boot with `sudo modprobe vangogh_oc_fix cpu_default_soft_max_freq=<freq in Mhz>`
5. Verify that the kernel module is running - \
   `lsmod | grep van`

## How to Uninstall
1. Go into Desktop Mode and open konsole terminal - \
   `sudo steamos-readonly disable` \
   `cd /lib/modules/$(uname -r)/extra` \
   `rm vangogh_oc_fix.ko.xz` \
   `sudo steamos-readonly enable`

## Will this survive a branch update?
No it won't! You need to run the install again. I could make it but it needs further thought. Let me know if you have ideas!

But on the latest SteamOS 3.6 this is now possible to survive a branch update due to /etc whitelist. I'll update accordingly once SteamOS3.6 goes to stable.
