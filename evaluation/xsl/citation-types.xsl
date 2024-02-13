<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- creates a CSV file that lists all unique software/abstract combinations with the corresponding citation annotations -->
    
    
    <!-- Serialization details -->
    <xsl:output method="text" omit-xml-declaration="yes"/>
    
    
    <!-- Keys -->    
    <xsl:key name="rs-by-ref" match="*:rs" use="@ref"/>
    <xsl:key name="software-target-by-id" match="*:ptr/@target" use="../@xml:id"/>
    <xsl:key name="software-name-by-id" match="*:name" use="../@xml:id"/>
    
    <!-- Global variables -->
    
    <!-- software list -->
    <xsl:variable name="software-list" select="doc('../../taxonomy/software-list.xml')"/>
    
    <!-- directories with TEI files -->
    <xsl:variable name="collection-dirs" as="xs:string+" select="(
        '../../data/JTEI/10_2016-19',
        '../../data/JTEI/13_2020-22',
        '../../data/JTEI/7_2014',
        '../../data/JTEI/rolling_2019',
        '../../data/JTEI/rolling_2023',
        '../../data/JTEI/11_2019-20',
        '../../data/JTEI/12_2019-20',
        '../../data/JTEI/14_2021-23',
        '../../data/JTEI/8_2014-15',
        '../../data/JTEI/rolling_2021',
        '../../data/JTEI/16_2023_spa',
        '../../data/JTEI/9_2016-17',
        '../../data/JTEI/rolling_2022'
        )"/>
    
    <!-- categories for CSV header (later extended by boolean columns) -->
    <xsl:variable name="categories" select="('SoftwareID','Dateipfad','soft.name','soft.bib.ref','soft.bib','soft.agent','soft.url','soft.pid','soft.ver')" as="xs:string+"/>
    
    <!-- character to be used as CSV separator -->
    <xsl:variable name="csv-separator" select="','" as="xs:string"/>
    
    <!-- newline character -->
    <xsl:variable name="NEWLINE"><xsl:text>
</xsl:text></xsl:variable>
    
    
    <!-- Templates -->
    
    <xsl:template match="/">
        
        <!-- header row -->
        <xsl:value-of select="concat($categories[1], $csv-separator, $categories[2])"/>
        <xsl:for-each select="subsequence($categories, 3)">
            <xsl:value-of select="concat($csv-separator, ., $csv-separator, ., ' (bool)')"/>
        </xsl:for-each>
        <xsl:value-of select="$NEWLINE"/>
        
        <!-- following rows -->
        <xsl:for-each select="$collection-dirs">
            <xsl:variable name="current-directory" select="substring(., 4)" as="xs:string"/>
            
            <xsl:for-each select="collection(concat(., '?select=*.xml;recurse=yes;on-error=warning'))">
                <xsl:variable name="doc" select="/"/>
                
                <xsl:for-each select="distinct-values($doc//*:rs[some $cit in $categories[position() &gt; 2] satisfies contains(@type, $cit)]/@ref)">
                    <xsl:sort select="." order="ascending"/>
                    <xsl:variable name="current-ref" select="substring-after(., '#')" as="xs:string"/>
                    <xsl:variable name="software-id" select="lower-case(substring-after(key('software-target-by-id', $current-ref, $doc)[1], '#'))"/>
                    <xsl:variable name="software-name" select="(
                        key('software-name-by-id', $software-id, $software-list), 
                        error((), concat('No software name found for ID ''', $software-id, ''' / ref ''#', $current-ref ,''' (', base-uri($doc), ')')))[1]" as="xs:string"/>
                    <xsl:variable name="rs-with-this-ref" select="key('rs-by-ref', ., $doc)"/>
                                        
                    
                    <!-- SoftwareID and file path -->
                    <xsl:value-of select="concat($software-name, $csv-separator, $current-directory, substring-after(base-uri($doc), $current-directory))"/>
                    
                    
                    <!-- other annotations -->
                    <xsl:for-each select="subsequence($categories, 3)">
                        <xsl:variable name="count" select="count($rs-with-this-ref[contains(lower-case(@type), lower-case(current()))])" as="xs:integer"/>
                        <xsl:value-of select="concat($csv-separator, $count)"/>
                        <xsl:value-of select="concat($csv-separator, ('1'[$count &gt; 0],'0')[1])"/>
                    </xsl:for-each>
                    
                    <xsl:value-of select="$NEWLINE"/>
                </xsl:for-each>
                
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>