# XANTECH D5RH DIGI-5 Windows Interface 
Windows Interface to control Xantech Digi 5 system through RS-232.


This device has been discontinued. but for anyone who wants to integrated to the modern technology can base off this sandbox application and adjust it to your need.


[![](https://github.com/thamarnan/xantech-digi5-interface/blob/master/images/xantech_keypad_both.jpg?raw=true)](https://github.com/thamarnan/xantech-digi5-interface/blob/master/images/xantech_keypad_both.jpg?raw=true)

# How it works ?

This Windows application replicate the actual keypad of the unit.
and connect to the DR5RH unit via the serial connector.

Windows Application is written in au3 AutoIt Language.
AutoIt is the Windows application language designed for automating Windows application and general scripting.
https://www.autoitscript.com/site/autoit/


Simply connect the serial connector to the unit (also works with serial to usb adapter)

Port 18 for serial connection (RS232)
[![](https://github.com/thamarnan/xantech-digi5-interface/blob/master/images/xantech_D5RH_backpanel.jpg?raw=true)](https://github.com/thamarnan/xantech-digi5-interface/blob/master/images/xantech_D5RH_backpanel.jpg?raw=true)

and run application.

I've only upload the source code for the application. No exe file.
You'll need to download the autoit then compile them.

# Customization
The unit has 4 source and 4 zone.
You can have each zone for eg. living room, kitchen, bedroom, bathroom.
and source from eg {Apple TV, Bluetooth Reciever, Computer, etc}

Here are directory tree for customized the thumbnail for each room

```bash
D:\xantech_controller\
| --  xantech_controller.exe
| -- commg.dll #need to be downloaded
| - - images
|       | -- preview_zone1.jpg
|       | -- preview_zone2.jpg
|       | -- preview_zone3.jpg
|       | -- preview_zone4.jpg
|       | --.. # other files
```
