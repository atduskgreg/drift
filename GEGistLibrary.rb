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
    @library ||= NSDictionary.alloc.initWithContentsOfFile(LIBRARY_PATH.stringByExpandingTildeInPath) || {"gists" => [defaultGist]}
  end
  
  def defaultGist
    {"gist_id"=>"132472", "created_at"=>"2009-06-19 00:14:15 -0700", "body"=>"Welcome to Drift!", "title" => "drift_welcome.txt"}
  end
  
  def gistsSortedByName
    self.gists.sort_by{|g| g["title"] || g["gist_id"]}
  end
  
  def flush
    @library.writeToFile(LIBRARY_PATH.stringByExpandingTildeInPath, atomically:true)
  end
  
  def gists
    @library["gists"]
  end
end
