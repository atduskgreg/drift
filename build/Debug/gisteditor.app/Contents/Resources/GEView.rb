#
#  GEView.rb
#  gisteditor
#
#  Created by Greg Borenstein on 6/2/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

class GEView < NSView

  def initWithFrame(frame)
    super(frame)
    # Initialization code here.
    return self
  end

  def drawRect(rect)
    # Drawing code here.
  end
  
  def isFlipped
    return true
  end
  
  def isOpaque
    return true
  end

end
