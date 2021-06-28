# Contributing

First of all, thank you for thinking about contributing. 🔥

You're more than welcome to contribute to the project. When contributing, please keep in mind that the project is open source, therefore is maintained by several people - your code should be simple and readable. If there's a specific question you need to discuss with someone, please join [our Slack](https://communityinviter.com/apps/fogospt/fogos-pt).

## How to Contribute

First of all, you should join [our Slack](https://communityinviter.com/apps/fogospt/fogos-pt), if you haven't already. Joining Slack is a great opportunity to meet the contributors of [FogosPT](https://github.com/FogosPT) projects and to discuss how you can help.

When you decide to contribute, gives us a shout at Slack so we can add you to the contributors (it's easy for us to test and validate your contributions if you branch of our repo than forking to your own repo).

If you already know us, take a look at the issues and take a stab at them. We'll try to make the issue as verbose as possible, so it is easy for you to help. When you're done, create a Pull Request (on the PR's description, you should include `closes #<issue-number>` so you know what issue you're fixing and to make sure the issue is closed when we merge your PR).

If you have a suggestion of a feature or a thing that should be improved, speak with us on Slack. We'll be more than happy to listen to your thoughts.

You don't need to code to help us. If you see some bugs or other things that could be better, open an issue on Github.

## Setup and run project

This app is built with Flutter and Dart 2, follwing Redux's design Pattern.

Make sure you have installed Flutter following [these instructions](https://flutter.io/get-started/install/).

**Important**: We use the `stable` Flutter channel. Make sure you are on the same channel running

```shell
flutter channel stable
```

Clone our repo and check `flutter doctor`

```shell
git clone https://github.com/FogosPT/fogosmobile
cd fogosmobile
flutter doctor
```

Fix anything `flutter doctor` asks.

Now, you need configure some files and tokens to run app

### Configure key.properties (android/key.properties)

If file key.properties is created, ⚠ only if created, you need add some variables to run app

```shell
# Config to firebase notifications
FCI_KEYSTORE_PASSWORD=myKeystorePassword
FCI_KEY_ALIAS=MyReleaseKey
FCI_KEY_PASSWORD=myKeypassword
# Config to create Android release
storePassword=MyStorePassword
keyPassword=MyKeyPassword
keyAlias=MyKeyAlias
storeFile=MyStoreFileRoute
```

This file is on `.gitignore` so it shouldn't show up on `git status`. If it does, be sure to not commit that file.
After that, everything should be working normally.

### Configure mapbox

Mapbox is a feature to use map into app. To use mapbox, you need config some enviroment variables and token. Follow [this Android page](https://docs.mapbox.com/android/maps/guides/install/) and [this iOS page](https://docs.mapbox.com/ios/maps/guides/) or this steps:

- Create a mapbox account [here](https://account.mapbox.com/auth/signup/)
- Create a API Token with all secret scopes selected ([ref](https://user-images.githubusercontent.com/21011641/122591350-240b6b80-d063-11eb-8f9b-a0228b65f321.png))
- Add two enviroment variables into your OS. A variable with name `SDK_REGISTRY_TOKEN` and other with name `MAPBOX_DOWNLOADS_TOKEN`, both with same value: the api token generate in previous step. This is necessary because [this issue](https://github.com/tobrun/flutter-mapbox-gl/issues/604) with flutter-mapbox package
- Replace `MAPBOX_DOWNLOADS_TOKEN` in `android/main/res/values/strings.xml` with the same api token generated in mapbox page

### Run project

Make sure you have a device connected (Simulator or Emulator or a real device connected) and then run

```shell
flutter pub get
flutter run
```

If when run don't work, please try this steps:

- Run `flutter clean`
- Reset your code editor (VS Code or Android Studio or whatever)

## Reading material

If you want to know more about Dart and Flutter, follow this useful links:

- [Flutter FTW: Top Articles about Flutter](https://blog.goposse.com/flutter-ftw-top-articles-about-flutter-fec6f365ef81)
- [Flutter — It’s Easy to Get Started](https://medium.com/@westdabestdb/flutter-its-easy-to-get-started-995eb20c54a1)
- [What’s Revolutionary about Flutter](https://hackernoon.com/whats-revolutionary-about-flutter-946915b09514)
- [The Fluture is Now!](https://medium.com/@lets4r/the-fluture-is-now-6040d7dcd9f3)

----

- About Redux - [Introduction to Redux in Flutter](https://blog.novoda.com/introduction-to-redux-in-flutter/)

----

- [Flutter Create: A back-end dev gets Flutter running for the first time](https://blog.goposse.com/flutter-create-a-back-end-dev-gets-flutter-running-for-the-first-time-3185041bf380)
- [Flutter: How I built a simple app in under an hour from scratch. And how you can do it too.](https://proandroiddev.com/flutter-how-i-built-a-simple-app-in-under-an-hour-from-scratch-and-how-you-can-do-it-too-6d8e7fe6c91b)
- [Flutter: Bookshelf App Part 2, Personal Notes and Database Integration](https://proandroiddev.com/flutter-bookshelf-app-part-2-personal-notes-and-database-integration-a3b47a84c57) (continuation of the previous article)

----

- [Flutter: Introduction of Routing and navigation](https://medium.com/@kpbird/flutter-introduction-of-routing-and-navigation-49738dbd6abe)
- [Getting Your Hands Dirty with Flutter: Basic Animations](https://proandroiddev.com/getting-your-hands-dirty-with-flutter-basic-animations-6b9f21fa7d17)
- [How to use dynamic home page in Flutter?](https://medium.com/@anilcan/how-to-use-dynamic-home-page-in-flutter-83080da07012)
- [Reactive app state in Flutter](https://medium.com/@maksimrv/reactive-app-state-in-flutter-73f829bcf6a7)
- [Inheriting Widgets](https://medium.com/@mehmetf_71205/inheriting-widgets-b7ac56dbbeb1)

----

- [A new Flutter app: from flutter create to the app store](https://proandroiddev.com/a-new-flutter-app-from-flutter-create-to-the-app-store-e6c2dee17c1a)
- [Flutter hands on: Building a News App](https://blog.geekyants.com/flutter-hands-on-building-a-news-app-fe233027185f)
- [How to build a Cryptocurrency price list app using Flutter SDK](https://medium.freecodecamp.org/how-to-build-a-cryptocurrency-price-list-app-using-flutter-sdk-1c75998e1a58)

----

- [Flutter : From Zero To Comfortable](https://proandroiddev.com/flutter-from-zero-to-comfortable-6b1d6b2d20e)
- [Flutter 1: Navigation Drawer & Routes](https://engineering.classpro.in/flutter-1-navigation-drawer-routes-8b43a201251e)
- [Flutter 2: Dynamic Drawer List, Stateful Widgets, Forms and Validation](https://engineering.classpro.in/flutter-2-dynamic-drawer-list-stateful-widgets-forms-and-validation-6389fc625d2e)

----

- [Building WhatsApp UI with Flutter Io and Dart](https://medium.com/@Nash_905/building-whatsapp-ui-with-flutter-io-and-dart-1bb1e83e7439)
- [Building WhatsApp Ui with Flutter Part 2 : The Chat List](https://medium.com/@Nash_905/building-whatsapp-ui-with-flutter-part-2-the-chat-list-ad6e5fce5ba1)

----

- Really awesome [Dart & Flutter Tutorial Series by Tensor Programming on Youtube](https://www.youtube.com/watch?v=WwhyaqNtNQY&list=PLJbE2Yu2zumDqr_-hqpAN0nIr6m14TAsd) and here is his [GitHub](https://github.com/tensor-programming?utf8=%E2%9C%93&tab=repositories&q=&type=&language=dart)

----

### Still have a question?

If you need to know anything that is not on this document, feel free to reach out via [Slack](https://communityinviter.com/apps/fogospt/fogos-pt) or [Twitter](https://twitter.com/fogosPT).
