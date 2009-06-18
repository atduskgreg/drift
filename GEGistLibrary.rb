#
#  GEGistLibrary.rb
#  gisteditor
#
#  Created by Greg Borenstein on 6/18/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

class GEGistLibrary
  LIBRARY_PATH = "~/Library/Application\ Support/Drift/library.xml"

  def initialize()
    @library ||= NSDictionary.alloc.initWithContentsOfFile(LIBRARY_PATH.stringByExpandingTildeInPath) || {"gists" => []}
  end
  
  def flush
    @library.writeToFile(LIBRARY_PATH.stringByExpandingTildeInPath, atomically:true)
  end
  
  def gists
    @library["gists"]
  end
end
