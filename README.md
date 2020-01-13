# Guzzi-Tracker

Guzzi Tracker is an app that provides to the users the technical specs of (almost) all Moto Guzzi motorcycles manufactured since 1921. The app is entirely written in Swift 5.1 and it uses MVC architecture.

The app was available in version 1.0 on the App Store from september 2018 to december 2019. The app's App Store page is archived and is available [HERE](http://archive.is/Pa68R).
The current app version is 1.1 and presents several differences from the old version available on the App Store.

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Framework and Libraries](#frameworks-and-Libraries)
- [Structure](#structure)

## Framework and Libraries

Internal framework and libraries used:

* Foundation
* UIKit

External libraries used:

* Kingfisher

In the past AlamofireImage was used for managing the download and caching of images. Before Codable (the development of the app started with Swift 3) the Argo library (with Curry and Runes as dependencies) was used for JSON parsing.

The external libraries are managed using Carthage.

## Structure

Guzzi Tracker is structured in two pages, accessible via a tab bar.
