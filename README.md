# VegaMining
Script to assist in setting optimal mining settings for Vega 56 or Vega 64
How to use it: 

Right click StartVegaSetup.bat and click "Run as Administrator"
Select the option you want to run. The explecations of the options are written below. 
The steps should go something like:
Download and extract the files - Option 0 (Read notes on option 0 below.)
Run Display Driver Uninstaller - Option 2
Install AMD drivers
Disable Ulps and Crossfire Detection - Option 3
Import powerplay tables - Option 4
Set overdrive profiles - Option 5
Disable and re-enable the cards - Option 6
Run your mining program - Option 7




Notes:
As this is my first attempt at this script, some things very well may not work correctly. 

Options:

	 0: Press '0' to download the necessary files.
		This option will download and extract the necessary files. It will also open a window for the AMD driver that you will need to manually download and install.
		If any of the downloads or extractions fail, open URLs.txt and download the files manually. Extract the zip file into its own folder within the "Tools" folder. If there is no "Tools" folder, you will need to create one.  
     1: Press '1' to export your current video registry.
		This option will export your current video settings. 
     2: Press '2' to run display driver uninstaller.
		This option will reboot your computer and should be run before you install the AMD blockchain driver. Install AMD blockchain driver after reboot. 
     3: Press '3' to Disable Ulps and DisableCrossFireAutoLink.
		This disables specific things about the driver for each card that helps improve hashrates.
     4: Press '4' to import powerplay tables. (Make sure to edit 'VegaPowerPlayTable.txt'. Do not modify ZZzz.)
		This imports the powerplay settings from VegaPowerPlayTable.txt into the registry for each card. The TXT file contained is of my own personal settings. You can learn more on how to modify this file for your needs at http://vega.miningguides.com/.
	 5: Press '5' to set Overdrive profile for Vegas.
		This imports overdrive settings to the Vegas. It currently gives an error that can be ignored. These are also my own personal settings, so visit the vega mining guide to look for tweaks. If your setup is crashing, try modifying Tools\Overdrive*\OverdriveNTool.ini. Adjust Mem_P3=950;900 to Mem_P3=920;900 and then work your way up.
     6: Press '6' to disable and re-enable all Vegas.
		This will disable all vegas and re-enable them. This step is required after every reboot, and after UAC prompt pops up.
     7: Press '7' to run cast-xmr.
		This will run cast-xmr. It will prompt you for your wallet address and pool url. It will save the info you input into Settings.txt, so modify this file if you want to change the settings going foward. 
     Q: Press 'Q' to quit.