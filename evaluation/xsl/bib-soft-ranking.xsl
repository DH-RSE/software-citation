<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- evaluates software which is cited in the bibliography (Bib.Ref, Bib.Soft) -->
    
    <!-- Serialization details -->
    <xsl:output method="text" omit-xml-declaration="yes"/>
    
    
    <xsl:variable name="csv-separator" select="','" as="xs:string"/>
    
    <xsl:variable name="NEWLINE"><xsl:text>
</xsl:text></xsl:variable>
    
    
    <xsl:template match="/">
        
        <xsl:variable name="citation-types" select="unparsed-text('../csv/citation-types.csv','UTF-8')"/>
        
        <xsl:value-of select="string-join(('Software-ID','Citations','Bib.Ref.abs','Bib.Ref.rel','Bib.Soft.abs','Bib.Soft.rel'), $csv-separator)"/>
        <xsl:text></xsl:text>
        <xsl:value-of select="$NEWLINE"/>
        
        <xsl:variable name="Bib-counts">
            <counts>
                <xsl:analyze-string select="$citation-types" regex="{concat('^([^', $csv-separator,']+)', $csv-separator,'[^', $csv-separator,']+', $csv-separator,'[^', $csv-separator,']+', $csv-separator,'[^', $csv-separator,']+', $csv-separator,'[^', $csv-separator,']+', $csv-separator,'[^', $csv-separator,']+', $csv-separator,'[^', $csv-separator,']+', $csv-separator,'([^', $csv-separator,']+)', $csv-separator,'[^', $csv-separator,']+', $csv-separator,'([^', $csv-separator,']+).*$')}" flags="m">
                    <xsl:matching-substring>
                        <xsl:if test="position() > 1">
                            <entry>
                                <name><xsl:value-of select="normalize-space(regex-group(1))"/></name>
                                <value type="Bib.Ref"><xsl:value-of select="regex-group(2)"/></value>
                                <value type="Bib.Soft"><xsl:value-of select="regex-group(3)"/></value>
                            </entry>
                        </xsl:if>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </counts>
        </xsl:variable>
        
        <xsl:for-each-group select="$Bib-counts//entry" group-by="name">
            <xsl:sort select="count(current-group()[value[@type='Bib.Soft']='1']) div count(current-group())" order="descending"/>
            <xsl:variable name="Bib.Ref-sum" select="count(current-group()[value[@type='Bib.Ref']='1'])"/>
            <xsl:variable name="Bib.Soft-sum" select="count(current-group()[value[@type='Bib.Soft']='1'])"/>
            <xsl:variable name="Cit.counts" select="count(current-group())"/>
            <xsl:value-of select="current-grouping-key()"/>
            <xsl:value-of select="$csv-separator"/>
            <xsl:value-of select="$Cit.counts"/>
            <xsl:value-of select="$csv-separator"/>
            <xsl:value-of select="$Bib.Ref-sum"/>
            <xsl:value-of select="$csv-separator"/>
            <xsl:value-of select="$Bib.Ref-sum div $Cit.counts"/>
            <xsl:value-of select="$csv-separator"/>
            <xsl:value-of select="$Bib.Soft-sum"/>
            <xsl:value-of select="$csv-separator"/>
            <xsl:value-of select="$Bib.Soft-sum div $Cit.counts"/>
            <xsl:if test="position() != last()">
                <xsl:value-of select="$NEWLINE"/>
            </xsl:if>
        </xsl:for-each-group>
    </xsl:template>
    
    
</xsl:stylesheet>