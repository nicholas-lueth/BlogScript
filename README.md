# <p align="center"> How to Setup a WordPress Blog From a Freshly Installed CentOS Linux Box </p>
<p align="center"> Created By: Nicholas Lueth </p>

### Background: 
CentOS is a distribution of the Linux operating system. CentOS was developed by Red Hat Enterprise, which is a distinguished software development company. If you want, you can pay Red Hat for 5 years of support services, which will provide you with some very good around the clock technical assistance and support. Linux, on the other hand, is an operating system derived from the Unix operating system, just like Mac OS X. Don't get misconstrued, the only real similarity between Mac OS X and Linux is the command line. If you have any experience with the Unix-based command lines, it will be very helpful.

### Links:
VMware: https://my.vmware.com/web/vmware/free#desktop_end_user_computing/vmware_workstation_player/15_0 <br>
Fresh install link: https://www.centos.org/download/ 

## Instructions:
**Step 1**: 
Download VMware player and the ISO file for CentOS from the links listed above. Choose the VMware that corresponds with your operating system, most likely it will be the Windows option. You’ll also want to download the “CentOS Linux DVD ISO” option.

**Step 2**: 
Go through the installation wizard for VMware Player. This process will mostly be just you agreeing to user agreements and specifying options. All of the default options will work for what we are doing.

**Step 3**: 
You’re going to have to enable virtualization. You do this by going into the BIOS of your computer. To do this, follow these steps:
1.  Click the Windows button on the bottom left-hand side of your desktop.
2.  Click on the gear for settings.
3.  Click the “Update & Security” settings
4.	Click on the “Recovery” option on the left-hand panel.
5. 	Click the “Restart now” under the advanced startup option.
6. 	When your computer boots back up click on the “Troubleshoot” option.
7. 	Click on the “Advanced options”
8. 	Click on “UEFI Firmware Settings”
9. 	You will then click the “Restart”  button.
10.	Bios will open up. You can use the arrow keys to navigate it and the return key to interact with options. 
11.	The option can be hard to find depending on what version of BIOS you have. Look through the list and see if you can find any options that mention virtualization. The option should be under Processor, Chipset, Advanced CPU config, etc. If you do not see anything on the home screen, you should enter each individual listing and look for the virtualization option within other options.
12.	The option’s name can vary based on what hardware you have, but the option should be one of the following.
    - VT-x
    - Intel VT-x
    - Virtualization Extensions
    - Intel Virtualization Technology
13.	Once you find it, enable it, then save and quit out of BIOS.

**Step 4**: 
Now you need to open up VMware and click the “Create a New Virtual Machine” option. Then follow these steps:
1.	Click “Installer disc image file (iso):” and browse to the CentOS file we downloaded earlier. If you didn’t move it to the desktop, it will most likely be in your downloads folder. Then click next.
2.	Name your virtual machine. This can be anything, just don’t change the location. Then click next.
3.	Click “Store virtual disk as a single file”, then click next.
4.	Then click finish.

**Step 5**: 
Now we need to configure the CentOS machine. Your virtual machine should be booting up at this point. Using the arrow keys and the return button, navigate to the “Install CentOS 7” option and press return.

**Step 6**: 
Click on your desired language, then press continue.

**Step 7**: 
You will now be on the installation page. You can change any options regarding timezones and keyboard layouts on this page. After you do that, make sure you set up your network settings and turn on the adapter. If you don’t do this, you won’t have internet connectivity to your virtual machine.

**Step 8**: 
Then click the “INSTALLATION DESTINATION” option and confirm the disk you will be writing to by clicking on the disk and pressing done. After that, click “Begin Installation” on the bottom right of the menu.

**Step 9**: 
Now you will have to set a root password. (Make sure you remember it) It can be anything, just double-tap done if the password is considered weak. Then wait until the installation is complete. (This should take a while, so be patient)

**Step 10**: 
Once the installation is done, click the “Reboot" button. When the kernel selection page pops up, either wait until the default option automatically boots or select the top option.

**Step 11**: 
Now you have to log in. The username will be “root”, and the password will be whatever you set the root password to in step 9. 

**Step 12**: 
These are the exact commands you need to type in order to get a running WordPress Blog.
-	`yum install git -y`
-	`cd ~`
-	`mkdir scripts`
-	`cd scripts`
-	`git clone https://github.com/nickranger44/BlogScript.git`
-	`cd BlogScript`
-	`chmod +x getBlog.sh`
-	`./getBlog.sh`

**Step 13**: 
The script will ask you to type in the root password. By default, it assumes you don't have one, so press return and follow the directions to reset the root password. For consistency, make this the same as you did in step 9. Otherwise, you will have a different root password.

**Step 14**: 
The script will eventually prompt you to log in to the database. Sign in with the credentials you typed in at the beginning of the script, then type the following in:
``` 
CREATE DATABASE wordpress;

CREATE USER “<username from earlier>” IDENTIFIED BY "<password from earlier>";

GRANT ALL PRIVILEGES ON wordpress.* TO “<username from earlier>” IDENTIFIED BY "<password from earlier>";

FLUSH PRIVILEGES;

exit;
```
**Step 15**: 
At this point, the script should be done. Type `ip addr` and look for the IP address that resides next to “inet” that isn’t “127.0.0.1” and type that IP address into your web browser’s search bar like this “192.168.106.129”.

**Step 16**: 
Go through the WordPress settings and enjoy your new local facing blog. If you want to make this a public website, then you’ll have to port forward, but I’ve drawn out this how-to long enough.

### Making your website public:
A video on how to setup your new website on a webhosting service: <br>
https://www.youtube.com/watch?v=E9YTRLm9SQs

### SECURITY WARNING:
Wordpress has a reputation for having dangerously insecure plugins and features, but luckily there are security measures you can implement to help mitigate any potential risks. 
1. Keep WordPress up to date (including themes and plugins)
2. Use two factor authentication
3. Strong passwords
4. Use reputible security plugins
    * WordFence (Alerts and security scans)
    * iThemes Security (General all purpose protection)
5. Only use trusted plugins and themes
6. Use SFTP for file transfers

I recommend watching this video: <br>
https://www.youtube.com/watch?v=mKlajaKllD4
