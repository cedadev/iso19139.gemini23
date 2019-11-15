<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:geonet="http://www.fao.org/geonet"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

    <!-- ================================================================= -->

    <!-- root element  -->
    <xsl:template match="gmd:MD_Metadata">
      <xsl:copy copy-namespaces="no">
        <!-- Explicitly declare namespaces -->
        <xsl:namespace name="gco" select="'http://www.isotc211.org/2005/gco'"/>
        <xsl:namespace name="gmi" select="'http://www.isotc211.org/2005/gmi'"/>
        <xsl:namespace name="gmx" select="'http://www.isotc211.org/2005/gmi'"/>
        <xsl:namespace name="gts" select="'http://www.isotc211.org/2005/gts'"/>
        <xsl:namespace name="gml" select="'http://www.opengis.net/gml/3.2'"/>
        <xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>
        <xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'"/>
        <xsl:namespace name="xs" select="'http://www.w3.org/2001/XMLSchema'"/>

        <xsl:copy-of select="@*" />

        <xsl:apply-templates select="*" />
      </xsl:copy>
    </xsl:template>


    <!-- ================================================================= -->

    <xsl:template match="gmd:metadataStandardName">
        <xsl:copy>
            <gco:CharacterString>ISO 19115:2003/19139</gco:CharacterString>
        </xsl:copy>
    </xsl:template>

    <!-- ================================================================= -->

    <xsl:template match="gmd:metadataStandardVersion">
        <xsl:copy>
            <gco:CharacterString>1.0</gco:CharacterString>
        </xsl:copy>
    </xsl:template>

    <!-- ================================================================= -->

    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- ================================================================= -->

    <xsl:template match="*[@gco:isoType]" priority="100">
        <xsl:variable name="elemName" select="@gco:isoType"/>

        <xsl:element name="{$elemName}">
            <xsl:apply-templates select="@*[name()!='gco:isoType']"/>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>

    <!-- ================================================================= -->

    <!-- Remove geonet:* elements. -->
    <xsl:template match="geonet:*" priority="2"/>

</xsl:stylesheet>
