# Reddit Top Viewer

## Main functionality

* Displays top Reddit posts
* On cell tap opens post link is SFSafariViewController (image or post)
* On cell long tap gives ability to save post image or open link


## Details

* Supports paging and reloading all content
* Supports landscape
* Supports all iPhone/iPad screen sizes and interface orientations


## Implementation details

* Swift 3 and XCode 8 (Swift 4 and XCode 9 is still in beta, so I decided not to use them in this test task)
* No thirdparty frameworks or libraries were used
* Some functional swift approaches were applied (`Result.swift` for example)


## Architectural approaches

* MVVM-Coordinator as the main architectural approach
* Simple dependency injection in `ViewModels` and some `Coordinators` (as no frameworks are allowed)
* Protocol driven development in main services for easier testing (though no unit tests are present for now as none requested)

