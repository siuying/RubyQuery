require 'spec_helper'

describe RubyQuery do
  HTML_SIMPLE = "<html><body><a href='test' id='logo'><img src='1.gif' alt='Test'/></a><ul class='list'><li>point a</li><li>point b</li></ul></body></html>"
  HTML_LIST = "<ul><li>Apple</li><li>Orange</li><li>Cat</li></ul>"

  it "extract using class" do
    RubyQuery::Query.query(HTML_SIMPLE, ".list li", "first", "text").should == "point a"
  end

  it "extract using id" do
    RubyQuery::Query.query(HTML_SIMPLE, "a#logo img", "attr", "alt").should == "Test"
  end  
  
  it "should return empty if a match is not found" do
    RubyQuery::Query.query(HTML_SIMPLE, "a#logo #qk").should be_empty
    RubyQuery::Query.query(HTML_SIMPLE, "a#logo #qk", "attr", "alt").should be_empty
  end
  
  it "nested extraction" do
    logo = RubyQuery::Query.query(HTML_SIMPLE, "a#logo")
    RubyQuery::Query.query(logo, "img", "attr", "alt").should == "Test"
  end  

  it "check if a class is present" do
    RubyQuery::Query.query(HTML_SIMPLE, "ul", "has-class", "list").should be_true
  end
  
  it "grab width or height attributes" do
    RubyQuery::Query.query('<div class="user" width="300"></div>', "div.user", "width").should == "300"
    RubyQuery::Query.query('<div class="user" width="300" height="150"></div>', "div.user", "height").should == "150"
  end

  it "output element text and inner html" do
    RubyQuery::Query.query('<p>very <em>slick</em></p>', "p", "text").should == "very slick"
    RubyQuery::Query.query('<p>very <em>slick</em></p>', "p", "inner_html").should == "very <em>slick</em>"
  end
  
  it "get value" do
    RubyQuery::Query.query('<input type="text" value="tj@vision-media.ca"/>', "input", "val").should == "tj@vision-media.ca"
    RubyQuery::Query.query('<input type="text" value="tj@vision-media.ca"/>', "input", "value").should == "tj@vision-media.ca"
  end

  it "get second li's text" do
    RubyQuery::Query.query(HTML_LIST, "ul li", "get", "1", "text").should == "Orange"
    RubyQuery::Query.query(HTML_LIST, "ul", "li", "get", "1", "text").should == "Orange"
    RubyQuery::Query.query(HTML_LIST, "ul li", "get", "10", "text").should be_nil
  end

  it "get third li's text using next" do
    RubyQuery::Query.query(HTML_LIST, "ul li", "get", "1", "next", "text").should == "Cat"
    RubyQuery::Query.query(HTML_LIST, "ul", "li", "get", "1", "next", "text").should == "Cat"
  end

  it "get length" do
    RubyQuery::Query.query(HTML_LIST, "li", "len").should == 3
    RubyQuery::Query.query(HTML_LIST, "li", "length").should == 3
  end
  
  it "should handl html or text" do
    RubyQuery::Query.query(HTML_LIST, "li", "first", "text").should == "Apple"
    RubyQuery::Query.query(HTML_LIST, "li", "first", "html").should == "<li>Apple</li>\n"
    RubyQuery::Query.query(HTML_LIST, "li", "html").should == "<li>Apple</li>\n<li>Orange</li>\n<li>Cat</li>"
  end

  it "should return empty for strange query" do
    RubyQuery::Query.query(HTML_LIST, "liaa").should be_empty
    RubyQuery::Query.query(HTML_LIST, "lixaa", "len").should == 0
  end
end
