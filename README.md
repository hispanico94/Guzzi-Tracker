# Guzzi-Tracker

Guzzi Tracker is an app that provides to the users the technical specs of (almost) all Moto Guzzi motorcycles manufactured since 1921. The app is entirely written in Swift 5.1 and it uses MVC architecture.

The app was available in version 1.0 on the App Store from september 2018 to december 2019. The app's App Store page is archived and is available [HERE](http://archive.is/Pa68R).
The current app version is 1.1 and presents several differences from the old version available on the App Store. The structure has been simplified by removing the *search* tab (the search functionality is now embedded in the first tab). The app fully supports Dark Mode and animated table view data source diffing (on iOS 13), better handling of images and better support iPads, with split view controllers and readable width and several other small improvements.

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

Guzzi Tracker is structured in two pages, accessible via a tab bar:

* *Motorcycles*
* *Garage*

The view controllers' files are all available in the `ViewControllers` folder. All the table views' cells are defined in files stored in the `Cell` folder.

### *Motorcycles*

The Motorcycle tab is handled by a UITableViewController subclass called `MotorcyclesViewController`. This view controller is embedded in a navigation controller.

The table view shows a list of all the Moto Guzzi motorcycles manufactured starting from the most recent. The cells are instances of `MotorcycleCell`.

Tapping on a cell a `MotorcycleInfoViewController` is pushed onto the navigation stack. This new view controller is a subclass of UITableViewController. This view controller shows the previously selected motorcycle's tech specs and information. The specs are grouped by section. The cells used in this table view are instances of `MotorcycleInfoCell`, `MotorcycleNotesCell` and `MotorcycleImagesCell`.

On the navigation bar there is a heart-shaped button that let the user "save" the motorcycle, which it will be available in the *Garage* tab.

If images are available for a motorcycle an "Images" section with a single row would be available at the end of the table view.

By tapping on the cell an instance of `ImagesViewController` is pushed onto the navigation stack. This new view controller is a subclass of UITableViewController. The table view shows a series of images in `ImageCell` cells. The loading and caching of images is handled by the Kingfisher library which shows an UIActivityIndicator as a loading indicator during the image fetching. All the images are hosted on Flickr.

Tapping an image presents modally a `SingleImageViewController` which shows the image full screen. Here it's possible to zoom-in the image and tapping the "Close" button on the top-left corner will dismiss the view controller.

#### Filtering and ordering the motorcyles list

The motorcycle list in `MotorcyclesViewController` can be ordered and filtered according to multiple criteria, and the criteria can be combined together to obtain complex results.

In the `MotorcyclesViewController` tapping on the funnel icon on the navigation bar will present modally a `FiltersViewController` view controller. This view controller is a subclcass of UITableViewController and it's embedded in a navigation controller. The table view is composed of two sections: *Filters* and *Ordering*.

*Filters* groups several filtering criteria. Tapping on a cell [TODO: INSERT TYPES] a new view controller is pushed and here the user can select a range or a list of elements to include in the filtering. The elements and the ranges are extracted from the motorcycle list model (see `MotorcycleData` in *Data.swift*, the filters available in `Elements/Filter` and `MotorcycleElements` in *Elements.swift*). The view controllers for the filtering are available in `ViewControllers/Filers View Controllers`.

*Ordering* allows the user to selects more the one criteria to how order the list. The default criteria is by descending year of manufacturing, but it's possible to select one or more criteria. The order on which they are applied depends on the order on which they are selected by the user. The list ordering can also be applied along any applied filter. The source code for the ordering is available in the files listed in the `Elements/Order` folder. The view controller is the `ComparatorsViewController`

The filtering and ordering logic on which they work is based on some **functional programming** concept described by Brandon Williams in his blog article titled [The Algebra of Predicates and Sorting Functions](https://www.fewbutripe.com/swift/math/algebra/monoid/2017/04/18/algbera-of-predicates-and-sorting-functions.html). The reason of this choice resides on the composability of the filtering and ordering functions and in the sheer curiosity of exploring this programming paradigm.

### *Garage*

The second tab, *Garage* shows the list of all the motocycles saved by the user by tapping on the heart-shaped icon visible on the navigation bar of the `MotorcycleInfoViewController`. This view is handled by the `MyGarageViewController`, a subclass of UITableViewController. Tapping on a cell will have the same behavior described in `MotorcyclesViewController`.

The list can be reordered as the user prefers and the rows can also be deleted (using standard UITableView behavior and delegate calls). Deleting a row will remove the associated motorcycle from the list of favorites.

The favorites list is handled by the use of a **singleton** called `FavoritesList` (in `Elements/FavoritesList`). This class saves user-selected motorcycles' `id`s in the *UserDefaults* and the `MyGarageViewController` fetches the ids in the `viewWillAppear(_:)` and so updates the list every time the view controller will appear, making the list always updated.

On the left of the navigation bar there is an *i* button. When tapped an `InfoViewController` is presented modally that contains few infos about the app and developer's contacts.

## Data management

The app use no database for data persistency. All the data needed is stored in a JSON file called *info_moto.json*. The data management is handled by the class `MotorcycleData` and struct `DataManager` defined in the Elements/Data.swift file. MotorcycleData acts as an interface and manager to the rest of the app, DataManager handles the http request, storing locally and fetching the json file and data extraction from the file.

When the app is launched for the first time the *info_moto.json* is copied from the bundle to the app's *LibraryDirectory*. After that the json is read and decoded and the array of `Motorcycle`, containing all the data about the motorcycles, is available to the rest of the app.

The data updating is done by checking the json's version stored in a GitHub Gist [TODO: MAYBE REVERT TO LOCAL REPOSITORY]. The version value is stored in a `value` key in the json's root object. If the version of the remote file is greater than the version of the local file the latter is replaced by the newer in the LibraryDirectory.
The http request is handled with a simple URLSession dataTask. See `DataManager.checkForUpdatedJson(currentVersion:)` method definition for reference.

If a new version of the file was found and saved the MotorcycleData receives the new json by assignment to a property and via a didSet observer an update of the `Motorcycle` list and values of filters is triggered. The update is propagated in the app thanks to the `Ref` class that holds references to closures defined in the various view controllers that need the array of `Motorcycle` and the closures are called with the new value of the array.

## Localization
