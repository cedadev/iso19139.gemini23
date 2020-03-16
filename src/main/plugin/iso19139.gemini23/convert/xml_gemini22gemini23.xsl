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
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

    <!-- ================================================================= -->

        <!-- Template for converting Gemini 2.2 to Gemini 2.3 -->

    <!-- ================================================================= -->

   
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
   
    
    <!-- ================================================================= -->
    
    <!-- Resource Constraints -->
    
    <!-- TODO Needs some tests to copy existing constraints into new encoding
        or these below as defaults -->
    
    <xsl:template match="gmd:resourceConstraints[descendant::gmd:accessConstraints]" priority="10">
        <xsl:copy copy-namespaces="no">
            <!--<xsl:apply-templates select="@*|node()"/>-->
            <xsl:message>=== Adding Access Constraints</xsl:message>
            <gmd:MD_LegalConstraints>
                <gmd:accessConstraints>
                    <gmd:MD_RestrictionCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/gmxCodelists.xml#MD_RestrictionCode"
                        codeListValue="otherRestrictions">otherRestrictions</gmd:MD_RestrictionCode>
                </gmd:accessConstraints>
                <xsl:choose>
                    <xsl:when test="descendant::gmd:otherConstraints/gco:CharacterString">
                    <xsl:variable name="otherConstraint" select="descendant::gmd:otherConstraints/gco:CharacterString"/>
                    <xsl:message>=== Copying existing access constraint</xsl:message>
                    <gmd:otherConstraints>
                        <gco:CharacterString><xsl:value-of select="$otherConstraint"/></gco:CharacterString>
                    </gmd:otherConstraints>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>=== Adding default access constraint</xsl:message>
                        <gmd:otherConstraints>
                            <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/INSPIRE_Directive_Article13_1e">no limitations</gmx:Anchor>
                        </gmd:otherConstraints>
                    </xsl:otherwise>
                </xsl:choose>
            </gmd:MD_LegalConstraints>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="gmd:resourceConstraints[child::gmd:MD_Constraints]" priority="10">
        <xsl:copy copy-namespaces="no">
            <xsl:message>=== Adding Use Constraints</xsl:message>
            <!--<xsl:apply-templates select="@*|node()"/>-->
            <gmd:MD_LegalConstraints>
                <gmd:useConstraints>
                    <gmd:MD_RestrictionCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/gmxCodelists.xml#MD_RestrictionCode"
                        codeListValue="otherRestrictions">otherRestrictions</gmd:MD_RestrictionCode>
                </gmd:useConstraints>
                <xsl:choose>
                    <xsl:when test="descendant::gmd:useLimitation/gco:CharacterString">
                        <xsl:variable name="useLimitation" select="descendant::gmd:useLimitation/gco:CharacterString"/>
                        <xsl:message>=== Copying existing use Limitation</xsl:message>
                        <gmd:otherConstraints>
                            <gco:CharacterString><xsl:value-of select="$useLimitation"/></gco:CharacterString>
                        </gmd:otherConstraints>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>=== Adding default use Limitation</xsl:message>
                        <gmd:otherConstraints>
                            <gmx:Anchor>no conditions apply</gmx:Anchor>
                        </gmd:otherConstraints>
                    </xsl:otherwise>
                </xsl:choose>
            </gmd:MD_LegalConstraints>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*" priority="1">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <xsl:namespace name="gml" select="'http://www.opengis.net/gml/3.2'"/>
            <xsl:namespace name="srv" select="'http://www.isotc211.org/2005/srv'"/>
            <xsl:namespace name="gmx" select="'http://www.isotc211.org/2005/gmx'"/>
            <xsl:namespace name="gco" select="'http://www.isotc211.org/2005/gco'"/>
            <xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'"/>
            <xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>
            <xsl:namespace name="gmd" select="'http://www.isotc211.org/2005/gmd'"/>
            <xsl:namespace name="geonet" select="'http://www.fao.org/geonet'"/>
            <xsl:namespace name="xs" select="'http://www.w3.org/2001/XMLSchema'"/>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@xsi:schemaLocation" priority="10"/>
    
    <!--  Change standard to UK GEMINI  -->
    <xsl:template match="//gmd:metadataStandardName"  priority="10">
        <xsl:message>=== Updating Metadata Standard Name</xsl:message>
        <gmd:metadataStandardName>
            <gco:CharacterString>UK GEMINI</gco:CharacterString>
        </gmd:metadataStandardName>
    </xsl:template>
    
    <xsl:template match="//gmd:metadataStandardVersion"  priority="10">
        <xsl:message>=== Updating Metadata Standard Version</xsl:message>
        <gmd:metadataStandardVersion>
            <gco:CharacterString>2.3</gco:CharacterString>
        </gmd:metadataStandardVersion>
    </xsl:template>
    
    <!--  Remove geonet:* elements.  -->
    <xsl:template match="geonet:*" priority="2"/>

</xsl:stylesheet>
