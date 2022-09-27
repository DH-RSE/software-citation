curl -s -L -o /tmp/saxon.zip https://sourceforge.net/projects/saxon/files/Saxon-HE/11/Java/SaxonHE11-4J.zip/download
unzip /tmp/saxon.zip -d /tmp/saxon
rm /tmp/saxon.zip
echo $(ls /tmp)
echo $(ls)
echo $(java -version) 
java -jar '/tmp/saxon/saxon-he-11.4.jar' -xsl:'utilities/addSoftwareList2Odd.xsl' -s:'schema/tei_software_annotation.xml' -o:'schema/tei_software_annotation.xml'
