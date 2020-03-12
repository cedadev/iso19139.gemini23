<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns="http://www.isotc211.org/2005/gmd"
	xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gts="http://www.isotc211.org/2005/gts"
	xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:srv="http://www.isotc211.org/2005/srv"
  xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:wfs="http://www.opengis.net/wfs"
	xmlns:wms="http://www.opengis.net/wms" xmlns:ows11="http://www.opengis.net/ows/1.1"
	xmlns:ows="http://www.opengis.net/ows" xmlns:wcs="http://www.opengis.net/wcs"
	xmlns:inspire_common="http://inspire.ec.europa.eu/schemas/common/1.0"
	xmlns:inspire_vs="http://inspire.ec.europa.eu/schemas/inspire_vs/1.0"
	xmlns:xlink="http://www.w3.org/1999/xlink" extension-element-prefixes="wms wcs ows ows11 wfs srv inspire_common inspire_vs"
  exclude-result-prefixes="srv wms wcs ows ows11 wfs inspire_common inspire_vs">

	<!--
		=============================================================================
	-->

	<xsl:import href="language.xsl"/>
	<xsl:param name="uuid"/>
	<xsl:param name="Name"/>
	<xsl:param name="lang"/>
	<xsl:param name="topic"/>


	<!-- Max number of coordinate system to add
	to the metadata record. Avoid to have too many CRS when
	OGC server list all epsg database. -->
	<xsl:variable name="maxCRS">21</xsl:variable>

	<!--
		=============================================================================
	-->

	<xsl:include href="resp-party.xsl" />
	<xsl:include href="ref-system.xsl" />
	<xsl:include href="identification.xsl" />
    <xsl:include href="language.xsl"/>



	<!--
		=============================================================================
	-->

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<!--
		=============================================================================
	-->

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<!--
		==============================================================================
	-->

	<xsl:template match="*">
		<xsl:message terminate="no"> WARNING: Unmatched element: <xsl:value-of select="name()"/>
		</xsl:message>

		<xsl:apply-templates/>
	</xsl:template>
	<!--
		=============================================================================
	-->
	<xsl:template
		match="WMT_MS_Capabilities[//Layer/Name = $Name] | wms:WMS_Capabilities[//wms:Layer/wms:Layer/wms:Name = $Name] | wfs:WFS_Capabilities[//wfs:FeatureType/wfs:Name = $Name] | wcs:WCS_Capabilities[//wcs:CoverageOfferingBrief/wcs:name = $Name]">

		<xsl:variable name="ows">
			<xsl:choose>
				<xsl:when
					test="local-name(.) = 'WFS_Capabilities' and namespace-uri(.) = 'http://www.opengis.net/wfs' and @version = '1.1.0'"
					>true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<MD_Metadata>

			<!--
				- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			-->

			<fileIdentifier>
				<gco:CharacterString>
					<xsl:value-of select="$uuid"/>
				</gco:CharacterString>
			</fileIdentifier>

			<!--
				- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			-->

			<xsl:call-template name="language">
				<xsl:with-param name="lang" select="$lang"/>
			</xsl:call-template>

			<!--
				- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			-->

			<characterSet>
				<MD_CharacterSetCode codeList="./resources/codeList.xml#MD_CharacterSetCode"
					codeListValue="utf8"/>
			</characterSet>


			<!-- parentIdentifier -->
			<!-- mdHrLv -->
			<hierarchyLevel>
				<MD_ScopeCode codeList="./resources/codeList.xml#MD_ScopeCode"
					codeListValue="dataset"/>
			</hierarchyLevel>

			<!-- mdHrLvName -->

			<!--
				- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			-->

			<xsl:for-each
				select="//ContactInformation | //wms:ContactInformation | //wcs:responsibleParty">
				<contact>
					<CI_ResponsibleParty>
						<xsl:apply-templates select="." mode="RespParty"/>
					</CI_ResponsibleParty>
				</contact>
			</xsl:for-each>
			<xsl:for-each select="//ows:ServiceProvider">
				<contact>
					<CI_ResponsibleParty>
						<xsl:apply-templates select="." mode="RespParty"/>
					</CI_ResponsibleParty>
				</contact>
			</xsl:for-each>


			<!--
				- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			-->
			<xsl:variable name="df">[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]</xsl:variable>
			<dateStamp>
				<gco:DateTime>
					<xsl:value-of select="format-dateTime(current-dateTime(), $df)"/>
				</gco:DateTime>
			</dateStamp>

			<!--
				- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			-->
			<metadataStandardName>
				<gmx:Anchor xlink:href="http://vocab.nerc.ac.uk/collection/M25/current/GEMINI/">UK GEMINI</gmx:Anchor>
			</metadataStandardName>
			<metadataStandardVersion>
				<gco:CharacterString>2.3</gco:CharacterString>
			</metadataStandardVersion>

			<!-- spatRepInfo-->
			<xsl:choose>
				<!-- WMS 1.1.0 is space separated -->
				<xsl:when test="name() != 'wfs:WFS_Capabilities' and @version = '1.1.0' or @version = '1.0.0'">
					<xsl:for-each select="tokenize(//Layer[Name = $Name]/SRS, ' ')">
						<referenceSystemInfo>
							<MD_ReferenceSystem>
								<xsl:call-template name="RefSystemTypes">
									<xsl:with-param name="srs" select="."/>
								</xsl:call-template>
							</MD_ReferenceSystem>
						</referenceSystemInfo>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each
						select="//wms:Layer[wms:Name = $Name]/wms:CRS[position() &lt; $maxCRS] | //Layer[Name = $Name]/SRS[position() &lt; $maxCRS]|  //wfs:FeatureTypeList/wfs:FeatureType[wfs:Name = $Name]/wfs:DefaultSRS[position() &lt; $maxCRS]">
						<referenceSystemInfo>
							<MD_ReferenceSystem>
								<xsl:call-template name="RefSystemTypes">
									<xsl:with-param name="srs" select="."/>
								</xsl:call-template>
							</MD_ReferenceSystem>
						</referenceSystemInfo>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>

			<!--mdExtInfo-->
			<!--
				- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			-->
			<identificationInfo>
				<MD_DataIdentification>
					<xsl:apply-templates select="." mode="LayerDataIdentification">
						<xsl:with-param name="Name">
							<xsl:value-of select="$Name"/>
						</xsl:with-param>
						<xsl:with-param name="topic">
							<xsl:value-of select="$topic"/>
						</xsl:with-param>
						<xsl:with-param name="ows">
							<xsl:value-of select="$ows"/>
						</xsl:with-param>
						<xsl:with-param name="lang">
							<xsl:value-of select="$lang"/>
						</xsl:with-param>
					</xsl:apply-templates>
				</MD_DataIdentification>
			</identificationInfo>

			<!--contInfo-->
			<!--distInfo -->
			<distributionInfo>
				<MD_Distribution>
					<distributionFormat>
						<MD_Format>
							<name gco:nilReason="missing">
								<gco:CharacterString/>
							</name>
							<version gco:nilReason="missing">
								<gco:CharacterString/>
							</version>
						</MD_Format>
					</distributionFormat>
					<transferOptions>
						<MD_DigitalTransferOptions>
							<onLine>
								<CI_OnlineResource>
									<linkage>
										<URL>
											<xsl:choose>
												<xsl:when test="$ows = 'true'">
												<xsl:value-of
												select="//ows:Operation[@name = 'GetFeature']/ows:DCP/ows:HTTP/ows:Get/@xlink:href"
												/>
												</xsl:when>
												<xsl:when test="name(.) = 'WFS_Capabilities'">
												<xsl:value-of
												select="//wfs:GetFeature/wfs:DCPType/wfs:HTTP/wfs:Get/@onlineResource"
												/>
												</xsl:when>
												<xsl:when test="name(.) = 'WMT_MS_Capabilities'">
												<xsl:variable name="url">
												<xsl:value-of
												select="//GetMap/DCPType/HTTP/Get/OnlineResource/@xlink:href"
												/>
												</xsl:variable>
												<xsl:value-of select="$url"/>
													<xsl:variable name="req">
														<xsl:choose>
															<xsl:when test="not(ends-with($url,'&amp;amp;') or ends-with($url,'&amp;'))"
																>&amp;</xsl:when>
														</xsl:choose>
														<xsl:choose>
															<xsl:when
																test="not(contains(lower-case($url), 'request'))">
																<xsl:value-of select="'request=GetCapabilities&amp;version=1.3.0'"/>
															</xsl:when>
														</xsl:choose>
													</xsl:variable>
													<xsl:value-of select="$req"/>
												</xsl:when>
												<xsl:when test="name(.) = 'WMS_Capabilities'">
												<xsl:variable name="url">
												<xsl:value-of
												select="//wms:GetMap/wms:DCPType/wms:HTTP/wms:Get/wms:OnlineResource/@xlink:href"
												/>
												</xsl:variable>
												<xsl:value-of select="$url"/>
												<xsl:variable name="req">
												<xsl:choose>
													<xsl:when test="not(ends-with($url,'&amp;amp;') or ends-with($url,'&amp;'))"
												>&amp;</xsl:when>
												</xsl:choose>
												<xsl:choose>
												<xsl:when
												test="not(contains(lower-case($url), 'request'))">
												<xsl:value-of select="'request=GetCapabilities&amp;version=1.3.0'"/>
												</xsl:when>
												</xsl:choose>
												</xsl:variable>
												<xsl:value-of select="$req"/>
												</xsl:when>


												<xsl:otherwise>
												<xsl:value-of
												select="//wcs:GetCoverage/wcs:DCPType/wcs:HTTP/wcs:Get/wcs:OnlineResource/@xlink:href"
												/>
												</xsl:otherwise>
											</xsl:choose>
										</URL>
									</linkage>
									<protocol>
										<xsl:choose>
											<xsl:when test="name(.) = 'WMT_MS_Capabilities'">
												<gco:CharacterString>OGC:WMS-1.1.1-http-get-map</gco:CharacterString>
											</xsl:when>
											<xsl:when test="name(.) = 'WMS_Capabilities'">
												<gco:CharacterString>OGC:WMS-1.3.0-http-get-map</gco:CharacterString>
											</xsl:when>
											<xsl:when test="$ows = 'true'">
												<gco:CharacterString>OGC:WFS-1.1.0-http-get-feature</gco:CharacterString>
											</xsl:when>
											<xsl:when test="name(.) = 'WFS_Capabilities'">
												<gco:CharacterString>OGC:WFS-1.0.0-http-get-feature</gco:CharacterString>
											</xsl:when>
											<xsl:otherwise>
												<gco:CharacterString>OGC:WCS-1.0.0-http-get-coverage</gco:CharacterString>
											</xsl:otherwise>
										</xsl:choose>
									</protocol>
									<name>
										<gco:CharacterString>
											<xsl:value-of select="$Name"/>
										</gco:CharacterString>
									</name>
									<description>
										<gco:CharacterString>
											<xsl:choose>
												<xsl:when
												test="name(.) = 'WFS_Capabilities' or $ows = 'true'">
												<xsl:value-of
												select="//wfs:FeatureType[wfs:Name = $Name]/wfs:Title"
												/>
												</xsl:when>
												<xsl:when test="name(.) = 'WMT_MS_Capabilities'">
												<xsl:value-of select="//Layer[Name = $Name]/Title"
												/>
												</xsl:when>
												<xsl:when test="name(.) = 'WMS_Capabilities'">
												<xsl:value-of
												select="//wms:Layer[wms:Name = $Name]/wms:Title"/>
												</xsl:when>
												<xsl:otherwise>
												<xsl:value-of
												select="//wcs:CoverageOfferingBrief[wcs:name = $Name]/wcs:description"
												/>
												</xsl:otherwise>
											</xsl:choose>
										</gco:CharacterString>
									</description>

                  <xsl:variable name="function">
                    <xsl:choose>
                      <xsl:when test="name(.) = 'WMS_Capabilities' or name(.) = 'WMT_MS_Capabilities'">information</xsl:when>
                      <xsl:when test="$ows = 'true' or name(.) = 'WFS_Capabilities'">download</xsl:when>
                      <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>

                  <xsl:if test="string(normalize-space($function))">
                    <function>
                      <CI_OnLineFunctionCode
                        codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#CI_OnLineFunctionCode"
                        codeListValue="{$function}"/>
                    </function>
                  </xsl:if>

								</CI_OnlineResource>
							</onLine>
							<xsl:apply-templates mode="onlineResource"/>
						</MD_DigitalTransferOptions>
					</transferOptions>
				</MD_Distribution>
			</distributionInfo>

			<!--dqInfo-->
			<dataQualityInfo>
				<DQ_DataQuality>
					<scope>
						<DQ_Scope>
							<level>
								<MD_ScopeCode codeListValue="dataset"
									codeList="./resources/codeList.xml#MD_ScopeCode"/>
							</level>
						</DQ_Scope>
					</scope>

          <report>
            <DQ_DomainConsistency>
              <result>
                <DQ_ConformanceResult>
                  <specification>
                    <CI_Citation>
                      <title>
                        <gmx:Anchor xlink:href="http://data.europa.eu/eli/reg/2010/1089">
                          Commission Regulation (EU) No 1089/2010 of 23 November 2010 implementing Directive
                          2007/2/EC of the European Parliament and of the Council as regards interoperability
                          of spatial data sets and services</gmx:Anchor>
                      </title>
                      <date>
                        <CI_Date>
                          <date>
                            <gco:Date>2010-12-08</gco:Date>
                          </date>
                          <dateType>
                            <CI_DateTypeCode
                              codeList='http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/gmxCodelists.xml#CI_DateTypeCode'
                              codeListValue='publication' />
                          </dateType>
                        </CI_Date>
                      </date>
                    </CI_Citation>
                  </specification>
                  <!-- Explanation is a required element but can be empty -->
                  <explanation gco:nilReason="inapplicable"/>
                  <!-- Conformance has no been evaluated -->
                  <pass gco:nilReason="unknown" />
                </DQ_ConformanceResult>
              </result>
            </DQ_DomainConsistency>
          </report>

          <lineage>
            <LI_Lineage>
              <statement>
                <gco:CharacterString>Data captured with reference to Ordnance Survey Mastermap topographic data. </gco:CharacterString>
              </statement>
            </LI_Lineage>
          </lineage>

        </DQ_DataQuality>
			</dataQualityInfo>
			<!--mdConst -->

			<metadataConstraints>
				<xsl:for-each select="//ows:AccessConstraints|//wms:AccessConstraints|//wfs:AccessConstraints">
						<MD_LegalConstraints>
							<xsl:choose>
								<xsl:when
									test="

									. = 'copyright'
									or . = 'patent'
									or . = 'patentPending'
									or . = 'trademark'
									or . = 'license'
									or . = 'intellectualPropertyRight'
									or . = 'restricted'
									">


								<accessConstraints>
									<MD_RestrictionCode
										codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_RestrictionCode"
										codeListValue="{.}"/>
								</accessConstraints>
								<useConstraints>
									<MD_RestrictionCode
										codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_RestrictionCode"
										codeListValue="{.}"/>
								</useConstraints>
							</xsl:when>
							<xsl:when test="lower-case(.) = 'none'">
								<accessConstraints>
									<MD_RestrictionCode
										codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_RestrictionCode"
										codeListValue="otherRestrictions"/>
								</accessConstraints>
								<useConstraints>
									<MD_RestrictionCode
										codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_RestrictionCode"
										codeListValue="otherRestrictions"/>
								</useConstraints>
								<otherConstraints>
									<gco:CharacterString>no conditions apply</gco:CharacterString>
								</otherConstraints>
							</xsl:when>
							<xsl:otherwise>
								<accessConstraints>
									<MD_RestrictionCode
										codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_RestrictionCode"
										codeListValue="otherRestrictions"/>
								</accessConstraints>
								<useConstraints>
									<MD_RestrictionCode
										codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_RestrictionCode"
										codeListValue="otherRestrictions"/>
								</useConstraints>
								<otherConstraints>
									<gco:CharacterString>
										<xsl:value-of select="."/>
									</gco:CharacterString>
								</otherConstraints>
							</xsl:otherwise>
						</xsl:choose>
					</MD_LegalConstraints>
					<!--</resourceConstraints>-->

				</xsl:for-each>
			</metadataConstraints>
			<!--mdMaint-->
		</MD_Metadata>
	</xsl:template>


	<!-- Create as many online resource as result format available in WFS server
		to download features using GetFeature operation.

		WFS 1.1.0
	-->
	<xsl:template mode="onlineResource"
		match="//ows:Operation[@name = 'GetFeature']/ows:Parameter[@name = 'outputFormat']/ows:Value"
		priority="2">
		<xsl:variable name="format" select="."/>
		<xsl:variable name="baseUrl"
			select="//ows:Operation[@name = 'GetFeature']/ows:DCP/ows:HTTP/ows:Get/@xlink:href"/>

		<xsl:variable name="url">
			<xsl:value-of select="$baseUrl"/>
			<xsl:if test="not(contains($baseUrl, '?'))">?</xsl:if>
			<xsl:text>&amp;request=GetFeature&amp;service=WFS&amp;typename=</xsl:text>
			<xsl:value-of select="$Name"/>
			<xsl:text>&amp;outputFormat=</xsl:text>
			<xsl:value-of select="."/>
			<xsl:text>&amp;version=1.1.0</xsl:text>
		</xsl:variable>

		<xsl:call-template name="onlineResource">
			<xsl:with-param name="name" select="$Name"/>
			<xsl:with-param name="url" select="$url"/>
			<xsl:with-param name="title">
				<xsl:value-of select="//wfs:FeatureType[wfs:Name = $Name]/wfs:Title"/>
					(<xsl:value-of select="."/>) </xsl:with-param>
			<xsl:with-param name="protocol" select="'OGC:WFS-1.1.0-http-get-feature'"/>
      <xsl:with-param name="function" select="'download'" />
		</xsl:call-template>

	</xsl:template>


	<!--
		WFS 1.0.0
	-->
	<xsl:template mode="onlineResource" match="//wfs:GetFeature/wfs:ResultFormat/*" priority="2">
		<xsl:variable name="format" select="name(.)"/>

		<xsl:variable name="baseUrl" select="../../wfs:DCPType/wfs:HTTP/wfs:Get/@onlineResource"/>

		<xsl:variable name="url">
			<xsl:value-of select="$baseUrl"/>
			<xsl:if test="not(contains($baseUrl, '?'))">?</xsl:if>
			<xsl:text>&amp;request=GetFeature&amp;service=WFS&amp;typename=</xsl:text>
			<xsl:value-of select="$Name"/>
			<xsl:text>&amp;outputFormat=</xsl:text>
			<xsl:value-of select="$format"/>
			<xsl:text>&amp;version=1.0.0</xsl:text>
		</xsl:variable>

		<xsl:call-template name="onlineResource">
			<xsl:with-param name="name" select="$Name"/>
			<xsl:with-param name="url" select="$url"/>
			<xsl:with-param name="title">
				<xsl:value-of select="//wfs:FeatureType[wfs:Name = $Name]/wfs:Title"/>
					(<xsl:value-of select="name(.)"/>) </xsl:with-param>
			<xsl:with-param name="protocol" select="'OGC:WFS-1.0.0-http-get-feature'"/>
      <xsl:with-param name="function" select="'download'" />
		</xsl:call-template>
	</xsl:template>


	<!-- Metadata URL
	-->
	<xsl:template mode="onlineResource"
		match="
			//wms:Layer[wms:Name = $Name]/wms:MetadataURL |
			//Layer[Name = $Name]/MetadataURL"
		priority="2">

		<xsl:call-template name="onlineResource">
			<xsl:with-param name="name" select="concat($Name, ' (', name(.), ')')"/>
			<xsl:with-param name="url"
				select="wms:OnlineResource/@xlink:href | OnlineResource/@xlink:href"/>
			<xsl:with-param name="protocol" select="'WWW:LINK-1.0-http--link'"/>
      <xsl:with-param name="function" select="'information'" />
		</xsl:call-template>

	</xsl:template>

	<xsl:template mode="onlineResource"
		match="
			//wms:Layer[wms:Name = $Name]/wms:Style/wms:LegendURL |
			//Layer[Name = $Name]/Style/LegendURL"
		priority="2">

		<xsl:call-template name="onlineResource">
			<xsl:with-param name="name" select="concat($Name, ' (', name(.), ')')"/>
			<xsl:with-param name="url"
				select="wms:OnlineResource/@xlink:href | OnlineResource/@xlink:href"/>
			<xsl:with-param name="protocol" select="'WWW:LINK-1.0-http--link'"/>
      <xsl:with-param name="function" select="'information'" />
		</xsl:call-template>

	</xsl:template>

	<xsl:template mode="onlineResource" match="*">
		<xsl:apply-templates mode="onlineResource" select="*"/>
	</xsl:template>

	<xsl:template name="onlineResource">
		<xsl:param name="name"/>
		<xsl:param name="url"/>
		<xsl:param name="title"/>
		<xsl:param name="protocol"/>
    <xsl:param name="function"></xsl:param>

		<onLine>
			<CI_OnlineResource>
				<linkage>
					<URL>
						<xsl:value-of select="$url"/>
					</URL>
				</linkage>
				<protocol>
					<gco:CharacterString>
						<xsl:value-of select="$protocol"/>
					</gco:CharacterString>
				</protocol>
				<name>
					<gco:CharacterString>
						<xsl:value-of select="$name"/>
					</gco:CharacterString>
				</name>
				<description>
					<gco:CharacterString>
						<xsl:value-of select="$name"/>
					</gco:CharacterString>
				</description>

        <xsl:if test="string(normalize-space($function))">
          <function>
            <CI_OnLineFunctionCode
              codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#CI_OnLineFunctionCode"
              codeListValue="{$function}"/>
          </function>
        </xsl:if>
			</CI_OnlineResource>
		</onLine>
	</xsl:template>

  <xsl:template name="freetext">
    <xsl:param name="elementName" />
    <xsl:param name="value" />

    <xsl:if test="string($value)">
      <xsl:element name="{$elementName}">
        <gco:CharacterString><xsl:value-of select="$value" /></gco:CharacterString>
      </xsl:element>
    </xsl:if>
  </xsl:template>

	<!--
		=============================================================================
	-->

</xsl:stylesheet>

