<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei" version="2.0">
  <xsl:output method="xml" encoding="utf-8" indent="yes"/>

  <!-- Identity template : copy all text nodes, elements and attributes -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="//tei:item/@xml:id">
    <xsl:attribute name="xml:id">
      <xsl:value-of select="lower-case(replace(., '[-_\.\s]', ''))"/>
    </xsl:attribute>
  </xsl:template>



</xsl:stylesheet>
