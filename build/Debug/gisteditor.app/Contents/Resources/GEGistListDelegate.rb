#
#  GEGistListDelegate.rb
#  gisteditor
#
#  Created by Greg Borenstein on 6/18/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

class GEGistListDelegate
  attr_accessor :associatedDocument
  
  def numberOfRowsInTableView(aTableView)
    associatedDocument.library.gists.length
  end

  def tableView(tableView, objectValueForTableColumn:column, row:row)
    gistsSortedByName = associatedDocument.library.gists.sort_by{|g| g["title"] || g["gist_id"]}
    if row < gistsSortedByName.length
      return gistsSortedByName[row].valueForKey("title") || "gist##{gistsSortedByName[row].valueForKey('gist_id')}"
    end
    nil
  end
end
