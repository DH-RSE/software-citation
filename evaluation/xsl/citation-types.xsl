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
    <xsl:key name="rs-by-key" match="*:rs" use="@key"/>
    
    <!-- Global variables -->
    
    <!-- directories with TEI files -->
    <xsl:variable name="collection-dirs" as="xs:string+" select="(        
        '../../data/deu/ADHO-DH/2016/tei',
        '../../data/deu/ADHO-DH/2019/tei',
        '../../data/eng/ADHO-DH/2015/tei',
        '../../data/eng/ADHO-DH/2016/tei',
        '../../data/eng/ADHO-DH/2017/tei',
        '../../data/eng/ADHO-DH/2018/tei',
        '../../data/eng/ADHO-DH/2019/tei',
        '../../data/eng/ADHO-DH/2020/tei',
        '../../data/fra/ADHO-DH/2016/tei',
        '../../data/fra/ADHO-DH/2017/tei',
        '../../data/fra/ADHO-DH/2018/tei',
        '../../data/fra/ADHO-DH/2019/tei',
        '../../data/fra/ADHO-DH/2020/tei',
        '../../data/ita/ADHO-DH/2015/tei',
        '../../data/ita/ADHO-DH/2016/tei',
        '../../data/ita/ADHO-DH/2017/tei',
        '../../data/ita/ADHO-DH/2018/tei',
        '../../data/por/ADHO-DH/2018/tei',
        '../../data/spa/ADHO-DH/2016/tei',
        '../../data/spa/ADHO-DH/2017/tei',
        '../../data/spa/ADHO-DH/2018/tei',
        '../../data/spa/ADHO-DH/2020/tei'
        )"/>
    
    <!-- categories for CSV header (later extended by boolean columns) -->
    <xsl:variable name="categories" select="('SoftwareID','Dateipfad','Name','Bib.Ref','Bib.Soft','Agent','URL','PID','Ver')" as="xs:string+"/>
    
    <!-- character to be used as CSV separator -->
    <xsl:variable name="csv-separator" select="','" as="xs:string"/>
    
    <!-- newline character -->
    <xsl:variable name="NEWLINE"><xsl:text>
</xsl:text></xsl:variable>
    
    
    <!-- Templates -->
    
    <xsl:template match="/">
        
        <!-- header row -->
        <xsl:value-of select="concat($categories[1], $csv-separator, $categories[2], $csv-separator)"/>
        <xsl:value-of select="concat('NameOnly', $csv-separator, 'NameOnly (bool)')"/>
        <xsl:for-each select="subsequence($categories, 3)">
            <xsl:value-of select="concat($csv-separator, ., $csv-separator, ., ' (bool)')"/>
        </xsl:for-each>
        <xsl:value-of select="$NEWLINE"/>
        
        <!-- following rows -->
        <xsl:for-each select="$collection-dirs">
            <xsl:variable name="current-directory" select="substring(., 4)" as="xs:string"/>
            
            <xsl:for-each select="collection(concat(., '?select=*.xml;recurse=yes;on-error=warning'))">
                <xsl:variable name="doc" select="/"/>
                
                <xsl:for-each select="distinct-values($doc//*:rs/@key)">
                    <xsl:sort select="." order="ascending"/>
                    <xsl:variable name="current-key" select="." as="xs:string"/>
                    <xsl:variable name="rs-with-this-key" select="key('rs-by-key', $current-key, $doc)"/>
                    
                    
                    <!-- SoftwareID and file path -->
                    <xsl:value-of select="concat($current-key, $csv-separator, $current-directory, substring-after(base-uri($doc), $current-directory))"/>
                    
                    <!-- Name only instances -->
                    <xsl:variable name="count-name-only" select="count($rs-with-this-key) - count($rs-with-this-key[exists(@ana)])" as="xs:integer"/>
                    <xsl:value-of select="concat($csv-separator, $count-name-only)"/>
                    <xsl:value-of select="concat($csv-separator, ('1'[(count($rs-with-this-key) = $count-name-only)], '0')[1])"/>
                    
                    <!-- Name instances -->
                    <xsl:variable name="count" select="count($rs-with-this-key[not(contains(lower-case(@ana), '#noname'))])" as="xs:integer"/>
                    <xsl:value-of select="concat($csv-separator, $count)"/>
                    <xsl:value-of select="concat($csv-separator, ('1'[$count &gt; 0],'0')[1])"/>
                    
                    
                    <!-- other annotations -->
                    <xsl:for-each select="subsequence($categories, 4)">
                        <xsl:variable name="count" select="count($rs-with-this-key[contains(lower-case(@ana), lower-case(concat('#',current())))])" as="xs:integer"/>
                        <xsl:value-of select="concat($csv-separator, $count)"/>
                        <xsl:value-of select="concat($csv-separator, ('1'[$count &gt; 0],'0')[1])"/>
                    </xsl:for-each>
                    
                    <xsl:value-of select="$NEWLINE"/>
                </xsl:for-each>
                
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>