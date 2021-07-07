# **Bluetooth Fetcher**

The goal of the app is to list all named and reachable Bluetooth devices.
It provides also provides a detailed page for each device with a lists of all services and characteristics of the peripheral device if accessible.

⚠️ Even though the app is there to showcase the maximum of information, it is no way exhaustive.

# Pre-requisites

- Xcode 12.5
- Installation of [Swiftlint](https://github.com/realm/SwiftLint) as the default linter for the project
- Installation of [Swiftformat](https://github.com/nicklockwood/SwiftFormat) as a code reformatting tool

# Get started

- Build the app on a device
- Wait for Bluetooth devices to be detected and start appearing on the screen

# Structure of the project

This project was build with SwiftUI/Combine.

It uses a MVVM-Router architecture linked to a dependency injection tool [Resolver](https://github.com/hmlongco/Resolver)

The project is split into 4 main folder:
- App: containing the app entry point and resources
- AppManagement: Containing the dependency injection registration process & the Router
- Common: Containing all Common and reusable components (UI/Repositories/Extensions)
- Scenes: Containing one subfolder per app screen. Each subfolder contains the view and viewModel linked to it.

# Testing

Testing done in this app is just for the purpose of demonstrating how it could be done. This is not a fully tested project. 

# Informations

The dependency injection tool makes use of property wrappers `@Injected` to determine the graph of dependencies.

Lot's of improvements could be aded to the project(some sort of caching/Improved UI/Modularity(Creation of some swift packages for reusable modules)/Logging/ and of course more testing)
