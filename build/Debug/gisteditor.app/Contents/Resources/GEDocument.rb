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

  def initialize()
    view_contents ||= NSAttributedString.alloc.initWithString("")

    center = NSNotificationCenter.defaultCenter  
    center.addObserver(self, selector:textDidChange,
                name:NSTextDidChangeNotification,
              object:textView)
  end
  
  def textDidChange(notification)
    NSLog("yo")
    NSLog(self.text_view.textStorage)
    self.view_contents = self.text_view.textStorage
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
