<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li> 
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li>
      <a href="#location-features">Location features</a>
      <ul>
        <li><a href="#android">Android</a></li>
        <li><a href="#ios">iOS</a></li>
      </ul>
    </li>
    <li>
      <a href="#basic-map-usage">Basic map usage</a>
      <ul>
        <li><a href="#using-map-events">Using map events</a></li>
        <li><a href="#uploading-markers-on-map">Uploading markers on map</a></li>
        <li><a href="#add-markers-clustering-layer">Add markers clustering layer</a></li>
        <li><a href="#camera-moves">Camera moves</a></li>
      </ul>
    </li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

The <a href="https://docs.2gis.com/">2Gis</a> Map Kit allows you to add a 2GIS map to your Flutter application, and one of its important features is the ability to work cross-platform. This means that you can use this plugin to integrate 2GIS maps into applications created using Flutter on different operating systems, such as Android and iOS. This provides universality and accessibility of your mapping functionality on various devices, making it more convenient for developers and users.

Packages using on platform-side:
* IOS: <a href="https://docs.2gis.com/ru/ios/sdk/overview">2Gis IOS SDK</a>
* Android: <a href="https://docs.2gis.com/ru/android/sdk/overview">2Gis Android SDK</a>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

These are instructions for integrating the package into your application.

### Installation

Get it by running the following command:
* With Flutter
  ```sh
   $ flutter pub add google_maps_flutter
  ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Location features
### Android
Add the `ACCESS_COARSE_LOCATION` or `ACCESS_FINE_LOCATION` permission in the application manifest `android/app/src/main/AndroidManifest.xml` to enable location features in an **Android** application:
```
<manifest ...
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

Starting from Android API level 23 you also need to request it at runtime. This plugin does not handle this for you. The example app uses the flutter ['location' plugin](https://pub.dev/packages/location) for this.

### iOS
To enable location features in an **iOS** application:

If you access your users' location, you should also add the following key to `ios/Runner/Info.plist` to explain why you need access to their location data:

```
xml ...
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>[Your explanation here]</string>
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## Basic map usage

Here are examples of map usage during development.

To obtain the key file, please fill out the form on <a href="https://dev.2gis.ru/order/">dev.2gis.ru</a>

```dart
import "package:dgis_map_kit/dgis_map_kit.dart";

// Simple 2Gis map instantiating

return DGisMap(
  token: token,
  initialCameraPosition: CameraPosition(
    position: Position(
      lat: lat,
      long: long,
    ),
    zoom: 17.0,
  ),
  // ...
),
```

### Using map events

```dart
import 'dart:developer' as log;

// Simple map events usage

return DGisMap(
  // ...
  onUserLocationChanged: (position) => log.log(
    "User location changed: ${position.lat} ${position.long}",
  ),
  markerOnTap: (marker, layerId) => log.log(
    "Marker on tapped event: ${marker.position.lat} ${marker.position.long}",
  ),
  // ...
),
```

### Uploading markers on map

```dart
late MapController controller;
return DGisMap(
  // ...
  mapOnCreated: (controller) => this.controller = controller,
  mapOnReady: () => controller.addMarkers([ 
    // Uploading list of markers to the map.
    Marker(
      icon: icon,
      position: Position(
        lat: lat,
        long: long,
      ),
    ),
    Marker(
      icon: icon,
      position: Position(
        lat: lat,
        long: long,
      ),
    ),
  ]),
  // ...
),
```

### Add markers clustering layer

```dart
return DGisMap(
  // ...
  layers: [
    // Declaring map layer with clustering
    MapLayer.withClustering(
      builder: (markers) => MapClusterer(
        icon: iconAsset,
        iconOptions: MapIconOptions(
          text: markers.length.toString() 
        ),
      ),
      maxZoom: 20.0,
      minDistance: 100.0,
    ),
  ],
  // ...
),
```

### Camera moves

```dart
late MapController controller;
return DGisMap(
  // ...
  mapOnCreated: (controller) => this.controller = controller,
  // Simple camera movement to a marker on tap:
  markerOnTap: (marker) {
    controller.moveCamera(
      controller.currentCameraPosition.copyWith(
        position: marker.position,
      ),
      duration: const Duration(milliseconds: 300),
      animationType: CameraAnimationType.DEFAULT,
    );
  },
  // ...
),
```



<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

jyahann - [@jyahann](https://t.me/jyahann) - raishi24e@gmail.com

Project Link: [https://github.com/jyahann/dgis_map_kit.git](https://github.com/jyahann/dgis_map_kit.git)

<p align="right">(<a href="#readme-top">back to top</a>)</p>