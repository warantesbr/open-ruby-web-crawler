ruby-schema.org-open-graph-web-crawler
===============

My attempt to write an all purpose web crawler in ruby using schema.org and open graph principles.
Uses both Anemone and Nokogiri

You can pass three arguments to this URL.

URL: the URL you want to parse
Selector: the CSS3 selector you want to use (optional)
Callback: the JavaScript callback you want it wrapped in (optional)

Usage: /?url=http://www.cnn.com&selector=a&callback=myCallback

