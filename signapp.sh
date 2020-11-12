#!/bin/bash
# Scriptname: Buildkit
# version 0.0.1
# Author: Ben Njunge 2020


#build type
# BUILD_TYPE = ''
PATH_APP="$PWD/platforms/android/app/build/outputs/apk/release"
echo "WELCOME TO SURVTECH APP BUILDKIT V0.0.1"
# This script signs android apps for you

echo ''
sleep 2s
# @todo
# Todo Note(1/1): Here, the script should run health checks before entering the main loop
# end #todo
echo 'Initializing script....'
echo ''
# @todo
# Todo Notes(1/2): This should check requirements for building an app, if not all requirements are met,
# Todo Notes(2/2):tool should offer to fix or give suggestions based on platform
# echo "Checking requirements:"
# end @todo

sleep 3s
echo 'Initialization completed.'
echo ''
sleep 2s
echo "Please choose the type of build you want. [(d) for debug, (p) for production]: "
read P

echo "App version that you are building...? :"
read VERSION
echo "Keystore Password: "
read KEYSTORE_PASSWORD
# echo "Keystore Passphrase: "
# read KEYSTORE_PASSPHRASE
echo ''

sleep 2s

echo "Selecting your build type and building the apk..."
echo ''

sleep 1s

if [ "$P" == "p" ]
then
    echo -n "Building Prod APK..."
    ionic cordova build android --prod --release --minifyCSS --minifyJS --quiet

    sleep 1s
    echo "APK create successfully. Initiating step 2. Please note that you will provide your keystore password"
    echo ''

    # Ensure you have your .keystore file on the same directory as the unsigned app and run the script as root
    echo "About to sign your app.. this will take a few seconds..."
    sleep 1s
    echo ''
    echo "------------- PROCESS STARTED -----------------"

    echo "Signing the app..."
    echo ""

    # sign app
    jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ezagent.keystore -storepass $KEYSTORE_PASSWORD $PATH_APP/app-release-unsigned.apk ezpay
    echo "Signing completed...."
    echo ''
    echo "Zip alligning the app...."
    echo ''

    # zip align the app
    /Users/$USER/Library/Android/sdk/build-tools/29.0.2/zipalign -v 4 $PATH_APP/app-release-unsigned.apk signedAppV-$VERSION.apk
    echo ''
    echo "App signed successfully"
    echo ''
    echo "Your app is in the following path: $PWD/signedAppV-$VERSION.apk" 
    echo ""
    echo "------------- PROCESS COMPLETED WITH 0 ERRORS -----------------"


else 
    echo '--debug'
    ionic cordova build android
fi

# echo $BUILD_TYPE
exit

