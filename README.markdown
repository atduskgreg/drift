Drift
=======

Drift is a [Gist](http://gist.github.com)-backed text editor written in [MacRuby](http://www.macruby.org/). Depending on how you look at it, it either lets you edit your gists, or gives you an always-already versioned, cloud-backed text-editor. Here's a screenshot:

![Drift circa 4/11/10](http://img.skitch.com/20100411-1yxsmj41xfi6aki7q7xhp53bq3.jpg)

Features
---------

* Create and upload new gists
* Edit and update existing gists (created with Drift)
* Store github credentials
* Display activity when going over the wire to GitHub
* Copy gist url into clipboard on creation

Drift Needs a Logo!
-------------------

Do you have slick Mac app logo-creating ability? Now accepting submissions: greg DOT borenstein AT gmail DOT com

Drift Needs better icons!
-------------------

Man, these icons are fugly. Help! greg DOT borenstein AT gmail DOT com

TODO:
--------

* import all gists belonging to the user (if we have gh info)
* get name of newly imported gists
* save imported gists to library
* get gist list to scroll

* deal with save prompt on quit for unsaved docs
* rename GEDocument's associated_library to something that indicates it's a tableView and not a library; like maybe "associatedTableView"
* unifying networking code to remove duplication from GEDocument#putGist and GEDocument#postGist
* error handling on talking to GH
* make creating a new document not open a new window
* figure out why GEGistListDelegate doesn't have access to associatedDocument in numberOfRowsInTableView
* button to remove gist from tracked gists
* button to delete gists
* all these buttons should also be menu items/hot keys
* clean up some of the logging
* automatic updating of gist on a timed basis