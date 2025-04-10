#tag Class
Protected Class Slideshow
Inherits DesktopCanvas
	#tag Event
		Sub Activated()
		  '// Do not implement
		End Sub
	#tag EndEvent

	#tag Event
		Sub Closing()
		  #Pragma BreakOnExceptions False
		  try
		    if slideTimer <> nil then
		      slideTimer.RunMode = timer.RunModes.Off
		      RemoveHandler slideTimer.Action, AddressOf onNextSlide
		    end if
		    if transitionTimer <> nil then
		      transitionTimer.RunMode = timer.RunModes.Off
		      RemoveHandler transitionTimer.Action, AddressOf onTransitionProgress
		    end if
		  catch
		    '// A failure of any type doesn't much matter
		    '   here. We're closing and disposing of everything
		  end try
		  #Pragma BreakOnExceptions True
		End Sub
	#tag EndEvent

	#tag Event
		Sub Deactivated()
		  '// Do not implement
		End Sub
	#tag EndEvent

	#tag Event
		Function DragEnter(obj As DragItem, action As DragItem.Types) As Boolean
		  '// Do not implement
		End Function
	#tag EndEvent

	#tag Event
		Sub DragExit(obj As DragItem, action As DragItem.Types)
		  '// Do not implement
		End Sub
	#tag EndEvent

	#tag Event
		Function DragOver(x As Integer, y As Integer, obj As DragItem, action As DragItem.Types) As Boolean
		  '// Do not implement
		End Function
	#tag EndEvent

	#tag Event
		Sub DropObject(obj As DragItem, action As DragItem.Types)
		  '// Do not implement
		End Sub
	#tag EndEvent

	#tag Event
		Sub FocusLost()
		  '// Do not implement
		End Sub
	#tag EndEvent

	#tag Event
		Sub FocusReceived()
		  '// Do not implement
		End Sub
	#tag EndEvent

	#tag Event
		Function KeyDown(key As String) As Boolean
		  '// Do not implement
		End Function
	#tag EndEvent

	#tag Event
		Sub KeyUp(key As String)
		  '// Do not implement
		End Sub
	#tag EndEvent

	#tag Event
		Sub MenuBarSelected()
		  '// Do not implement
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Sub MouseDrag(x As Integer, y As Integer)
		  '// Do not implement
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseEnter()
		  '// We store the hover state to support PauseOnHover.
		  isHovered = True
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseExit()
		  '// We store the hover state to support PauseOnHover.
		  isHovered = False
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseMove(x As Integer, y As Integer)
		  '// Do not implement
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseUp(x As Integer, y As Integer)
		  '// Ensure that the mouse is released within the display.
		  if x >= 0 and x <= self.Width and _
		    y >= 0 and y <= self.Height then
		    
		    '// Cache the PauseOnHover so that users
		    '   can click to navigate
		    var isPauseOnHover as Boolean = PauseOnHover
		    PauseOnHover = False
		    
		    '// Raise the Pressed event.
		    RaiseEvent Pressed
		    
		    '// Reapply PauseOnHover
		    PauseOnHover = isPauseOnHover
		    
		  end if
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseWheel(x As Integer, y As Integer, deltaX As Integer, deltaY As Integer) As Boolean
		  '// Do not implement
		End Function
	#tag EndEvent

	#tag Event
		Sub Opening()
		  '// Create our timers here.
		  
		  '// slideTimer controls progression in the image
		  '   stack. It's Off by default as the control
		  '   requires calling the Start method. 
		  slideTimer = new Timer
		  slideTimer.Period = mImageInterval
		  slideTimer.RunMode = timer.RunModes.Off
		  AddHandler slideTimer.Action, AddressOf onNextSlide
		  
		  '// transitionTimer controls the display refreshing
		  '   during the transition from one image to another.
		  transitionTimer = new Timer
		  transitionTimer.Period = 20
		  AddHandler transitionTimer.Action, AddressOf onTransitionProgress
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  g.DrawingColor = Color.Black
		  if mBackgroundColor <> nil then g.DrawingColor = mBackgroundColor
		  g.FillRectangle( 0, 0, g.Width, g.Height )
		  
		  if items.LastIndex < 0 then Return
		  
		  if mSelectedItemIndex < 0 then mSelectedItemIndex = 0
		  var selectedItem as SlideshowItem = items( mSelectedItemIndex )
		  var nextItem as SlideshowItem = if( mSelectedItemIndex < items.LastIndex, items(mSelectedItemIndex + 1), items(0) )
		  
		  var slidePosition as Double = -((g.Width / 100) * transitionProgress)
		  
		  if selectedItem.buffer = nil then selectedItem.paint( g.Width, g.Height )
		  if nextItem.buffer = nil then nextItem.paint( g.Width, g.Height )
		  
		  g.DrawPicture( selectedItem.buffer, slidePosition, 0, g.Width, g.Height, 0, 0, selectedItem.buffer.Width, selectedItem.buffer.Height )
		  if slidePosition < 0 then g.DrawPicture( nextItem.buffer, slidePosition + g.Width, 0, g.Width, g.Height, 0, 0, nextItem.buffer.Width, nextItem.buffer.Height )
		End Sub
	#tag EndEvent

	#tag Event
		Sub ScaleFactorChanged()
		  Refresh
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Add(item as SlideshowItem)
		  '// This method adds a new item to display.
		  items.Add( item )
		  
		  if mSelectedItemIndex < 0 then
		    '// Validate SelectedItemIndex
		    mSelectedItemIndex = 0
		    Refresh
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NextSlide()
		  '// Already transitioning to the next slide.
		  '   Do nothing.
		  if isTransitioning then Return
		  
		  '// Transition to the next slide.
		  slideTimer.RunMode = timer.RunModes.Off
		  onNextSlide( slideTimer )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub onNextSlide(sender as Timer)
		  '// We need to start a new transition, but only
		  '   if the mouse isn't hovering when PauseOnHover
		  '   equals True.
		  if PauseOnHover and isHovered then Return
		  
		  '// Reset our transition status property values.
		  transitionProgress = 0
		  transitionStart = System.Microseconds / 1000
		  
		  '// Stop this timer.
		  sender.RunMode = timer.RunModes.Off
		  
		  '// Start the transition.
		  isTransitioning = True
		  transitionTimer.RunMode = timer.RunModes.Multiple
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub onTransitionProgress(sender as Timer)
		  '// Breaking down the math here so that it's easier to understand.
		  
		  '// Get the current time in milliseconds.
		  var current as Double = System.Microseconds / 1000
		  '// Get the expected transition end time.
		  var endValue as Double = transitionStart + TransitionLength
		  '// Calculate the difference between now and end.
		  var difference as Double = endValue - current
		  '// Calculate the progress of the transition.
		  transitionProgress = 100 - ((difference / TransitionLength) * 100)
		  
		  if transitionProgress >= 100 then
		    '// Transition has completed. We reset for the next one.
		    isTransitioning = False
		    transitionProgress = 0
		    
		    '// Stop this timer and start the timer controlling
		    '   movement in the image stack.
		    sender.RunMode = timer.RunModes.Off
		    
		    '// We use multiple to support PauseOnHover
		    slideTimer.RunMode = timer.RunModes.Multiple
		    
		    '// Update the SelectedItemIndex
		    mSelectedItemIndex = mSelectedItemIndex + 1
		    if mSelectedItemIndex > items.LastIndex then mSelectedItemIndex = 0
		  end if
		  
		  '// Force a refresh to ensure that our frames get drawn.
		  self.Refresh( True )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Start()
		  '// Let's do some sliding.
		  slideTimer.RunMode = timer.RunModes.Multiple
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Stop()
		  '// No more sliding.
		  slideTimer.RunMode = timer.RunModes.Off
		  isTransitioning = False
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Pressed()
	#tag EndHook


	#tag Note, Name = License
		
		MIT License
		
		Copyright (c) 2025 Anthony G. Cyphers
		
		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:
		
		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.
		
		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mBackgroundColor
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mBackgroundColor = value
			  
			  Refresh
			End Set
		#tag EndSetter
		BackgroundColor As ColorGroup
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mImageInterval
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if value < 250 then value = 250
			  
			  mImageInterval = value
			  
			  if slideTimer <> nil then slideTimer.Period = value
			End Set
		#tag EndSetter
		ImageInterval As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private isHovered As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private isTransitioning As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private items() As SlideshowItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mBackgroundColor As ColorGroup
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mImageInterval As Integer = 5000
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSelectedItemIndex As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h0
		PauseOnHover As Boolean = True
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mSelectedItemIndex
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  '// Perform some validation to prevent users from
			  '   shooting themselves in the foot.
			  if value > items.LastIndex then value = items.LastIndex
			  
			  mSelectedItemIndex = value
			End Set
		#tag EndSetter
		SelectedItemIndex As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private slideTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h0
		TransitionLength As Integer = 1000
	#tag EndProperty

	#tag Property, Flags = &h21
		Private transitionProgress As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private transitionStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private transitionTimer As Timer
	#tag EndProperty


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
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="Integer"
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowAutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Tooltip"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="BackgroundColor"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="ColorGroup"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocus"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowTabs"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PauseOnHover"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ImageInterval"
			Visible=true
			Group="Behavior"
			InitialValue="5000"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TransitionLength"
			Visible=true
			Group="Behavior"
			InitialValue="1000"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SelectedItemIndex"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Visible=false
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
