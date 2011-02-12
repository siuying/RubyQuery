# Ruby-Query

 jQuery for command line and ruby. It make extract simple data fun and easy. 

 It use Nokogiri for CSS extraction. Inspired by node [Query](https://github.com/visionmedia/query)

## Installation

    $ gem install ruby-query


## Ruby Examples

  Extract an attribute from a webpage:

	  require 'open-uri'
	  require 'ruby_query'

	  RubyQuery::Query.query(open("http://twitter.com"), "a#logo img", "attr", "alt")
	  => "Twitter"

  Extract a form input value :

	  require 'ruby_query'

	  RubyQuery::Query.query('<input type="text" value="tj@vision-media.ca"/>', "input", "val")
	  => "tj@vision-media.ca"
		
## Command Line Examples

  Twitter logo alt text:
  
    $ curl http://twitter.com | rquery 'a#logo img' attr alt
    Twitter

  Alternately, since the output is simply more html, we can achieve this same result via pipes:
  
    $ curl http://twitter.com | rquery 'a#logo' | rquery img attr alt
    Twitter

  Check if a class is present:
  
    $ curl http://twitter.com | rquery '.article #timeline' hasClass statuses
    true

  Grab width or height attributes:
  
    $ echo '<div class="user" width="300"></div>' | rquery div.user width
    300

  Output element text:
  
    $ echo '<p>very <em>slick</em></p>' | rquery p text
    very slick

  Values:
  
    $ echo '<input type="text" value="tj@vision-media.ca"/>' | rquery input val
    tj@vision-media.ca
  
  Get second li's text:
  
    $ echo '<ul><li>Apple</li><li>Orange</li><li>Cat</li></ul>' | rquery ul li get 1 text
    Orange
  
  Get third li's text using `next`:
  
    $ echo '<ul><li>Apple</li><li>Orange</li><li>Cat</li></ul>' | rquery ul li get 1 next text
    Cat

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

