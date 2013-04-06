#!/usr/bin/env ruby

require 'anemone'

libsvm_url = "http://www.csie.ntu.edu.tw/~cjlin/libsvm/oldfiles/"

data_dir = File.expand_path('../libsvm_grabber_data', File.dirname(__FILE__))

`rm -r #{data_dir}`
`mkdir #{data_dir}`

# grab links from libsvm page
@links = []
Anemone.crawl(libsvm_url) do |anemone|
  anemone.on_every_page do |page|
    puts page.url
    @links = page.links.map(&:to_s).select{|i| i =~ /\.zip$/}
  end

  anemone.focus_crawl {|page| []}
end

# download files
@links.each do |i|
  puts "fetching #{i}"
  `cd #{data_dir} && wget #{i}`
end

# extract zips
`cd #{data_dir} && for f in *.zip; do unzip "$f" -d "${f%.zip}"; done`
