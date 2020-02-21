<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
	xmlns="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gml="http://www.opengis.net/gml/3.2"
	xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:wfs="http://www.opengis.net/wfs"
	xmlns:wms="http://www.opengis.net/wms"
	xmlns:ows="http://www.opengis.net/ows" xmlns:wcs="http://www.opengis.net/wcs"
	xmlns:inspire_common="http://inspire.ec.europa.eu/schemas/common/1.0"
	xmlns:inspire_vs="http://inspire.ec.europa.eu/schemas/inspire_vs/1.0"
	xmlns:xlink="http://www.w3.org/1999/xlink" extension-element-prefixes="wms wcs ows wfs srv inspire_common inspire_vs">
	<xsl:template name="language">
		<xsl:param name="lang"/>
		<xsl:choose>
			<xsl:when
				test="//inspire_vs:ExtendedCapabilities/inspire_common:ResponseLanguage/inspire_common:Language">
				<language>
					<xsl:variable name="l" select="//inspire_vs:ExtendedCapabilities/inspire_common:ResponseLanguage/inspire_common:Language"/>
					<LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="{$l}"><xsl:value-of select="$l"/></LanguageCode>
					<!--<gco:CharacterString>
						<xsl:value-of
							select="//inspire_vs:ExtendedCapabilities/inspire_common:ResponseLanguage/inspire_common:Language"
						/>
					</gco:CharacterString>-->
				</language>

			</xsl:when>

			<xsl:when test="$lang">
				<language>
					<LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="{$lang}"><xsl:value-of select="$lang"/></LanguageCode>
				</language>
			</xsl:when>
			<xsl:otherwise>
				<language gco:nilReason="missing"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
