#
#  MyDocument.rb
#  gisteditor
#
#  Created by Greg Borenstein on 6/2/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

class GEDocument < NSDocument

  attr_accessor :text_view
  attr_accessor :view_contents
  attr_accessor :library
  
  def applicationDidFinishLaunching(notification)
    NSLog("hi friends!")
  end
  
  def textDidChange(notification)
    self.view_contents = self.text_view.textStorage
    postGist(self.view_contents.string, "test")
  end
  
  def loadLibrary
  end
  
  def postGist(gist_content, filename)
    post = "files[#{filename}]=#{gist_content}"
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
    
    delegate = ConnectionDelegate.new(self) do |doc|
      NSLog(doc.rootElement.nodesForXPath('gist/repo', error:nil).first.stringValue)
    end
    
    NSURLConnection.connectionWithRequest(request, delegate:delegate)
  end
  

  def windowNibName
    # Implement this to return a nib to load OR implement
    # -makeWindowControllers to manually create your controllers.
    return "GEDocument"
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
