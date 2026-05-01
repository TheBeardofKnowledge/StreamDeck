# StreamDeck
Simple script that allows you to Port StreamDeck plugins and icon packs to Fifine

Instructions:

1. Download and install the official StreamDeck software from ElGato
2. Setup a free account then sign in with that account to the StreamDeck software.
https://www.elgato.com/us/en/s/downloads
3. Open the StreamDeck store from within the software and install all the plugins and icon packs you want.
4. Wait until they all finish installing before moving on.
5. Download and install your Fifine stream controller software
https://fifinemicrophone.com/blogs/news/ampligame-d6-faqs
6. Now simply download and run the StreamDeckPortFifine.bat to have it automatically transfer the plugins
and icon packs to the Fifine software.
After the items are transfered, the script will close and reopen the Fifine Control Deck Software with everything.
Have fun!

Sad Update:
I made this on 05-20-2025, Elgato StreamDeck software was still version 1.x.  Some plugins no longer work with this simple port/transfer:

Explanation:
When they released version 2 SDK they included an option for plugin developers to use that would allow a secrets exchange between plugin and streamdeck software to verify each other.

See the changes Elgato made here dated 09-18-2025:
https://github.com/elgatosf/streamdeck/pull/97/files
commit info here:
https://github.com/elgatosf/streamdeck/commit/988492d6c78a3ccbc4415f949fe17e6ced3ea552

This was a beta release, but obviously the change made it into production.

They also added a device type referrence in the SDK, so if the plugin developer wants to have it verify the device type to function, then that also breaks 3rd party functionality.
https://docs.elgato.com/streamdeck/sdk/guides/devices

Along with those two, they also added specific application monitoring calls, which 3rd party software should not replicate for copyright reasons:
https://docs.elgato.com/streamdeck/sdk/guides/profiles

This was their way of giving developers the option to not allow their plugins for use with 3rd party streamdeck controllers.
As I understand it, this was actually at the request of many plugin developers BTW... as they did not want their plugins being used on unauthorized software.
While many developers adopted this, some did not, so it really all depends on the plugin developer.

3rd party Stream Deck's are almost all based on the same software:
https://bbs.key123.vip/forum.php?mod=forumdisplay&fid=4
This is the source BB for the software, but each manufacturer adds small custom changes and branding.
