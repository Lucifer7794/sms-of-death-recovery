ANDROID "SMS OF DEATH" RECOVERY UTILITY
CVE-2026-58882 | Windows | Shubham Chatterjee

READ BEFORE RUNNING

FixSmsOfDeath.bat clears the telephony provider's application data for
Android user 0. Expect stored SMS and MMS for that user to be lost.
Call-history and telephony-setting changes depend on the device. The script
does not create a backup, detect the CVE, or install an Android update.
Its behaviour was reviewed from source. Handset recovery remains unverified.

1. CHECK THE PHONE AND YOUR BACKUP

   If calls and texts work, use the phone's normal software update process.
   Google lists this CVE at the 2026-11-01 Android security patch level.
   Earlier builds require confirmation from the device manufacturer.
   In Settings > About phone > Android version, find "Android security
   update". Menu names vary by manufacturer.

   If the phone is unstable, ask the manufacturer or a qualified technician
   about recovery that preserves messages. For an urgent call, use another
   working phone. If evidence or unbacked-up messages matter, stop before a
   provider reset.

   Open Settings > Google > Backup (or All services > Backup). Check the
   account, the last completed backup, and whether SMS and MMS are included.
   A new backup may take up to 24 hours. If you cannot confirm that the data
   you need is backed up, stop and contact support.

2. PREPARE THE WINDOWS PC AND ANDROID PHONE

   Extract the repository ZIP. Open the recovery folder in the extracted
   files. On the phone, enable Developer options and USB debugging.
   On many phones, tapping Build number seven times enables Developer
   options. Use the instructions for your model if its menu differs.

   Connect the unlocked phone to your own trusted Windows PC with a USB
   data cable. Disconnect other phones and stop running Android emulators.
   Approve the USB debugging prompt for this PC.

3. CHECK THE DEVICE AND DECIDE WHETHER TO CONTINUE

   Review FixSmsOfDeath.bat in a text editor before running it. It enables
   coloured output for the current user's Windows console. If ADB is absent
   from PATH, it downloads Google's Windows Platform-Tools over HTTPS.
   The script does not check a published digest for that download. You may
   install Google's Platform-Tools yourself and add them to PATH first.

   Run FixSmsOfDeath.bat from the extracted recovery folder. It displays
   the detected serial number. Check that it belongs to the intended phone.
   At the confirmation prompt, pressing Enter without typing cancels.
   Type uppercase YES only if you choose to erase the provider data.
   The reset is bound to the serial number displayed.

4. VERIFY THE RESULT

   Read the ADB output. A successful command only confirms that the device
   accepted the reset. Disconnect the cable and restart the phone manually.
   Check mobile signal, place an ordinary call, and send and receive a
   normal text. Turn off USB debugging when finished if you enabled it
   solely for this task.

   If the command fails or symptoms persist, stop and contact the device
   manufacturer. Keep the exact error text for support. Repeating the reset
   can erase newly restored messages.

TROUBLESHOOTING

   No device: unlock the phone, check USB debugging and try a data-capable
   cable. An unauthorised phone gets one 15-second wait for approval.
   Multiple devices: disconnect other phones and stop emulators.
   Access denied: some builds restrict clearing this provider. Contact the
   manufacturer for a supported recovery option.
   Download failed: use Google's Platform-Tools page below.

OFFICIAL REFERENCES

   Android security bulletin
   https://source.android.com/docs/security/bulletin/2026/2026-11-01

   Android backup
   https://support.google.com/android/answer/2819582

   Windows Platform-Tools from Google
   https://developer.android.com/tools/releases/platform-tools

   Android Debug Bridge documentation
   https://developer.android.com/tools/adb
