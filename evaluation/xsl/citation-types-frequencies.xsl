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
    
    <!-- softaware types -->
    <xsl:variable name="types" select="('Bib.Soft', 'Bib.Ref', 'Name.Only', 'Agent', 'URL', 'PID', 'Ver')" as="xs:string+"/>
    
    <!-- character to be used as CSV separator -->
    <xsl:variable name="csv-separator" select="','" as="xs:string"/>
    
    <!-- newline character -->
    <xsl:variable name="NEWLINE"><xsl:text>
</xsl:text></xsl:variable>
    
    <!-- instances of one specific software in one text -->
    <xsl:variable name="instances">
        <xsl:for-each select="$collection-dirs">            
            <xsl:for-each select="collection(concat(., '?select=*.xml;recurse=yes;on-error=warning'))">
                <xsl:variable name="path" select="base-uri()" as="xs:string"/>
                <xsl:variable name="doc" select="/"/>
                <xsl:for-each select="distinct-values($doc//*:rs/@key)">                    
                    <xsl:variable name="current-key" select="." as="xs:string"/>
                    <xsl:variable name="rs-with-this-key" select="key('rs-by-key', $current-key, $doc)"/>
                    <instance text="{$path}" software="{$current-key}">
                        <xsl:for-each select="$types">
                            <!-- counting frequencies -->
                            <!--<xsl:attribute name="{.}" select="count($rs-with-this-key[contains(lower-case(@ana), lower-case(concat('#',current())))])"/>-->
                            <!-- determining presence -->
                            <xsl:attribute name="{.}" select="('1'[exists($rs-with-this-key[contains(lower-case(@ana), lower-case(concat('#',current())))])], '0')[1]"/>                            
                        </xsl:for-each>
                    </instance> 
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:variable>
    
    
    <!-- Templates -->
    
    <xsl:template match="/">
        
        <xsl:message select="$instances"/>
        
        <!-- number of unique software instance in one text -->
        <xsl:variable name="count-unique-instances" select="count($instances//*:instance)" as="xs:integer"/>
        
        <!-- header row -->
        <xsl:value-of select="concat('Citation type,abs. frequency (n=', $count-unique-instances, '),rel. frequency (in %)')"/>        
        <xsl:value-of select="$NEWLINE"/>
        
        <xsl:for-each select="$types">
            <xsl:variable name="citation-type" select="." as="xs:string"/>
            <xsl:value-of select="concat(
                (: citation type :) $citation-type, ',', 
                (: abs. frequency :) sum($instances//*:instance/@*[local-name()=$citation-type]), ',', 
                (: rel. frequency :) format-number(sum($instances//*:instance/@*[local-name()=$citation-type]) div $count-unique-instances * 100, '##.##')
                )"/>
            <xsl:value-of select="$NEWLINE"/>
        </xsl:for-each>
        
    </xsl:template>
    
</xsl:stylesheet>