# android-fastlane-firebase
Image for building android apps  and deploying to Google Play Store and Firebase App Distributions on Gitlab CI 

## Available on [Dockerhub](https://hub.docker.com/r/jpsison/android-fastlane-firebase)
```
image: jpsison/android-fastlane-firebase

... and yours will be here ^_^
```

## Built With
- Android SDK (Target Version 30, Build Tools 30.0.0)
- openjdk-8-jdk
- Ruby
- Fastlane
- Firebase

## Prerequisite
1. Setup your [Fastlane](https://docs.fastlane.tools/getting-started/android/setup/), you will be configuring the setup for Google Play Store Distribution
2. Generate [Firebase CI Token](https://firebase.google.com/docs/cli#cli-ci-systems) and add the token to your build enviroment with the key `FIREBASE_TOKEN`



## Usage
### Firebase App Distribution
The following is an example of lane to create a staging release build and deploy to Firebase App Distribution
```
  desc "Submit a new staging build to Firebase App Distribution"
    lane :stageDeploy do |options|
      if options[:group]
        build_android_app(
          task: "assemble",
          flavor: "stage",
          build_type: "release"
        )

        firebase_app_distribution(
            app: "<your-app-id-here>",
            groups: options[:group], //we usually notify our testers when a new build is available, you can create group on firebase console
            release_notes_file: "./release-notes.txt",
            firebase_cli_path:  "/usr/local/bin/firebase"
        )
      else
        UI.user_error!("Missing group name!")
      end
    end
```
And then you can run `fastlane stageDeploy group:internal-testers` or you can just simply run `fastlane stageDeploy` but will cause an error since group name is required on the code above, you might need to adjust them according to your needs.


### Google Play Distribution
The following is an example of lane to submit a build and deploy to Google Play internally, given that you already built the .apk 
```
  desc "Submit a new Internal Build to Play Store"
  lane :internal do
    upload_to_play_store(track: 'internal', apk: 'app/build/outputs/apk/production/playstore/app-production-playstore.apk')
  end
```
With the example given, your options are not limited in deploying to Play Store, you can read more about deploying to Google Play [here](https://docs.fastlane.tools/getting-started/android/setup/)

# Authors

* [Jaype Sison](https://github.com/jpsison-io)

# Acknowledgement

* [unitedclassifiedsapps](https://github.com/unitedclassifiedsapps) for using [gitlab-ci-android-fastlane](https://github.com/unitedclassifiedsapps/gitlab-ci-android-fastlane) as a reference

# License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
