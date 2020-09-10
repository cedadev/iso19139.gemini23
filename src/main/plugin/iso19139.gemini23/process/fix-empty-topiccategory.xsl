<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:geonet="http://www.fao.org/geonetwork" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:gmd="http://www.isotc211.org/2005/gmd" version="1.0">
    
    
    <!-- Remove geonet:* elements. -->
    <xsl:template match="geonet:*" priority="2"/>
    <xsl:output omit-xml-declaration="yes" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- ================================================================= -->
    <xsl:template
        match="gmd:topicCategory[not(gmd:MD_TopicCategoryCode)]"
        priority="10" />
    <!-- ================================================================= -->
    
    </xsl:stylesheet>