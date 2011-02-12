require 'spec_helper'

describe RQuery do
  HTML_SIMPLE = "<html><body><a href='test' id='logo'><img src='1.gif' alt='Test'/></a><ul class='list'><li>point a</li><li>point b</li></ul></body></html>"
  HTML_LIST = "<ul><li>Apple</li><li>Orange</li><li>Cat</li></ul>"

  it "extract using class" do
    RQuery::Query.query(HTML_SIMPLE, ".list li", "first", "text").should == "point a"
  end

  it "extract using id" do
    RQuery::Query.query(HTML_SIMPLE, "a#logo img", "attr", "alt").should == "Test"
  end  
  
  it "should return empty if a match is not found" do
    RQuery::Query.query(HTML_SIMPLE, "a#logo #qk").should be_empty
    RQuery::Query.query(HTML_SIMPLE, "a#logo #qk", "attr", "alt").should be_empty
  end
  
  it "nested extraction" do
    logo = RQuery::Query.query(HTML_SIMPLE, "a#logo")
    RQuery::Query.query(logo, "img", "attr", "alt").should == "Test"
  end  

  it "check if a class is present" do
    logo = RQuery::Query.query(HTML_SIMPLE, "a")
    RQuery::Query.query(logo.to_s, "img", "attr", "alt").should be_true
  end
  
  it "grab width or height attributes" do
    RQuery::Query.query('<div class="user" width="300"></div>', "div.user", "width").should == "300"
    RQuery::Query.query('<div class="user" width="300" height="150"></div>', "div.user", "height").should == "150"
  end

  it "output element text and inner html" do
    RQuery::Query.query('<p>very <em>slick</em></p>', "p", "text").should == "very slick"
    RQuery::Query.query('<p>very <em>slick</em></p>', "p", "inner_html").should == "very <em>slick</em>"
  end
  
  it "get value" do
    RQuery::Query.query('<input type="text" value="tj@vision-media.ca"/>', "input", "val").should == "tj@vision-media.ca"
    RQuery::Query.query('<input type="text" value="tj@vision-media.ca"/>', "input", "value").should == "tj@vision-media.ca"
  end

  it "get second li's text" do
    RQuery::Query.query(HTML_LIST, "ul li", "get", "1", "text").should == "Orange"
    RQuery::Query.query(HTML_LIST, "ul li", "get", "10", "text").should be_nil
  end

  it "get third li's text using next" do
    RQuery::Query.query(HTML_LIST, "ul li", "get", "1", "next", "text").should == "Cat"
  end

  it "get length" do
    RQuery::Query.query(HTML_LIST, "li", "len").should == 3
    RQuery::Query.query(HTML_LIST, "li", "length").should == 3
  end
  
  it "should handl html or text" do
    RQuery::Query.query(HTML_LIST, "li", "first", "text").should == "Apple"
    RQuery::Query.query(HTML_LIST, "li", "first", "html").should == "<li>Apple</li>\n"
    RQuery::Query.query(HTML_LIST, "li", "html").should == "<li>Apple</li>\n<li>Orange</li>\n<li>Cat</li>"
  end

end
