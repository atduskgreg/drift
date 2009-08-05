#
#  GEGist.rb
#  gisteditor
#
#  Created by Greg Borenstein on 6/6/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

class GEGist
  attr_accessor :gist_id, :created_at, :title, :body

  def self.new_from_xml(xml)
    self.new :gist_id => self.extract_from_xml(xml, 'repo'),
             :created_at => self.extract_from_xml(xml, 'created-at')
  end
  
  def self.extract_from_xml(xml, value)
    NSLog(value)
    xml.rootElement.nodesForXPath("gist/#{value}", error:nil).first.stringValue
  end
  
  def initialize(opts={})
    @gist_id = opts[:gist_id]
    @created_at = opts[:created_at]
    @body = opts[:body]
    @title = opts[:title]
  end
  
  def to_h
    {:gist_id => @gist_id,
     :created_at => @created_at,
     :title => @title,
     :body => @body }
  end
  
  def update(owner)
    owner.library.gists.reject!{|g| g[:gist_id] == self.gist_id}
    self.save(owner)
  end
  
  def save(owner)
    owner.library.gists << self.to_h
    owner.library.flush
  end
end
