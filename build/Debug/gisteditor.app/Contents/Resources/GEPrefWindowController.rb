#
#  GEPrefWindowController.rb
#  gisteditor
#
#  Created by Greg Borenstein on 6/22/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

class GEPrefWindowController
  attr_accessor :preferencesWindow
  attr_accessor :gh_LoginField
  attr_accessor :gh_TokenField
  
  def awakeFromNib()
    gh_LoginField.stringValue = preferences.user.login
    gh_TokenField.stringValue = preferences.user.token
  end
  
  def setPreferences(sender)
    preferences.user.login = gh_LoginField.stringValue
    preferences.user.token = gh_TokenField.stringValue
    sender.window.close()
  end
    
end
