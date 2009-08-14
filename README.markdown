Drift
=======

Drift is a [MacRuby](http://www.macruby.org/) [Gist](http://gist.github.com)-backed text editor. Depending on how you look at it, it either lets you edit your gists, or gives you an always-already versioned, cloud-backed text-editor. Here's a screenshot:

![Drift circa 8/14/9](http://img.skitch.com/20090814-pukd9qr6r43sbg75x1hrhr9wp1.jpg)


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
* fetch all the gists belonging to the user (if we have gh info)