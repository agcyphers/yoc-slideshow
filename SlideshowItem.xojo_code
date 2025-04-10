#tag Class
Protected Class SlideshowItem
	#tag Method, Flags = &h0
		Sub Constructor(image as Picture)
		  self.Image = image
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(image as Picture, title as String, content as String)
		  self.Image = image
		  self.Title = title
		  self.Content = content
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Invalidate()
		  buffer = nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Sub paint(width as Integer, height as Integer)
		  const padding as Integer = 8
		  
		  '// Buffer exists, we do nothing.
		  if buffer <> nil or width < 1 or height < 1 then Return
		  
		  '// Setup our buffered image
		  buffer = new Picture( width, height )
		  var g as Graphics = buffer.Graphics
		  
		  if mImage <> nil then
		    '// We calculate the dimensions needed for a 
		    '   "cover" effect here to ensure that the image
		    '   drawn always fills the space.
		    var ratioWidth as Double = g.Width / mImage.Width
		    var ratioHeight as Double = g.Height / mImage.Height
		    
		    var scaleFactor as Double = Max( if( ratioWidth > 0, ratioWidth, 1 ), if( ratioHeight > 0, ratioHeight, 1 ) )
		    
		    var backdropWidth as Double = mImage.Width * scaleFactor
		    var backdropHeight as Double = mImage.Height * scaleFactor
		    
		    '// Draw the image.
		    g.DrawPicture( mImage, (g.Width - backdropWidth) / 2, (g.Height - backdropHeight) / 2, backdropWidth, backdropHeight, 0, 0, mImage.Width, mImage.Height )
		  end if
		  
		  '// Calculate overlay position and dimensions.
		  var y as Double = g.Height
		  var w as Double = g.Width - (padding * 2)
		  var contentHeight as Double = if( mContent <> "", g.TextHeight( mContent, w), 0 )
		  var titleHeight as Double = if( mTitle <> "", g.TextHeight, 0 )
		  
		  var backdropHeight as Double = contentHeight + titleHeight + (padding * 3)
		  
		  '// Start drawing here.
		  '   First is the backdrop.
		  if mTitle <> "" and mContent <> "" then
		    if color.IsDarkMode then
		      g.DrawingColor = color.RGB( 0, 0, 0, 165 )
		    else
		      g.DrawingColor = color.RGB( 255, 255, 255, 165 )
		    end if
		    
		    g.FillRectangle( 0, y - backdropHeight, g.Width, backdropHeight )
		    
		    '// Now we setup for drawing the text.
		    if color.IsDarkMode then
		      g.DrawingColor = color.White
		      g.ShadowBrush = new ShadowBrush( 0, 1, color.Black, 1 )
		    else
		      g.DrawingColor = color.Black
		      g.ShadowBrush = new ShadowBrush( 0, 1, color.White, 1 )
		    end if
		    
		    '// Draw content
		    if mContent <> "" then
		      y = y - (contentHeight + g.FontAscent)
		      g.DrawText( mContent, padding, y + g.FontAscent, w, False )
		      y = y - padding
		    end if
		    
		    '// Draw title
		    if mTitle <> "" then
		      y = y - titleHeight
		      var titleWidth as Double = Min( g.Width - (padding * 2), g.TextWidth( mtitle ) )
		      var titleX as Double = (g.Width - titleWidth) / 2
		      g.DrawText( mTitle, titleX, y + g.FontAscent, w, True )
		    end if
		  end if
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Attributes( Hidden ) buffer As Picture
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mContent
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mContent = value
			  
			  '// Invalidate the buffer
			  Invalidate
			End Set
		#tag EndSetter
		Content As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mImage
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mImage = value
			  
			  '// Invalidate the buffer
			  Invalidate
			End Set
		#tag EndSetter
		Image As Picture
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mContent As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mImage As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTitle As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mTitle
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mTitle = value
			  
			  '// Invalidate the buffer
			  Invalidate
			End Set
		#tag EndSetter
		Title As String
	#tag EndComputedProperty


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
			InitialValue="-2147483648"
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
	#tag EndViewBehavior
End Class
#tag EndClass
