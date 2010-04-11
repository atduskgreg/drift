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
  attr_accessor :associated_library
  attr_accessor :progressBar
  attr_accessor :progressDescription
  attr_accessor :progressZone
  attr_accessor :gistListScrollView
  attr_accessor :octocatView
  
  attr_accessor :gist_url_copy_button, :update_gist_button, :import_gist_button
  
  def applicationDidFinishLaunching(notification)
    # pass
  end
  
  def windowControllerDidLoadNib(windowController)
    self.octocatView.setImage(GEDocument.octocat_happy)
    self.gist_url_copy_button.setImage(GEDocument.copy_gist_url_button_image)
    self.update_gist_button.setImage(GEDocument.update_gist_image)
    self.import_gist_button.setImage(GEDocument.import_gist_image)

  end
  
  def textDidChange(notification)
    self.view_contents = self.text_view.textStorage
  end
  
  def self.octocat_happy
    @@octocat_happy ||= NSImage.alloc.initWithContentsOfFile(NSBundle.mainBundle.pathForImageResource("octocat_happy"))
  end
  
  def self.copy_gist_url_button_image
    @@copy_gist_url_button_image ||= NSImage.alloc.initWithContentsOfFile(NSBundle.mainBundle.pathForImageResource("comment_48.png"))
  end
  
  def self.update_gist_image
    @@update_gist_image ||= NSImage.alloc.initWithContentsOfFile(NSBundle.mainBundle.pathForImageResource("refresh_48.png"))
  end
  
  def self.import_gist_image
    @@fetch_gist_image ||= NSImage.alloc.initWithContentsOfFile(NSBundle.mainBundle.pathForImageResource("box_download_48.png"))
  end
  
  def pullCurrentGist(sender)
    getGist(current_gist) if current_gist
  end
  
  def copyCurrentGistUrl(sender)
    copy_gist_url(current_gist)
  end
  
  
  # HERE:
  # TODO: new xib for sheet
  def importGists(sender)
    user_url = "http://gist.github.com/api/v1/xml/gists/#{preferences.user.login}"
        
    request = NSMutableURLRequest.alloc.init
    request.setURL(NSURL.URLWithString(user_url))
    thisDoc = self
    delegate = ConnectionDelegate.new(self, "Fetching") do |doc|
      GEGist.build_multiple(doc).each do |gist|
        gist.add(thisDoc)
      end
    end
    
    NSURLConnection.connectionWithRequest(request, delegate:delegate)
    
  end

  
  def copy_gist_url(aGist)
    if aGist
      `echo "http://gist.github.com/#{aGist.gist_id}" | pbcopy`
    end
  end
  
  def octocat_happy
    @octocat_happy ||= GEDocument.octocat_happy
  end
  
  def library
    @library ||= GEGistLibrary.new
  end
  
  def startProgressIndicator(message)
    self.progressDescription.stringValue = message
    self.progressZone.setHidden(false)
    self.progressZone.display
    self.progressBar.startAnimation(self)
  end
  
  def endProgressIndicator
    self.progressZone.setHidden(true)
    self.progressZone.display
    self.progressBar.stopAnimation(self)
  end
  
  def setGist(gist)
    self.text_view.window.setTitle("#{gist.title} - gist.github.com/#{gist.gist_id}")
    
    # fetch the gist body if necessary
    if(!gist.body)
      gist.populate
    end
    self.text_view.setString(gist.body)
    self.current_gist = gist
    NSLog("Gist set to: #{self.current_gist.inspect}")
  end
  
  def reviewUnsavedDocumentsWithAlertTitle(title, cancellable:bool, delegate:myDelegate, didReviewAllSelector:mySelector, contextInfo:sender)
    NSLog("reviewUnsavedDocumentsWithAlertTitle")
  end
  
  def save(menuItem)
    if self.current_gist
      putGist(self.current_gist)
    else # creating a new one
      captureGistTitleName(menuItem)  
    end
  end

  # TODO: add updated_at timestamp  
  def updateGistFromCurrentDocumentState(aGist)
    aGist.body = self.view_contents.string
  end
  
  def updateDocumentStateFromGist(aGist)
    self.text_view.setString(aGist.body)
  end
  

  
  def getGist(aGist)
    aGist.populate_body
    aGist.update(self)
    updateDocumentStateFromGist(aGist)
  end
  
  # TODO: further unify networking code between putGist and postGist
  def putGist(aGist)
    updateGistFromCurrentDocumentState(aGist)
    
    post = "_method=put&file_contents[#{aGist.title}]=#{aGist.body}&file_ext[#{aGist.title}]=.#{aGist.title.split(".").last}&file_name[#{aGist.title}]=#{aGist.title}&login=#{preferences.user.login}&token=#{preferences.user.token}"
    postData = post.dataUsingEncoding(NSASCIIStringEncoding,
                                      allowLossyConversion:true)
    postLength = NSString.stringWithFormat("%d", postData.length)
    request = NSMutableURLRequest.alloc.init
    request.setURL(NSURL.URLWithString("http://gist.github.com/gists/#{aGist.gist_id}"))
    request.setHTTPMethod("POST")
    request.setValue(postLength, forHTTPHeaderField:"Content-Length")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
    request.setHTTPBody(postData)
    
    thisDoc = self
    delegate = ConnectionDelegate.new(self, "Updating gist") do |doc|
      aGist.update(thisDoc)
      thisDoc.text_view.window.setTitle("#{aGist.title} - gist.github.com/#{aGist.gist_id}")
      `echo "http://gist.github.com/#{aGist.gist_id}" | pbcopy`
    end
    
    NSURLConnection.connectionWithRequest(request, delegate:delegate)
  end
  
  def postGist(gist_content, filename)
    post = "files[#{filename}]=#{gist_content}&login=#{preferences.user.login}&token=#{preferences.user.token}"
    postData = post.dataUsingEncoding(NSASCIIStringEncoding,
                                      allowLossyConversion:true)
    postLength = NSString.stringWithFormat("%d", postData.length)
    request = NSMutableURLRequest.alloc.init
    request.setURL(NSURL.URLWithString("http://gist.github.com/api/v1/xml/new"))
    request.setHTTPMethod("POST")
    request.setValue(postLength, forHTTPHeaderField:"Content-Length")
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
    request.setHTTPBody(postData)
    
    thisDoc = self
    delegate = ConnectionDelegate.new(self, "Creating gist") do |doc|
      gist =  GEGist.new_from_xml(doc)
      gist.title = filename
      gist.body = gist_content
      gist.save(thisDoc)
      thisDoc.setGist(gist)
      thisDoc.associated_library.reloadData
      
      # highlight newly created gist (probably a better way out there)
      thisDoc.library.gistsSortedByName.each_with_index do |gist, i|
        if gist["gist_id"] == thisDoc.current_gist.gist_id
          thisDoc.associated_library.selectRowIndexes(NSIndexSet.alloc.initWithIndex(i), byExtendingSelection:false)
        end
      end
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
