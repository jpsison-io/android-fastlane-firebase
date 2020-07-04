FROM phusion/baseimage:master
LABEL maintainer="Jaype Sison <dev.jpsison@gmail.com>"

CMD ["/sbin/my_init"]

ENV LC_ALL "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"
ENV LANG "en_US.UTF-8"

ENV VERSION_SDK_TOOLS "4333796"
ENV VERSION_BUILD_TOOLS "22.0.1"
ENV VERSION_TARGET_SDK "22"

ENV ANDROID_SDK_ROOT "/android-sdk"

ENV PATH "$PATH:${ANDROID_SDK_ROOT}/tools:${ANDROID_SDK_ROOT}/tools/bin:${ANDROID_SDK_ROOT}/platform-tools"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get update && apt-get install -y ruby \
    ruby-dev \
    unzip \
    openjdk-8-jdk \
    build-essential

RUN ruby --version

ADD https://dl.google.com/android/repository/sdk-tools-linux-${VERSION_SDK_TOOLS}.zip /tools.zip
RUN unzip /tools.zip -d $ANDROID_SDK_ROOT && rm -rf /tools.zip

RUN mkdir -p /root/.android && touch /root/.android/repositories.cfg
RUN ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager "platform-tools" "tools" "platforms;android-${VERSION_TARGET_SDK}" "build-tools;${VERSION_BUILD_TOOLS}"
RUN ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository"

RUN yes | ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager --licenses

# Install Fastlane [Issue](https://github.com/fastlane/fastlane/issues/338)
RUN gem install rake
RUN gem install fastlane -NV
RUN fastlane update_fastlane

# Install Firebase CLI
RUN curl -Lo /usr/local/bin/firebase https://firebase.tools/bin/linux/latest
RUN chmod +x /usr/local/bin/firebase

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*