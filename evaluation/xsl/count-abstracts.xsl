<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <!--
    How to call the script:
    java -jar /home/ulrike/Programme/saxon/saxon9he.jar /home/ulrike/Git/software-citation/taxonomy/software-list.xml /home/ulrike/Git/software-citation/evaluation/xsl/count-abstracts.xsl
    -->
    
    
    <xsl:output method="text"/>
    <xsl:variable name="coll_path">/home/ulrike/Git/software-citation/data/</xsl:variable>
    <xsl:variable name="eng" select="collection(concat($coll_path,'eng','?recurse=yes;select=*.xml'))//TEI[not(.//application[contains(.,'GROBID')])][.//notesStmt[normalize-space(.)='no software']]"/>
    <xsl:variable name="deu" select="collection(concat($coll_path,'deu','?recurse=yes;select=*.xml'))//TEI[not(.//application[contains(.,'GROBID')])][.//notesStmt[normalize-space(.)='no software']]"/>
    <xsl:variable name="spa" select="collection(concat($coll_path,'spa','?recurse=yes;select=*.xml'))//TEI[not(.//application[contains(.,'GROBID')])][.//notesStmt[normalize-space(.)='no software']]"/>
    <xsl:variable name="ita" select="collection(concat($coll_path,'ita','?recurse=yes;select=*.xml'))//TEI[not(.//application[contains(.,'GROBID')])][.//notesStmt[normalize-space(.)='no software']]"/>
    <xsl:variable name="fra" select="collection(concat($coll_path,'fra','?recurse=yes;select=*.xml'))//TEI[not(.//application[contains(.,'GROBID')])][.//notesStmt[normalize-space(.)='no software']]"/>
    <xsl:variable name="por" select="collection(concat($coll_path,'por','?recurse=yes;select=*.xml'))//TEI[not(.//application[contains(.,'GROBID')])][.//notesStmt[normalize-space(.)='no software']]"/>
    
    <xsl:template match="/">
        <xsl:value-of select="count(($eng, $deu, $spa, $fra, $ita, $por))"/>
       
    </xsl:template>
    
</xsl:stylesheet>