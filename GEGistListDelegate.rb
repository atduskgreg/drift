#
#  GEGistListDelegate.rb
#  gisteditor
#
#  Created by Greg Borenstein on 6/18/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

class GEGistListDelegate
  attr_accessor :associatedDocument
  
  def awakeFromNib()
  end
  
  def numberOfRowsInTableView(aTableView)
    @library = GEGistLibrary.new
    @library.gists.length
  end
  
  def tableViewSelectionDidChange(notification)
    gist = GEGist.new(gistsSortedByName[notification.object.selectedRow])
    associatedDocument.setGist(gist)
  end

  def gistsSortedByName
    associatedDocument.library.gists.sort_by{|g| g["title"] || g["gist_id"]}
  end

  def tableView(tableView, objectValueForTableColumn:column, row:row)   
    if row < gistsSortedByName.length
      return gistsSortedByName[row].valueForKey("title") || "gist##{gistsSortedByName[row].valueForKey('gist_id')}"
    end
    nil
  end
end
