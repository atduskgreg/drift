Drift
=======

Drift is a [Gist](http://gist.github.com)-backed text editor written in [MacRuby](http://www.macruby.org/). Depending on how you look at it, it either lets you edit your gists, or gives you an always-already versioned, cloud-backed text-editor. Here's a screenshot:

![Drift circa 8/14/9](http://img.skitch.com/20090814-pukd9qr6r43sbg75x1hrhr9wp1.jpg)

Features
---------

* Create an upload new gists
* Edit and update existing gists (created with Drift)
* Store github credentials
* Display activity when going over the wire to GitHub
* Copy gist url into clipboard on creation


TODO:
--------

* break out functionality for copying gist url
* error handling on talking to GH
* make creating a new document not open a new window
* highlight new gist in table view when created
* figure out why GEGistListDelegate doesn't have access to associatedDocument in numberOfRowsInTableView
* control-click menu to put gist url in clipboard
* control-click menu to remove gist from tracked gists
* control-click menu to refresh gist from server
* control-click menu to delete gists
* clean up some of the logging
* import all gists belonging to the user (if we have gh info)