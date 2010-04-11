#
#  GEGistListTableView.rb
#  gisteditor
#
#  Created by Greg Borenstein on 4/11/10.
#  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
#

class GEGistListTableView < NSTableView
  attr_accessor :the_menu
  
  def menuForEvent(theEvent)
    NSLog("here?")
    @the_menu ||= NSMenu.alloc.initWithTitle("Gist Action Menu")
  end
  
  def rightMouseDown(theEvent)
    NSLog("right mouse")
  end
end
