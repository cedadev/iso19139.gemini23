<?xml version="1.0" encoding="utf-8"?>

<!--
	Force metadata to have Gemini 2.2 Metadata Standard and Version and fix gml namespaces
-->

<xsl:stylesheet xmlns:geonet="http://www.fao.org/geonetwork"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:eamp="http://environment.data.gov.uk/eamp" xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:gml="http://www.opengis.net/gml/3.2"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	version="2.0">
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"/>
	<!--  Change standard to UK GEMINI  -->
	<xsl:template match="gmd:DQ_DataQuality/gmd:report">
		<xsl:message>==== Updating Default data conformity report ====</xsl:message>
		<gmd:report>
			<gmd:DQ_DomainConsistency>
				<gmd:result>
					<gmd:DQ_ConformanceResult>
						<gmd:specification>
							<gmd:CI_Citation>
								<gmd:title>
									<gmx:Anchor xlink:href="http://data.europa.eu/eli/reg/2010/1089">Commission Regulation (EU) No 1089/2010 of 23 November 2010 implementing Directive 2007/2/EC of the European Parliament and of the Council as regards interoperability of spatial data sets and services</gmx:Anchor>
								</gmd:title>
								<gmd:date>
									<gmd:CI_Date>
										<gmd:date>
											<gco:Date>2010-12-08</gco:Date>
										</gmd:date>
										<gmd:dateType>
											<gmd:CI_DateTypeCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#CI_DateTypeCode"
												codeListValue="publication"/>
										</gmd:dateType>
									</gmd:CI_Date>
								</gmd:date>
							</gmd:CI_Citation>
						</gmd:specification>
						<gmd:explanation gco:nilReason="inapplicable"/>
						<gmd:pass gco:nilReason="unknown"/>
					</gmd:DQ_ConformanceResult>
				</gmd:result>
			</gmd:DQ_DomainConsistency>
		</gmd:report>
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
