# myFlicks-iOS

**Required User stories**:

* [X] User can view a list of movies currently playing in theaters from The Movie Database.

* [X] Poster images are loaded using the UIImageView category in the AFNetworking library.

* [X] The movie poster is available by appending the returned poster_path to https://image.tmdb.org/t/p/w342.

* [X] User sees a loading state while waiting for the movies API (you can use any 3rd party library available to do this).
      I'm using MBProgressHUD library (Head Up Display) provided by cocoaPods

* [X] User can pull to refresh the movie list.

* [X] User can view movie details by tapping on a cell

* [ ] User can select from a tab bar from either "Now Playing" or "Top Rated" movies

* [ ] Customize the selection effect of the cell


**Additional features**:
* [ ] User sees an error message when there's a networking error. You may not use UIAlertController or a 3rd party library to display the error

* [X] Movies are displayed using a CollectionView instead of a TableView.

* [X] User can search for a movie.
   - Hint: Consider using a UISearchBar for this feature. Don't use the UISearchDisplayController.

* [ ] All images fade in as they are loading.
   - Hint: The image should only fade in if it's coming from network, not when it is loaded from cache.

* [ ] Customize the UI. You can use Iconmonstr and The Noun Project as good sources of images.

* [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.

* [ ] Customize the navigation bar.

## Video Walkthrough
![Video Walkthrough](resources/flicks.gif)

