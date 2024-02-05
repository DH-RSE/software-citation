<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei" version="2.0">
    <xsl:output method="xml" encoding="utf-8" indent="yes"/>
    <xsl:variable name="softwarelist" select="document('../taxonomy/software-list.xml')"/>
    <xsl:variable name="softwaretaxonomy" select="document('../taxonomy/citation-taxonomy.xml')"/>


    <!-- Identity template : copy all text nodes, elements and attributes -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- When matching dataSpec ident="software.mention.target": get items from list-->
    <xsl:template
        match="//tei:TEI/tei:text/tei:back/tei:div/tei:schemaSpec/tei:dataSpec[@ident='software.mention.target']/tei:content[1]/tei:alternate[1]/tei:valList[1]">
        <valList type="closed">
        <xsl:for-each select="distinct-values($softwarelist//tei:list/tei:item/@xml:id)">
            <valItem mode="add" ident="{.}"/>
        </xsl:for-each>
        </valList>
    </xsl:template>
  
    <!-- When matching elementSpec ident="rs": get items from list-->
    <!-- /tei:TEI/tei:text[1]/tei:back[1]/tei:div[2]/tei:schemaSpec[1]/tei:elementSpec[48] -->
    <!-- /TEI/teiHeader[1]/encodingDesc[1]/classDecl[1]/taxonomy[1]/category[1] -->
    <xsl:template
      match="//tei:TEI/tei:text/tei:back/tei:div/tei:schemaSpec/tei:elementSpec[@ident='rs']/tei:attList/tei:attdef[@ident='type']/tei:valList[1]">
      <valList type="closed">
        <xsl:for-each select="distinct-values($softwaretaxonomy/tei:TEI/tei:teiHeader/tei:encodingDesc/tei:classDecl/tei:taxonomy/tei:category/@xml:id)">
          <valItem mode="add" ident="{lower-case(.)}"/>
        </xsl:for-each>
      </valList>
    </xsl:template>

</xsl:stylesheet>
