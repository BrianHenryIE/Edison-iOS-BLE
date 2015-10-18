# Intel Edison to iOS BLE Communication

[In progress..] This repository contains the minimal code required to send data from an [Intel Edison](http://www.intel.com/content/www/us/en/do-it-yourself/edison.html) to an iOS device using [Bluetooth Low Energy](https://en.wikipedia.org/wiki/Bluetooth_low_energy) (BLE). The Intel Edison has integrated Bluetooth so no additional hardware is required. This guide will use Objective-C and Node.js. Naturally, you'll need [XCode](https://itunes.apple.com/en/app/xcode/id497799835) installed and you'll also need to download and install [Intel Edison Board Installer](https://software.intel.com/en-us/iot/software/installers) and [Intel XDK IoT](https://software.intel.com/en-us/iot/software/ide) edition.

## Quickstart

Clone this repository using
``` git clone https://github.com/BrianHenryIE/Edison-iOS-BLE.git ```

With the Edison setup, connected and powered on, open the IoT SDK – you'll need an [Intel Developer account](https://software.intel.com/registration/?returnID=200) to use it.

In the `Serial Terminal` tab, change the `Port` to match your Edison – something like `cu.usbserial-A904BYVX` – and press `Connect`. If nothing appears, focus the terminal window and press enter. Log in when prompted. Use `configure_edison --wifi` to set up WiFi if not already done.

There's a Bluetooth bug to be dealt with proceeding, follow the short guide at [rexstjohn.com](http://rexstjohn.com/configure-intel-edison-for-bluetooth-le-smart-development/).

Click the `- Select a Device -` dropdown, `[%] Rescan for Devices` and select your device. 

Open the project in the `Edison Node` folder in the XDK, press the down arrow to upload the code to the device and then te play/run button to start it.

Open Edison-iOS-BLE.xcodeproj in XCode. There are no CocoaPods to worry about. Run the code on your iOS device.

You should now see any nearby BLE devices that are advertising. You can read or subscribe to a characteristic.


## Bluetooth Basics

For the purposes of reading/receiving data and sending control commands the most important BLE concepts are [Services](https://developer.bluetooth.org/gatt/services/Pages/ServicesHome.aspx) and [Characteristics](https://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicsHome.aspx). From the [Bluetooth Developer Portal](https://developer.bluetooth.org/TechnologyOverview/Pages/GATT.aspx):

> Services may contain a collection of characteristics. Characteristics contain a single value and any number of descriptors describing the characteristic value.

Both services and characteristics need an associated UUID (aka GUID in Microsoft terminology). The Bluetooth SIG have adopted many services and characteristics, and using predefined ones should make your hardware complatible with existing software, e.g. Apple Health. To generate your own UUID in terminal use the `uuidgen` command.

You should read [this overview of Bluetooth LE](https://github.com/tigoe/BLEDocs/wiki/Introduction-to-Bluetooth-LE).

Probably the most important thing you need to know right now is that characteristic values can only be up to 20 bytes (to get around it, you can break up your message and send it or increase the MTU?).

## Edison


* [Mozilla Developer Network – A re-introduction to JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/A_re-introduction_to_JavaScript)
* [Bleno](https://github.com/sandeepmistry/bleno) Node module

The Edison's WiFi is quite weak, so you might consider using your MacBook's WiFi as an AP (using `Create Network...` in the WiFi menu) that it can connect to and connect OS X to the Internet via ethernet or a second WiFi adpater.

Why is it a buffer?
-because it's not (necessarily) a string? 
https://millermedeiros.github.io/mdoc/examples/node_api/doc/buffers.html
the buffer sending [98] is read by the iPhone as @'b'

## iOS

Previously it was possible to use a dongle with the simulator, but [not anymore](http://stackoverflow.com/a/11049342) – you'll need a real device.

Link WWDC videos

* [WWDC 2013 – Session 703 – Core Bluetooth](https://developer.apple.com/videos/play/wwdc2013-703/) – essential viewing
* [WWDC 2013 – Session 703 – What's New in Core Location](https://developer.apple.com/videos/play/wwdc2013-307/) – beacons

https://developer.apple.com/library/ios/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothBackgroundProcessingForIOSApps/PerformingTasksWhileYourAppIsInTheBackground.html
> The Core Bluetooth background execution modes are declared by adding the UIBackgroundModes key to your Info.plist file 

## Contact
This is obviously incomplete, but feel free to contact me on <BrianHenryIE@gmail.com> and I'll try to help out/improve this document.