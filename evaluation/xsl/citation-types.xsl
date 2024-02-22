<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- creates a CSV file that lists all unique software/abstract combinations with the corresponding citation annotations -->
    
    
    <!-- Serialization details -->
    <xsl:output method="text" omit-xml-declaration="yes"/>
    
    
    <!-- Include other XSLTs -->
    <xsl:include href="global-parameters.xsl"/>
    
    
    <!-- Keys -->    
    <xsl:key name="rs-by-ref" match="*:rs" use="@ref"/>
    <xsl:key name="software-target-by-id" match="*:ptr/@target" use="../@xml:id"/>
    <xsl:key name="software-name-by-id" match="*:name" use="../@xml:id"/>
    
    <!-- Global variables -->
    
    <!-- software list -->
    <xsl:variable name="software-list" select="doc('../../taxonomy/software-list.xml')"/>
    
    
    <!-- categories for CSV header (later extended by boolean columns) -->
    <xsl:variable name="categories" select="('SoftwareID','Dateipfad',$SOFTWARE-MENTION-TYPES)" as="xs:string+"/>
    
    
    <!-- Templates -->
    
    <xsl:template match="/">
        
        <!-- header row -->
        <xsl:value-of select="concat($categories[1], $CSV-SEP, $categories[2])"/>
        <xsl:for-each select="subsequence($categories, 3)">
            <xsl:value-of select="concat($CSV-SEP, ., $CSV-SEP, ., ' (bool)')"/>
        </xsl:for-each>
        <xsl:value-of select="$NEWLINE"/>
        
        <!-- following rows -->
        <xsl:for-each select="$COLLECTION-DIRS">
            <xsl:variable name="current-directory" select="substring(., 4)" as="xs:string"/>
            
            <xsl:for-each select="collection(concat(., '?select=*.xml;recurse=yes;on-error=warning'))">
                <xsl:variable name="doc" select="/"/>
                
                <xsl:for-each select="distinct-values($doc//*:rs[some $cit in $categories[position() &gt; 2] satisfies contains(@type, $cit)]/tokenize(@ref, ' '))">
                    <xsl:sort select="." order="ascending"/>
                    <xsl:variable name="current-ref" select="." as="xs:string"/>
                    <xsl:variable name="software-id" select="lower-case(substring-after(key('software-target-by-id', substring-after($current-ref, '#'), $doc)[1], '#'))"/>
                    <xsl:variable name="software-name" select="(
                        key('software-name-by-id', $software-id, $software-list), 
                        error((), concat('No software name found for ID ''', $software-id, ''' / ref ''', $current-ref ,''' (', base-uri($doc), ')')))[1]" as="xs:string"/>
                    <xsl:variable name="rs-with-this-ref" select="key('rs-by-ref', ., $doc)"/>
                                        
                    
                    <!-- SoftwareID and file path -->
                    <xsl:value-of select="concat($software-name, $CSV-SEP, $current-directory, substring-after(base-uri($doc), $current-directory))"/>
                    
                    
                    <!-- other annotations -->
                    <xsl:for-each select="subsequence($categories, 3)">
                        <xsl:variable name="count" select="count($rs-with-this-ref[contains(lower-case(@type), lower-case(current()))])" as="xs:integer"/>
                        <xsl:value-of select="concat($CSV-SEP, $count)"/>
                        <xsl:value-of select="concat($CSV-SEP, ('1'[$count &gt; 0],'0')[1])"/>
                    </xsl:for-each>
                    
                    <xsl:value-of select="$NEWLINE"/>
                </xsl:for-each>
                
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>