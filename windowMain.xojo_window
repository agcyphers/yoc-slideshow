#tag DesktopWindow
Begin DesktopWindow windowMain
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   False
   HasMinimizeButton=   False
   HasTitleBar     =   True
   Height          =   262
   ImplicitInstance=   False
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   0
   MenuBarVisible  =   False
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   False
   Title           =   "Year of Code, April 2025 - Anthony G. Cyphers"
   Type            =   0
   Visible         =   True
   Width           =   600
   Begin DesktopPagePanel pages
      AllowAutoDeactivate=   True
      Enabled         =   True
      Height          =   273
      Index           =   -2147483648
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      PanelCount      =   2
      Panels          =   ""
      Scope           =   2
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   False
      Tooltip         =   ""
      Top             =   0
      Transparent     =   True
      Value           =   1
      Visible         =   True
      Width           =   600
      Begin DesktopLabel status
         AllowAutoDeactivate=   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "pages"
         Italic          =   False
         Left            =   159
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   2
         Selectable      =   False
         TabIndex        =   0
         TabPanelIndex   =   1
         TabStop         =   True
         Text            =   "Loading Images"
         TextAlignment   =   2
         TextColor       =   &c000000
         Tooltip         =   ""
         Top             =   118
         Transparent     =   True
         Underline       =   False
         Visible         =   True
         Width           =   282
      End
      Begin DesktopProgressBar progress
         AllowAutoDeactivate=   True
         AllowTabStop    =   True
         Enabled         =   True
         Height          =   20
         Indeterminate   =   False
         Index           =   -2147483648
         InitialParent   =   "pages"
         Left            =   159
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         MaximumValue    =   100
         Scope           =   2
         TabIndex        =   1
         TabPanelIndex   =   1
         Tooltip         =   ""
         Top             =   142
         Transparent     =   True
         Value           =   0.0
         Visible         =   True
         Width           =   282
      End
      Begin Slideshow stage
         AllowAutoDeactivate=   True
         AllowFocus      =   False
         AllowFocusRing  =   True
         AllowTabs       =   False
         Backdrop        =   0
         BackgroundColor =   &c000000
         Enabled         =   True
         Height          =   263
         ImageInterval   =   5000
         Index           =   -2147483648
         InitialParent   =   "pages"
         Left            =   0
         LockBottom      =   True
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   True
         LockTop         =   True
         PauseOnHover    =   True
         Scope           =   2
         SelectedItemIndex=   0
         TabIndex        =   0
         TabPanelIndex   =   2
         TabStop         =   True
         Tooltip         =   ""
         Top             =   0
         TransitionLength=   1000
         Transparent     =   False
         Visible         =   True
         Width           =   600
      End
   End
   Begin Thread loader
      Index           =   -2147483648
      LockedInPosition=   False
      Priority        =   5
      Scope           =   2
      StackSize       =   0
      TabPanelIndex   =   0
      Type            =   0
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Function CancelClosing(appQuitting As Boolean) As Boolean
		  stage.Stop
		End Function
	#tag EndEvent

	#tag Event
		Sub Opening()
		  '// Cache our image size for the thread.
		  imageSize = new Size( stage.Width, stage.Height )
		  
		  '// Start the loading thread.
		  loader.Start
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Function randomColor() As Color
		  '// Generate a random color.
		  
		  var r as Random = System.Random
		  Return color.RGB( r.InRange( 100, 200 ), r.InRange( 100, 200 ), r.InRange( 100, 200 ) )
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function randomImage(width as Integer, height as Integer) As Picture
		  '// Generate a random color image.
		  
		  if width <= 0 or height <= 0 then Return nil
		  
		  var result as new Picture( width, height )
		  var g as Graphics = result.Graphics
		  g.DrawingColor = randomColor
		  g.FillRectangle( 0, 0, g.Width, g.Height )
		  
		  Return result
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private imageSize As Size
	#tag EndProperty


	#tag Constant, Name = kLipsum, Type = String, Dynamic = False, Default = \"Lorem ipsum dolor sit amet\x2C consectetur adipiscing elit. Mauris sagittis suscipit sapien\x2C eget auctor arcu tempor eget. Curabitur pharetra libero a dolor luctus\x2C quis varius est maximus. Nulla nec imperdiet augue. Proin eu iaculis elit. Aenean quis iaculis tellus. Integer accumsan nisi lacus\x2C sit amet tincidunt orci consequat vitae. Nulla consequat dolor non ullamcorper suscipit.", Scope = Private
	#tag EndConstant


