<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <xsl:template match="/">
        <xsl:for-each select="collection('/home/ulrike/Git/software-citation/data/JTEI?select=*.xml;recurse=yes')//TEI">
            <xsl:value-of select="base-uri(.)"/>: <xsl:value-of select="count(.//rs[starts-with(@type,'soft')])"/><xsl:text>
                
            </xsl:text>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>