# RQuery

 jQuery for command line and ruby. It make extract simple data fun and easy. 

 It use Nokogiri for CSS extraction. Inspired by node [Query](https://github.com/visionmedia/query)

## Installation

    $ gem install rquery


## Ruby Examples

  Extract an attribute from a webpage:

	  require 'open-uri'
	  require 'rquery'

	  RQuery::Query.query(open("http://twitter.com"), "a#logo img", "attr", "alt")
	  => "Twitter"

  Extract a form input value :

	  require 'rquery'

	  RQuery::Query.query('<input type="text" value="tj@vision-media.ca"/>', "input", "val")
	  => "tj@vision-media.ca"
		
## Command Line Examples

  Twitter logo alt text:
  
    $ curl http://twitter.com | query 'a#logo img' attr alt
    Twitter

  Alternately, since the output is simply more html, we can achieve this same result via pipes:
  
    $ curl http://twitter.com | query 'a#logo' | query img attr alt
    Twitter

  Check if a class is present:
  
    $ curl http://twitter.com | query .article '#timeline' hasClass statuses
    true
    
    $ echo $?
    0

  Exit status for bools:
  
    $ echo '<div class="foo bar"></div>' | ./index.js div hasClass baz
    false
    
    $ echo $?
    1

  Grab width or height attributes:
  
    $ echo '<div class="user" width="300"></div>' | query div.user width
    300

  Output element text:
  
    $ echo '<p>very <em>slick</em></p>' | query p text
    very slick

  Values:
  
    $ echo '<input type="text" value="tj@vision-media.ca"/>' | query input val
    tj@vision-media.ca
  
  Get second li's text:
  
    $ echo $list | query ul li get 1 text
    two
  
  Get third li's text using `next`:
  
    $ echo $list | query ul li get 1 next text
    three

  Get length:
  
    $ echo '<ul><li></li><li></li></ul>' | query li length
    2


## Contributing to RQuery
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Francis Chong. See LICENSE.txt for
further details.

