<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs" xmlns:dhq="http://www.digitalhumanities.org/ns/dhq"
    version="2.0">
    
    <!-- extract metadata from DHQ XML files -->
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <xsl:text>DHQ-id,year,vol,issue,type,lang</xsl:text><xsl:text>
</xsl:text>
        <xsl:for-each select="collection('/home/ulrike/Git/software-citation/data/DHQ/source')//TEI">
            <xsl:value-of select="//idno[@type='DHQarticle-id']"/><xsl:text>,</xsl:text>
            <xsl:value-of select="substring(//publicationStmt/date/@when,1,4)"/><xsl:text>,</xsl:text>
            <xsl:value-of select="//idno[@type='volume']"/><xsl:text>,</xsl:text>
            <xsl:value-of select="//idno[@type='issue']"/><xsl:text>,</xsl:text>
            <xsl:value-of select="//dhq:articleType"/><xsl:text>,</xsl:text>
            <xsl:value-of select="//language/@ident"/>
            <xsl:if test="position()!=last()">
                <xsl:text>
</xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>