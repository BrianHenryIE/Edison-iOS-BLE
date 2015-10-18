# Intel Edison to iOS BLE Communication

This repository contains the minimal code required to send data from an [Intel Edison](http://www.intel.com/content/www/us/en/do-it-yourself/edison.html) to an iOS device using [Bluetooth Low Energy](https://en.wikipedia.org/wiki/Bluetooth_low_energy) (BLE). The Intel Edison has integrated Bluetooth so no additional hardware is required. This guide will use Objective-C and Node.js. Naturally, you'll need [XCode](https://itunes.apple.com/en/app/xcode/id497799835) installed and you'll also need to download and install Intel Edison Board Installer and Intel XDK IoT edition from the [Intel IoT Downloads](https://software.intel.com/en-us/iot/downloads) page.

## Quickstart

Clone this repository using
``` git clone https://github.com/BrianHenryIE/Edison-iOS-BLE.git ```

With the Edison setup, connected and powered on, open the Edison Node folder in the IoT XDK. 
There's [a bug](http://rexstjohn.com/configure-intel-edison-for-bluetooth-le-smart-development/) to be dealt with before anything will run. In XDK, under serial port, find and connect to your Edison, then run th following commands:


Open Edison-iOS-BLE.xcodeproj in XCode. There are no CocoaPods to worry about. Run the code on your iOS device.

You should now see any nearby BLE devices that are advertising. You can read or subscribe to a characteristic.


## Bluetooth Basics

BLE is...

[Characteristics](https://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicsHome.aspx)

[Services](https://developer.bluetooth.org/gatt/services/Pages/ServicesHome.aspx)


Terminal
> uuidgen


iOS
why is uuid so long if it's 128 bits
- each hex character we're passing as a string represents only 4? bits

uuid-guid: no difference



The mutable objects are for writing peripherals – you're going to change the values in them.


what do do if you need to send more than 20 bytes?
- break it up and send it?
- increase the MTU?




## Edison

Node on Edison:
http://www.codefoster.com/edison-coding/

[Mozilla Developer Network – A re-introduction to JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/A_re-introduction_to_JavaScript)


Bleno

Why is it a buffer?
-because it's not (necessarily) a string? 
https://millermedeiros.github.io/mdoc/examples/node_api/doc/buffers.html
the buffer sending [98] is read by the iPhone as @'b'

## iOS

Simulator with dongle?

Link WWDC videos


https://developer.apple.com/library/ios/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothBackgroundProcessingForIOSApps/PerformingTasksWhileYourAppIsInTheBackground.html
> The Core Bluetooth background execution modes are declared by adding the UIBackgroundModes key to your Info.plist file 


Feel free to contact me on <BrianHenryIE@gmail.com> and I'll try to help out.