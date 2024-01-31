<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei" version="2.0">
    <xsl:output method="xml" encoding="utf-8" indent="yes"/>
    <xsl:variable name="softwarelist" select="document('../taxonomy/software-list.xml')"/>


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

</xsl:stylesheet>