#tag EndWindowCode

#tag Events status
#tag EndEvents
#tag Events stage
	#tag Event
		Sub Pressed()
		  me.NextSlide
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events loader
	#tag Event
		Sub Run()
		  '// We use this thread to load remote sample
		  '   images from picsum.photos.
		  
		  '// If something goes wrong loading a remote image,
		  '   then we don't try again.
		  var isConnected as Boolean = True
		  
		  '// We'll only load three slides.
		  var max as Integer = 3
		  
		  '// Start our load loop
		  for itemNumber as Integer = 1 to max
		    
		    '// Notify the UI that we're starting the load process.
		    var dUpdate as new Dictionary
		    dUpdate.Value( "state" ) = "Loading"
		    dUpdate.Value( "step" ) = itemNumber
		    dUpdate.Value( "of" ) = max
		    me.AddUserInterfaceUpdate( dUpdate )
		    
		    '// Sleep so that the UI will process the update.
		    me.Sleep( 10 )
		    
		    var image as Picture
		    '// Ensure that we didn't have a previous failure
		    if isConnected then
		      var u as new URLConnection
		      var imageString as String
		      #Pragma BreakOnExceptions False
		      try
		        imageString = u.SendSync( "GET", "https://picsum.photos/" + imageSize.Width.ToString( "#" ) + "/" + imageSize.Height.ToString( "#" ) )
		        if u.HTTPStatusCode = 200 then image = Picture.FromData( imageString )
		      catch ne as NetworkException
		        '// Failed to get a Picsum image. We'll just load a random color image.
		        isConnected = False
		      catch
		        '// Something went wrong. We'll just load a random color image.
		        isConnected = False
		      end try
		      #Pragma BreakOnExceptions Default
		    end if
		    
		    '// If something went wrong earlier, 
		    '   create a random color image.
		    if image = nil then image = randomImage( stage.Width, stage.Height )
		    
		    '// Notify the UI that we have an iamge to add.
		    var dItem as new Dictionary
		    dItem.Value( "state" ) = "Item"
		    dItem.Value( "number" ) = itemNumber
		    dItem.Value( "image" ) = image
		    me.AddUserInterfaceUpdate( dItem )
		    
		    '// Sleep so that the UI will process the update.
		    me.Sleep( 10 )
		  next
		  
		  '// Loading process is complete. Notify the UI.
		  var dComplete as new Dictionary
		  dComplete.Value( "state" ) = "Complete"
		  me.AddUserInterfaceUpdate( dComplete )
		End Sub
	#tag EndEvent
	#tag Event
		Sub UserInterfaceUpdate(data() as Dictionary)
		  '// Here we handle the updates coming from
		  '   inside the thread.
		  
		  for each d as Dictionary in data
		    '// Make sure we have a reported state.
		    '   Should always have this, but it's a sanity check.
		    if d.HasKey( "state" ) = False then Continue
		    
		    '// Determine what to do based on the state.
		    var state as String = d.Value( "state" )
		    select case state
		    case "Loading"
		      '// Thread is reporting that it's started loading
		      '   an image. Either from remote source of a randomly
		      '   generated image.
		      var current as Integer = d.Lookup( "step", 0 ).IntegerValue
		      var max as Integer = d.Lookup( "of", 0 ).IntegerValue
		      status.Text = "Loading Images (" + current.ToString( "#" ) + " of " + max.ToString( "#"  ) + ")"
		      progress.Value = (current / max) * 100
		    case "Item"
		      '// Thread is reporting that an image has been generated.
		      '   We'll add it to the Slideshow component instance.
		      var itemNumber as Integer = d.Value( "number" )
		      var image as Picture = d.Value( "image" )
		      
		      var item as SlideshowItem
		      if itemNumber = 2 then
		        '// Setup a slide with no text content
		        item = new SlideshowItem( image )
		      else
		        '// Slides with text and title.
		        item = new SlideshowItem( image, "Slide " + itemNumber.ToString( "#" ), kLipsum )
		      end if
		      stage.Add( item )
		    case "Complete"
		      '// Done loading. Let's move to the slideshow page
		      '   of the DesktopPagePanel then start the slideshow.
		      pages.SelectedPanelIndex = 1
		      stage.Start
		    end select
		  next
		End Sub
	#tag EndEvent
#tag EndEvents
#tag ViewBehavior
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Super"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasTitleBar"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="2"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Window Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&cFFFFFF"
		Type="ColorGroup"
		EditorType="ColorGroup"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="DesktopMenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
