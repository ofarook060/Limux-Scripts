#!/bin/bash

# aapt2 binary path for Termux
android.aapt2FromMavenOverride=/data/data/com.termux/files/usr/bin/aapt2

org.gradle.java.home=/usr/lib/jvm/java-xx-openjdk

/data/data/com.termux/files/usr/opt/Android/sdk/


ALL=(ALL) NOPASSWD: ALL



export ANDROID_HOME="$HOME/dev/android_sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools/adb"
export PATH="$PATH:$ANDROID_HOME/build-tools/36.0.0"
#export JAVA_HOME="/usr/lib/jvm/java-17-openjdk"
export GRADLE_HOME="$HOME/dev/gradle-9.3.1"
export PATH="$PATH:$GRADLE_HOME/bin"
#export FLUTTER_SDK="$HOME/dev/flutter"
#export PATH="$PATH:$FLUTTER_SDK/bin"


