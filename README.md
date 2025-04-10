# Year of Code Slideshow
This is my submission for the April 2025 Xojo Year of Code April.

It's a simple slideshow component with just a few methods.

Functionality Showcased:
- Threaded loading
- Loading images from a remote source
- Simple sliding transitions
- Mouse interactions
- Random color generation (and images)
- Using runtime generated timers
- Dark/Light Mode painting

## API
### Slideshow Class
#### Events
Name | Parameters | Return Type | Description
--- | --- | --- | ---
Pressed | None | None | Raised when the user clicks the Slideshow component's display.

#### Methods
Name | Parameters | Return Type | Description
--- | --- | --- | ---
Add | item as SlideshowItem | None | Adds a new SlideshowItem class instance to the Slideshow stack.
NextSlide | None | None | Initiates a transition to the next slide in the stack.
Start | None | None | Starts the Slideshow timer that controls stack movement.
Stop | None | None | Stops the Slideshow timer that controls stack movement.

#### Properties
Name | Type | Default Value | Description
--- | --- | --- | ---
BackgroundColor | ColorGroup | Nil | Color drawn to the stage behind slide images.
ImageInterval | Integer | 5000 | Time in milliseconds to wait between slide transitions.
PauseOnHover | Boolean | True | Will pause movement between slides (but not current transitions) when the user hovers their mouse over the display.
TransitionLength | Integer | 1000 | Length of time in milliseconds for each transition.

### SlideShowItem Class
#### Constructors
```xojo
var newItem = new SlideshowItem( image as Picture )
```
```xojo
var newItem = new SlideshowItem( image as Picture, title as String, content as String )
```

#### Methods
Name | Parameters | Return Type | Description
--- | --- | --- | ---
Invalidate | None | None | Signals that the slide needs to be redrawn.

#### Properties
Name | Type | Default Value | Description
--- | --- | --- | ---
Content | String | "" | Content text drawn at the bottom of the slide.
Image | Picture | Nil | Image drawn to the display.
Title | String | "" | Title text drawn at the bottom of the slide.
