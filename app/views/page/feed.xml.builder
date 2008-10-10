xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title("Git Releases")
    xml.link("http://git-scm.com/")
    xml.description("Git Release Announcements")
    xml.language('en-us')
      @releases.each do |release|
        xml.item do
          xml.title(release[1])
          xml.description(release[2])
          xml.pubDate(release[0].strftime("%a, %d %b %Y %H:%M:%S %z"))
          xml.link('http://git-scm.com/download')
          xml.guid(release[1])
        end
      end
  }
}