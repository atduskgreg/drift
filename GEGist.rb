#
#  GEGist.rb
#  gisteditor
#
#  Created by Greg Borenstein on 6/6/09.
#  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
#

class GEGist
  attr_accessor :gist_id, :created_at, :title, :body

  def self.build_multiple(xml)
    xml.rootElement.nodesForXPath("//gists/gist", error:nil).collect do |gist_xml|
      GEGist.new :gist_id => gist_xml.elementsForName("repo").first.stringValue,
                 :created_at => gist_xml.elementsForName("created-at").first.stringValue
    end
  end
  
  def populate_body
    new_contents = NSString.stringWithContentsOfURL(NSURL.URLWithString("http://gist.github.com/#{self.gist_id}.txt"))
    self.body = new_contents
  end


  def self.new_from_xml(xml)
    self.new :gist_id => self.extract_from_xml(xml, 'repo'),
             :created_at => self.extract_from_xml(xml, 'created-at')
  end
  
  def self.extract_from_xml(xml, value)
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
  
  def add(owner)
    if !owner.library.gists.collect{|g|g[:gist_id]}.include?(self.gist_id)
      self.save(owner)
    end
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
