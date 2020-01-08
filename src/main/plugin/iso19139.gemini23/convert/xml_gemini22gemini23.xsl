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

        <!-- Template for converting Gemini 2.2 to Gemini 2.3 -->

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
    <!-- Metadata Standard Name and Version -->

    <xsl:template match="gmd:metadataStandardName">
        <xsl:message>=== Updating Metadata Standard Name ===</xsl:message>
        <xsl:copy>
            <gco:CharacterString>UK GEMINI</gco:CharacterString>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="gmd:metadataStandardVersion">
        <xsl:message>=== Updating Metadata Standard Version ===</xsl:message>
        <xsl:copy>
            <gco:CharacterString>2.3</gco:CharacterString>
        </xsl:copy>
    </xsl:template>

    <!-- ================================================================= -->

    <!-- Resource Constraints -->

    <!-- TODO Needs some tests to copy existing constraints into new encoding
        or these below as defaults -->

    <xsl:template match="gmd:resourceConstraints">
        <xsl:message>=== Updating Resource Constraints</xsl:message>
        <gmd:MD_LegalConstraints>
            <gmd:accessConstraints>
                <gmd:MD_RestrictionCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/gmxCodelists.xml#MD_RestrictionCode"
                                          codeListValue="otherRestrictions">otherRestrictions</gmd:MD_RestrictionCode>
           </gmd:accessConstraints>
            <gmd:otherConstraints>
                <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/INSPIRE_Directive_Article13_1e">no limitations</gmx:Anchor>
            </gmd:otherConstraints>
            <gmd:otherConstraints>
                <gco:CharacterString/>
            </gmd:otherConstraints>
        </gmd:MD_LegalConstraints>
        <gmd:MD_LegalConstraints>
            <gmd:useConstraints>
            <gmd:MD_RestrictionCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/gmxCodelists.xml#MD_RestrictionCode"
                                          codeListValue="otherRestrictions">otherRestrictions</gmd:MD_RestrictionCode>
            </gmd:useConstraints>
            <gmd:otherConstraints>
                <gmx:Anchor>no conditions apply</gmx:Anchor>
            </gmd:otherConstraints>
        </gmd:MD_LegalConstraints>
    </xsl:template>

    <!-- ================================================================= -->
    <!-- Insert character encoding as utf8 if it does not exist -->

    <xsl:template match="gmd:identificationInfo/*/gmd:characterSet" >
      <xsl:copy>
      <xsl:choose>
        <xsl:when test="not(gmd:MD_CharacterSetCode/@codeListValue='utf8')">
        <xsl:message>==== Add missing encoding ====</xsl:message>
            <gmd:MD_CharacterSetCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_CharacterSetCode"
                                     codeListValue="utf8"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>==== Copying existing encoding ====</xsl:message>
          <xsl:apply-templates select="gmd:MD_CharacterSetCode"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:copy>
    </xsl:template>


    <!-- ================================================================= -->

    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- ================================================================= -->

    <!-- <xsl:template match="*[@gco:isoType]" priority="100">
        <xsl:variable name="elemName" select="@gco:isoType"/>

        <xsl:element name="{$elemName}">
            <xsl:apply-templates select="@*[name()!='gco:isoType']"/>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template> -->

    <!-- ================================================================= -->

    <!-- Remove geonet:* elements. -->
    <xsl:template match="geonet:*" priority="2"/>

</xsl:stylesheet>
