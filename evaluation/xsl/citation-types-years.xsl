<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- evaluate citation types by year -->
    
    <xsl:template match="/">
        
        <xsl:variable name="citation-types" select="unparsed-text('../csv/citation-types.csv','UTF-8')"/>
        <xsl:variable name="NEWLINE"><xsl:text>
</xsl:text></xsl:variable>
        <xsl:variable name="SEP" select="','" as="xs:string"/>
        
        <xsl:variable name="year-counts">
            <counts>
                <xsl:analyze-string select="$citation-types" regex="{concat((:SoftwareID:)'^([^',$SEP,']+)',$SEP,(:Dateipfad:)'([^',$SEP,']+)',$SEP,'[^',$SEP,']+',$SEP,(:Name.Only:)'([^',$SEP,']+)',$SEP,'[^',$SEP,']+',$SEP,(:Bib.Ref:)'([^',$SEP,']+)',$SEP,'[^',$SEP,']+',$SEP,(:Bib.Soft:)'([^',$SEP,']+)',$SEP,'[^',$SEP,']+',$SEP,(:Agent:)'([^',$SEP,']+)',$SEP,'[^',$SEP,']+',$SEP,(:URL:)'([^',$SEP,']+)',$SEP,'[^',$SEP,']+',$SEP,(:PID:)'([^',$SEP,']+)',$SEP,'[^',$SEP,']+',$SEP,(:Ver:)'([^',$SEP,']+).*$')}" flags="m">
                    <!-- regex-groups:
                    1: SoftwareID
                    2: Dateipfad
                    3: Name.Only (bool)
                    4: Bib.Ref (bool)
                    5: Bib.Soft (bool)
                    6: Agent (bool)
                    7: URL (bool)
                    8: PID (bool)
                    9: Ver (bool)
                    -->
                    <xsl:matching-substring>
                        <xsl:if test="position() > 1">
                            <entry>
                                <name><xsl:value-of select="normalize-space(regex-group(1))"/></name>
                                <path><xsl:value-of select="regex-group(2)"/></path>
                                <value type="Name.Only"><xsl:value-of select="regex-group(3)"/></value>
                                <value type="Bib.Ref"><xsl:value-of select="regex-group(4)"/></value>
                                <value type="Bib.Soft"><xsl:value-of select="regex-group(5)"/></value>
                                <value type="Agent"><xsl:value-of select="regex-group(6)"/></value>
                                <value type="URL"><xsl:value-of select="regex-group(7)"/></value>
                                <value type="PID"><xsl:value-of select="regex-group(8)"/></value>
                                <value type="Ver"><xsl:value-of select="regex-group(9)"/></value>
                            </entry>
                        </xsl:if>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </counts>
        </xsl:variable>
        
        
        <!-- create CSV with values per year -->
        <xsl:result-document href="../csv/citation-types-years.csv" encoding="UTF-8" method="text">
            <xsl:text>Year;Name.Only.abs;Name.Only.rel;Bib.Ref.abs;Bib.Ref.rel;Bib.Soft.abs;Bib.Soft.rel;Agent.abs;Agent.rel;URL.abs;URL.rel;PID.abs;PID.rel;Ver.abs;Ver.rel</xsl:text>
            <xsl:value-of select="$NEWLINE"/>
            
            <xsl:for-each-group select="$year-counts//entry" group-by="substring-before(substring-after(path,'ADHO-DH/'), '/tei')">
                <xsl:variable name="group-size" select="count(current-group())"/>
                
                <xsl:variable name="sum-Name.Only" select="sum(current-group()/number(value[@type='Name.Only']))"/>
                <xsl:variable name="sum-Bib.Ref" select="sum(current-group()/number(value[@type='Bib.Ref']))"/>
                <xsl:variable name="sum-Bib.Soft" select="sum(current-group()/number(value[@type='Bib.Soft']))"/>
                <xsl:variable name="sum-Agent" select="sum(current-group()/number(value[@type='Agent']))"/>
                <xsl:variable name="sum-URL" select="sum(current-group()/number(value[@type='URL']))"/>
                <xsl:variable name="sum-PID" select="sum(current-group()/number(value[@type='PID']))"/>
                <xsl:variable name="sum-Ver" select="sum(current-group()/number(value[@type='Ver']))"/>
                
                <xsl:value-of select="current-grouping-key()"/>
                <xsl:value-of select="$SEP"/>
                <xsl:value-of select="$sum-Name.Only"/>
                <xsl:value-of select="$SEP"/>
                <xsl:value-of select="$sum-Name.Only div $group-size"/>
                <xsl:value-of select="$SEP"/>
                <xsl:value-of select="$sum-Bib.Ref"/>
                <xsl:value-of select="$SEP"/>
                <xsl:value-of select="$sum-Bib.Ref div $group-size"/>
                <xsl:value-of select="$SEP"/>
                <xsl:value-of select="$sum-Bib.Soft"/>
                <xsl:value-of select="$SEP"/>
                <xsl:value-of select="$sum-Bib.Soft div $group-size"/>
                <xsl:value-of select="$SEP"/>
                <xsl:value-of select="$sum-Agent"/>
                <xsl:value-of select="$SEP"/>
                <xsl:value-of select="$sum-Agent div $group-size"/>
                <xsl:value-of select="$SEP"/>
                <xsl:value-of select="$sum-URL"/>
                <xsl:value-of select="$SEP"/>
                <xsl:value-of select="$sum-URL div $group-size"/>
                <xsl:value-of select="$SEP"/>
                <xsl:value-of select="$sum-PID"/>
                <xsl:value-of select="$SEP"/>
                <xsl:value-of select="$sum-PID div $group-size"/>
                <xsl:value-of select="$SEP"/>
                <xsl:value-of select="$sum-Ver"/>
                <xsl:value-of select="$SEP"/>
                <xsl:value-of select="$sum-Ver div $group-size"/>
                <xsl:if test="position() != last()">
                    <xsl:value-of select="$NEWLINE"/>
                </xsl:if>
            </xsl:for-each-group>
        </xsl:result-document>
        
        <!-- create bar chart for values per year -->
        <xsl:result-document href="../html/citation-types-years.html" method="html" encoding="UTF-8">
            
            <xsl:variable name="years" as="xs:string+">
                <xsl:for-each-group select="$year-counts//entry" group-by="substring-before(substring-after(path,'ADHO-DH/'), '/tei')">
                    <xsl:value-of select="concat('&quot;', current-grouping-key(), '&quot;')"/>
                </xsl:for-each-group>
            </xsl:variable>
            <xsl:variable name="year-labels" select="string-join($years,',')"/>
            
            <html>
                <head>
                    <!-- Plotly.js -->
                    <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
                </head>
                <body>
                    <!-- Plotly chart will be drawn inside this DIV -->
                    <div id="myDiv" style="width: 600px; height: 500px;"></div>
                    <!-- Note of creation type -->
                    <p style="font-size:0.8em;"><xsl:value-of select="concat('created on ', current-dateTime(), ' by ', tokenize(static-base-uri(), '/')[last()])"/></p>
                    <script>
                        var trace1 = {
                        x: [<xsl:value-of select="$year-labels"/>],
                        y: [<xsl:for-each-group select="$year-counts//entry" group-by="substring-before(substring-after(path,'ADHO-DH/'), '/tei')">
                            <xsl:variable name="group-size" select="count(current-group())"/>
                            <xsl:value-of select="sum(current-group()/number(value[@type='Name.Only'])) div $group-size * 100"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>,</xsl:text>
                            </xsl:if>
                        </xsl:for-each-group>],
                        type: "bar",
                        name: "Name.Only"
                        
                        };
                        var trace2 = {
                        x: [<xsl:value-of select="$year-labels"/>],
                        y: [<xsl:for-each-group select="$year-counts//entry" group-by="substring-before(substring-after(path,'ADHO-DH/'), '/tei')">
                            <xsl:variable name="group-size" select="count(current-group())"/>
                            <xsl:value-of select="sum(current-group()/number(value[@type='Bib.Ref'])) div $group-size * 100"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>,</xsl:text>
                            </xsl:if>
                        </xsl:for-each-group>],
                        type: "bar",
                        name: "Bib.Ref"
                        };
                        
                        var trace3 = {
                        x: [<xsl:value-of select="$year-labels"/>],
                        y: [<xsl:for-each-group select="$year-counts//entry" group-by="substring-before(substring-after(path,'ADHO-DH/'), '/tei')">
                            <xsl:variable name="group-size" select="count(current-group())"/>
                            <xsl:value-of select="sum(current-group()/number(value[@type='Bib.Soft'])) div $group-size * 100"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>,</xsl:text>
                            </xsl:if>
                        </xsl:for-each-group>],
                        type: "bar",
                        name: "Bib.Soft"
                        };
                        
                        var trace4 = {
                        x: [<xsl:value-of select="$year-labels"/>],
                        y: [<xsl:for-each-group select="$year-counts//entry" group-by="substring-before(substring-after(path,'ADHO-DH/'), '/tei')">
                            <xsl:variable name="group-size" select="count(current-group())"/>
                            <xsl:value-of select="sum(current-group()/number(value[@type='Agent'])) div $group-size * 100"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>,</xsl:text>
                            </xsl:if>
                        </xsl:for-each-group>],
                        type: "bar",
                        name: "Agent"
                        };
                        
                        var trace5 = {
                        x: [<xsl:value-of select="$year-labels"/>],
                        y: [<xsl:for-each-group select="$year-counts//entry" group-by="substring-before(substring-after(path,'ADHO-DH/'), '/tei')">
                            <xsl:variable name="group-size" select="count(current-group())"/>
                            <xsl:value-of select="sum(current-group()/number(value[@type='URL'])) div $group-size * 100"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>,</xsl:text>
                            </xsl:if>
                        </xsl:for-each-group>],
                        type: "bar",
                        name: "URL"
                        };
                        
                        var trace6 = {
                        x: [<xsl:value-of select="$year-labels"/>],
                        y: [<xsl:for-each-group select="$year-counts//entry" group-by="substring-before(substring-after(path,'ADHO-DH/'), '/tei')">
                            <xsl:variable name="group-size" select="count(current-group())"/>
                            <xsl:value-of select="sum(current-group()/number(value[@type='PID'])) div $group-size * 100"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>,</xsl:text>
                            </xsl:if>
                        </xsl:for-each-group>],
                        type: "bar",
                        name: "PID"
                        };
                        
                        var trace7 = {
                        x: [<xsl:value-of select="$year-labels"/>],
                        y: [<xsl:for-each-group select="$year-counts//entry" group-by="substring-before(substring-after(path,'ADHO-DH/'), '/tei')">
                            <xsl:variable name="group-size" select="count(current-group())"/>
                            <xsl:value-of select="sum(current-group()/number(value[@type='Ver'])) div $group-size * 100"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>,</xsl:text>
                            </xsl:if>
                        </xsl:for-each-group>],
                        type: "bar",
                        name: "Ver"
                        };
                        
                        var data = [trace1, trace2, trace3, trace4, trace5, trace6, trace7];
                        var layout = {
                        title: "Citation types per year",
                        yaxis: {title: "Number of citation types (per abstract, in %)"},
                        xaxis: {title: "Jahr"},
                        barmode: "group"
                        };
                        
                        Plotly.newPlot('myDiv', data, layout);
                    </script>
                </body>
            </html>
        </xsl:result-document>
        
        
    </xsl:template>
    
</xsl:stylesheet>