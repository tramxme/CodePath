# myFlicks-iOS

**Required User stories**:

* [X] User can view a list of movies currently playing in theaters from The Movie Database.

* [X] Poster images are loaded using the UIImageView category in the AFNetworking library.

* [X] The movie poster is available by appending the returned poster_path to https://image.tmdb.org/t/p/w342.

* [X] User sees a loading state while waiting for the movies API (you can use any 3rd party library available to do this).
      I'm using MBProgressHUD library (Head Up Display) provided by cocoaPods

* [X] User can pull to refresh the movie list.


**Additional features**:
* [ ] User sees an error message when there's a networking error. You may not use UIAlertController or a 3rd party library to display the error. See this screenshot for what the error message should look like.
   - Hint: Using the hidden property of a view can be helpful to toggle the network error view's visibility.
   - Hint: You can simulate a network error, by turning off the wifi on your computer before running the simulator. You will also want to Reset Content and Settings in your simulator (Found under the Simulator drop down menu) before you run the app too, otherwise the images will be fetched from the cache instead of the network. The setImageWithURL method stores images in cache automatically behind the scenes.

* [X] Movies are displayed using a CollectionView instead of a TableView.

* [X] User can search for a movie.
   - Hint: Consider using a UISearchBar for this feature. Don't use the UISearchDisplayController.

* [ ] All images fade in as they are loading.
   - Hint: The image should only fade in if it's coming from network, not when it is loaded from cache.

* [ ] Customize the UI. You can use Iconmonstr and The Noun Project as good sources of images.


## Video Walkthrough
![Video Walkthrough](resources/flicks.gif)

