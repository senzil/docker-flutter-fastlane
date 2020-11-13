FROM openjdk:8-jdk

ENV ANDROID_COMPILE_SDK="29"
ENV ANDROID_BUILD_TOOLS="29.0.0"
ENV ANDROID_SDK_TOOLS="3859397"
ENV FLUTTER_CHANNEL="stable"
ENV FLUTTER_VERSION="1.22.2-${FLUTTER_CHANNEL}"
ENV ANDROID_HOME="$PWD/android-sdk-linux"
ENV PATH="$PATH:$PWD/android-sdk-linux/platform-tools/"
ENV PATH="$PATH:$PWD/flutter/bin"

RUN apt-get update
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1
RUN apt-get install build-essential --yes
RUN apt-get install ruby-full --yes
RUN apt-get install ruby-dev --yes
RUN apt-get install rubygems --yes
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip
RUN wget --output-document=flutter-sdk.tar.xz https://storage.googleapis.com/flutter_infra/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}.tar.xz
RUN unzip -d android-sdk-linux android-sdk.zip
RUN tar -xf flutter-sdk.tar.xz
RUN yes | android-sdk-linux/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" >/dev/null || true 
RUN yes | android-sdk-linux/tools/bin/sdkmanager "platform-tools" >/dev/null || true
RUN yes | android-sdk-linux/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" >/dev/null || true
RUN yes | android-sdk-linux/tools/bin/sdkmanager --licenses
RUN gem install fastlane -NV
RUN gem install bundler
RUN fastlane run bundle_install