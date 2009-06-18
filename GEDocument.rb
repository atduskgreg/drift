#
#  MyDocument.rb
#  gisteditor
#
#  Created by Greg Borenstein on 6/2/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

class GEDocument < NSDocument

  attr_accessor :text_view
  attr_accessor :view_contents, :gist_title
  attr_accessor :gist_title_window
  attr_accessor :current_gist
  
  def applicationDidFinishLaunching(notification)
    # pass
  end
  
  def textDidChange(notification)
    NSLog(self.inspect)
    self.view_contents = self.text_view.textStorage
  end
  
  def library
    @library ||= GEGistLibrary.new
  end
  
  def postGist(gist_content, filename)
    post = "files[#{filename}]=#{gist_content}&login=atduskgreg&token=1d84af3a6008854ade82ec7d242e7b3a"
    postData = post.dataUsingEncoding(NSASCIIStringEncoding,
                                      allowLossyConversion:true)
    NSLog(post)
    postLength = NSString.stringWithFormat("%d", postData.length)
    request = NSMutableURLRequest.alloc.init
    request.setURL(NSURL.URLWithString("http://gist.github.com/api/v1/xml/new"))
    request.setHTTPMethod("POST")
    request.setValue(postLength, forHTTPHeaderField:"Content-Length")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
    request.setHTTPBody(postData)
    
    thisDoc = self
    delegate = ConnectionDelegate.new(self) do |doc|
      gist =  GEGist.new_from_xml(doc)
      gist.title = filename
      gist.save(thisDoc)
      thisDoc.current_gist = gist
      thisDoc.text_view.window.setTitle("#{filename} - gist.github.com/#{gist.gist_id}")
      `echo "http://gist.github.com/#{gist.gist_id}" | pbcopy`
    end
    
    NSURLConnection.connectionWithRequest(request, delegate:delegate)
  end
  
  def windowNibName
    # Implement this to return a nib to load OR implement
    # -makeWindowControllers to manually create your controllers.
    return "GEDocument"
  end

  def actuallySendGist(sender)
    NSLog("posting gist")
    postGist(self.view_contents.string, self.gist_title.stringValue)
    NSApp.endSheet(gist_title_window)
    
    gist_title_window.orderOut(sender)
  end
  
  def captureGistTitleName(sender)
    NSApp.beginSheet(gist_title_window, 
                    modalForWindow:text_view.window,
                    modalDelegate:nil,
                    didEndSelector:nil,
                    contextInfo:nil)
  end
  
  def hideSaveDialog(sender)
    NSLog "Cancelled save dialog"
    NSApp.endSheet(gist_title_window)
    gist_title_window.orderOut(sender)
  end

  def dataRepresentationOfType(type)
    # Implement to provide a persistent data representation of your
    # document OR remove this and implement the file-wrapper or file
    # path based save methods.
    return nil
  end

  def loadDataRepresentation(data, ofType:type)
    # Implement to load a persistent data representation of your
    # document OR remove this and implement the file-wrapper or file
    # path based load methods.
    return true
  end

end
