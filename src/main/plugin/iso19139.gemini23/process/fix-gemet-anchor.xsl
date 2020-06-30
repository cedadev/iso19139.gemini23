<?xml version="1.0" encoding="utf-8"?>

<!--
	Force metadata to have Gemini 2.2 Metadata Standard and Version and fix gml namespaces
-->

<xsl:stylesheet xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:gml="http://www.opengis.net/gml/3.2"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	version="2.0">
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
	<!--  Change GEMET Anchor to correct version  -->
	<xsl:template match="gmd:thesaurusName/gmd:CI_Citation[gmd:title/gco:CharacterString/text()='GEMET - INSPIRE themes, version 1.0']/gmd:identifier/gmd:MD_Identifier/gmd:code/gmx:Anchor">
		<xsl:message>==== Updating GEMET anchor encoding ====</xsl:message>
		<gmx:Anchor xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.httpinspireeceuropaeutheme-theme">geonetwork.thesaurus.external.theme.httpinspireeceuropaeutheme-theme</gmx:Anchor>
	</xsl:template>
	
	
	
	<!--  copy All  -->
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@xsi:schemaLocation" priority="10"/>
	
	<!--  Remove geonet:* elements.  -->
	<xsl:template match="geonet:*" priority="2"/>
</xsl:stylesheet>
