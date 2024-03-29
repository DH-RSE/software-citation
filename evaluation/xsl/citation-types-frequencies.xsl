<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <!-- creates a CSV file that lists all unique software/abstract combinations with the corresponding citation annotations -->
    
    
    <!-- Serialization details -->
    <xsl:output method="text" omit-xml-declaration="yes"/>
    
    
    <xsl:include href="global-parameters.xsl"/>
    
    
    <!-- Keys -->    
    <xsl:key name="rs-by-ref" match="*:rs" use="@ref"/>
    <xsl:key name="ptr-by-target" match="*:ptr" use="@target"/>
    
    <!-- Global variables -->    
    
    
    <!-- additional columns for predefined filters (applied to file path, compare directory list above for examples) -->
    <!-- could also be ('/deu/', '/eng/', ...) for instance -->
    <!-- could also be ('/2015/', '/2016/', '/2017/', '/2018/', '/2019/', '/2020/') for instance -->
    <xsl:variable name="path-filters" select="''" as="xs:string+"/>
    
    
    <!-- instances of one specific software in one text -->
    <xsl:variable name="instances">
        <xsl:for-each select="$COLLECTION-DIRS">            
            <xsl:for-each select="collection(concat(., '?select=*.xml;recurse=yes;on-error=warning'))">
                <xsl:variable name="path" select="base-uri()" as="xs:string"/>
                <xsl:variable name="doc" select="/"/>
                <xsl:for-each select="distinct-values($doc//*:ptr[@type='software']/@target)">                
                    <xsl:variable name="current-software-target" select="." as="xs:string"/>
                    <xsl:variable name="rs-for-this-software" select="key('rs-by-ref', key('ptr-by-target', $current-software-target, $doc)/concat('#', @xml:id), $doc)"/>
                    <instance text="{$path}" software="{$current-software-target}">
                        <xsl:for-each select="$SOFTWARE-MENTION-TYPES">
                            <!-- counting frequencies -->
                            <!--<xsl:attribute name="{.}" select="count($rs-with-this-key[contains(lower-case(@ana), lower-case(concat('#',current())))])"/>-->
                            <!-- determining presence -->
                            <xsl:attribute name="{.}" select="('1'[exists($rs-for-this-software[tokenize(lower-case(@type), '\s+') = lower-case(current())])], '0')[1]"/>                            
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
        <xsl:value-of select="'Citation type,'"/>
        <xsl:for-each select="$path-filters">
            <xsl:value-of select="concat(., ' abs. frequency (n=', count($instances//*:instance[contains(@text, current())]), '),', .,' rel. frequency (in %),')"/>   
        </xsl:for-each>
        <xsl:value-of select="concat('ALL / abs. frequency (n=', $count-unique-instances, '),ALL / rel. frequency (in %)')"/>        
        <xsl:value-of select="$NEWLINE"/>
        
        
        <xsl:for-each select="$SOFTWARE-MENTION-TYPES">
            <xsl:variable name="citation-type" select="." as="xs:string"/>
            
            <xsl:value-of select="concat($citation-type, ',')"/>
            
            <xsl:for-each select="$path-filters">
                <xsl:variable name="abs" select="count($instances//*:instance[contains(@text, current())])" as="xs:double"/>
                <xsl:variable name="abs-citation-type" select="sum($instances//*:instance[contains(@text, current())]/@*[local-name()=$citation-type])" as="xs:double"/>
                <xsl:value-of select="concat(
                    (: abs. frequency :) $abs-citation-type, ',', 
                    (: rel. frequency :) if($abs=0) then 0 else format-number($abs-citation-type div $abs * 100, '##.##'), ','
                    )"/>
            </xsl:for-each>
            
            <xsl:value-of select="concat(
                (: abs. frequency :) sum($instances//*:instance/@*[local-name()=$citation-type]), ',', 
                (: rel. frequency :) format-number(sum($instances//*:instance/@*[local-name()=$citation-type]) div $count-unique-instances * 100, '##.##')
                )"/>
            <xsl:value-of select="$NEWLINE"/>
        </xsl:for-each>
        
    </xsl:template>
    
</xsl:stylesheet>