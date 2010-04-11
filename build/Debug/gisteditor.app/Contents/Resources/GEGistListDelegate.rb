#
#  GEGistListDelegate.rb
#  gisteditor
#
#  Created by Greg Borenstein on 6/18/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

class GEGistListDelegate < NSResponder
  attr_accessor :associatedDocument
  
  def awakeFromNib()
  end
  
  def numberOfRowsInTableView(aTableView)
    @library = GEGistLibrary.new
    @library.gists.length
  end
  
  def rightMouseDown(theEvent)
    NSLog("right mouse")
  end

  def tableViewSelectionDidChange(notification)
    gist = GEGist.new(associatedDocument.library.gistsSortedByName[notification.object.selectedRow])
    associatedDocument.setGist(gist)
  end

  def tableView(tableView, objectValueForTableColumn:column, row:row)   
    if row < associatedDocument.library.gistsSortedByName.length
      return associatedDocument.library.gistsSortedByName[row].valueForKey("title") || "gist##{associatedDocument.library.gistsSortedByName[row].valueForKey('gist_id')}"
    end
    nil
  end
end
