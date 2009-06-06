#
#  ConnectionDelegate.rb
#  gisteditor
#
#  Created by Greg Borenstein on 6/3/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#
# Originally from the peepcode via Unfollowbot

require "base64"
require "cgi"

class ConnectionDelegate

  def initialize(parent, &block)
    @parent = parent
    @block = block
  end

  def connectionDidFinishLoading(connection)
      NSLog(@receivedData.inspect)

    doc = NSXMLDocument.alloc.initWithData(@receivedData,
                                           options:NSXMLDocumentValidate,
                                           error:nil)

    if doc
      @block.call(doc)
    else
      @block.call("Invalid response")
    end
  end

  def connection(connection, didReceiveResponse:response)
    case response.statusCode
    when 401
      @block.call("Invalid username and password")
    when (400..500)
      @block.call("Unable to complete your request")
    end
  end

  def connection(connection, didReceiveData:data)
    @receivedData ||= NSMutableData.new
    @receivedData.appendData(data)
  end

  def connection(conn, didFailWithError:error)
    @parent.status_label.stringValue = "Error communicating with GitHub"
  end
end
