<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns    ="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gts="http://www.isotc211.org/2005/gts"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:srv="http://www.isotc211.org/2005/srv"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										xmlns:xlink="http://www.w3.org/1999/xlink"
										xmlns:wfs="http://www.opengis.net/wfs"
                    xmlns:gmx="http://www.isotc211.org/2005/gmx"
                    xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:ows="http://www.opengis.net/ows"
										xmlns:ows11="http://www.opengis.net/ows/1.1"
										xmlns:wcs="http://www.opengis.net/wcs"
										xmlns:wms="http://www.opengis.net/wms"
                                        xmlns:wps="http://www.opengeospatial.net/wps"
                                        xmlns:wps1="http://www.opengis.net/wps/1.0.0"
                                        xmlns:gml="http://www.opengis.net/gml/3.2"
										xmlns:math="http://exslt.org/math"
										xmlns:exslt="http://exslt.org/common"
										xmlns:inspire_common="http://inspire.ec.europa.eu/schemas/common/1.0"
										xmlns:inspire_vs="http://inspire.ec.europa.eu/schemas/inspire_vs/1.0"
										extension-element-prefixes="math exslt wcs ows wps wps1 ows11 wfs gml">
<!-- note this template does not handle WFS 2.0.0 -->
	<!-- ============================================================================= -->
	<xsl:import href="language.xsl"/>
	<xsl:template match="*" mode="SrvDataIdentification">
		<xsl:param name="topic"/>
		<xsl:param name="ows"/>
		<xsl:param name="lang">eng</xsl:param>

		<xsl:variable name="s" select="Service|wfs:Service|wms:Service|ows:ServiceIdentification|ows11:ServiceIdentification|wcs:Service"/>

		<citation>
			<CI_Citation>
				<title>
					<gco:CharacterString>
						<xsl:choose>
							<xsl:when test="$ows='true'">
								<xsl:value-of select="ows:ServiceIdentification/ows:Title|
													ows11:ServiceIdentification/ows11:Title"/>
							</xsl:when>
							<xsl:when test="name(.)='WFS_Capabilities'">
								<xsl:value-of select="wfs:Service/wfs:Title"/>
							</xsl:when>
							<xsl:when test="name(.)='WMS_Capabilities'">
								<xsl:value-of select="wms:Service/wms:Title"/>
							</xsl:when>
							<xsl:when test="name(.)='WMT_MS_Capabilities'">
								<xsl:value-of select="Service/Title"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="wcs:Service/wcs:label"/>
							</xsl:otherwise>
						</xsl:choose>
					</gco:CharacterString>
				</title>
				<date>
					<CI_Date>
						<date>
							<xsl:choose>
								<xsl:when test="//inspire_vs:ExtendedCapabilities/inspire_common:TemporalReference/inspire_common:DateOfLastRevision">
									<gco:Date>
										<xsl:value-of select="//inspire_vs:ExtendedCapabilities/inspire_common:TemporalReference/inspire_common:DateOfLastRevision"/>
									</gco:Date>
								</xsl:when>
								<xsl:otherwise>
									<gco:DateTime>
										<xsl:variable name="df">[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]</xsl:variable>
										<xsl:value-of select="format-dateTime(current-dateTime(),$df)"/>
									</gco:DateTime>
								</xsl:otherwise>
							</xsl:choose>
						</date>
						<dateType>
							<CI_DateTypeCode codeList="./resources/codeList.xml#CI_DateTypeCode" codeListValue="revision"/>
						</dateType>
					</CI_Date>
				</date>
				<xsl:message>==== Resource Identifier = <xsl:value-of select="$uuid"/> ====</xsl:message>
				<identifier>
                  <RS_Identifier>
                     <code>
                        <gco:CharacterString><xsl:value-of select="$uuid"/>_resource</gco:CharacterString>
                     </code>
                  </RS_Identifier>
               </identifier>
			</CI_Citation>
		</citation>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<abstract>
			<gco:CharacterString>
				<xsl:choose>
					<xsl:when test="$ows='true'">
						<xsl:value-of select="ows:ServiceIdentification/ows:Abstract|
											ows11:ServiceIdentification/ows11:Abstract"/>
					</xsl:when>
					<xsl:when test="name(.)='WFS_Capabilities'">
						<xsl:value-of select="wfs:Service/wfs:Abstract"/>
					</xsl:when>
					<xsl:when test="name(.)='WMS_Capabilities'">
						<xsl:value-of select="wms:Service/wms:Abstract"/>
					</xsl:when>
					<xsl:when test="name(.)='WMT_MS_Capabilities'">
						<xsl:value-of select="Service/Abstract"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="wcs:Service/wcs:description"/>
					</xsl:otherwise>
				</xsl:choose>
			</gco:CharacterString>
		</abstract>

		<!--idPurp-->

		<status>
			<MD_ProgressCode codeList="./resources/codeList.xml#MD_ProgressCode" codeListValue="completed" />
		</status>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="//ContactInformation|//wcs:responsibleParty|//wms:responsibleParty|wms:Service/wms:ContactInformation">
			<pointOfContact>
				<CI_ResponsibleParty>
					<xsl:apply-templates select="." mode="RespParty"/>
				</CI_ResponsibleParty>
			</pointOfContact>
		</xsl:for-each>
		<xsl:for-each select="//ows:ServiceProvider|//ows11:ServiceProvider">
			<pointOfContact>
				<CI_ResponsibleParty>
					<xsl:apply-templates select="." mode="RespParty"/>
				</CI_ResponsibleParty>
			</pointOfContact>
		</xsl:for-each>

		<!-- resMaint -->
		<!-- graphOver -->
		<!-- dsFormat-->
		<xsl:for-each select="$s/KeywordList|$s/wfs:keywords|$s/wcs:keywords|$s/ows:Keywords|$s/ows11:Keywords|$s/wms:KeywordList">
			<descriptiveKeywords>
				<MD_Keywords>
					<xsl:apply-templates select="." mode="Keywords"/>
				</MD_Keywords>
			</descriptiveKeywords>
		</xsl:for-each>

		<xsl:for-each-group select="$s/wms:KeywordList/wms:Keyword" group-by="@vocabulary">
			<descriptiveKeywords>
				<MD_Keywords>
					<xsl:for-each select="../wms:Keyword[@vocabulary = current-grouping-key()]">
						<keyword>
							<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
						</keyword>
					</xsl:for-each>
					<type>
						<MD_KeywordTypeCode codeList="./resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
					</type>
					<xsl:if test="current-grouping-key() != ''">
						<thesaurusName>
							<CI_Citation>
								<title>
									<gco:CharacterString><xsl:value-of select="current-grouping-key()"/></gco:CharacterString>
								</title>
								<alternateTitle gco:nilReason="missing">
									<gco:CharacterString/>
								</alternateTitle>
								<date gco:nilReason="missing"/>
							</CI_Citation>
						</thesaurusName>
					</xsl:if>
				</MD_Keywords>
			</descriptiveKeywords>
		</xsl:for-each-group>

		<xsl:for-each select="//inspire_vs:ExtendedCapabilities/inspire_common:MandatoryKeyword[@xsi:type='inspire_common:classificationOfSpatialDataService']">
			<descriptiveKeywords>
				<MD_Keywords xmlns:gmx="http://www.isotc211.org/2005/gmx">
					<xsl:for-each select="inspire_common:KeywordValue">
						<keyword>
							<gco:CharacterString>
								<xsl:value-of select="."/>
							</gco:CharacterString>
						</keyword>
					</xsl:for-each>
					<type>
						<MD_KeywordTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#MD_KeywordTypeCode" codeListValue="theme"/>
					</type>
					<thesaurusName>
						<CI_Citation>
							<title>
								<gco:CharacterString>INSPIRE Service taxonomy</gco:CharacterString>
							</title>
							<alternateTitle gco:nilReason="missing">
								<gco:CharacterString/>
							</alternateTitle>
							<date>
								<CI_Date>
									<date>
										<gco:Date>2010-04-22</gco:Date>
									</date>
									<dateType>
										<CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication"/>
									</dateType>
								</CI_Date>
							</date>
						</CI_Citation>
					</thesaurusName>
				</MD_Keywords>
			</descriptiveKeywords>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		
		<xsl:for-each select="$s/wms:AccessConstraints|$s/ows:AccessConstraints">
				<!-- <MD_LegalConstraints>
					<useLimitation>
                  		<gco:CharacterString><xsl:value-of select='.'/></gco:CharacterString>
               		</useLimitation>
					<accessConstraints>
						<MD_RestrictionCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/gmxCodelists.xml#MD_RestrictionCode" codeListValue="otherRestrictions">otherRestrictions</MD_RestrictionCode>
					</accessConstraints>
					<otherConstraints>
						<gco:CharacterString>no limitations</gco:CharacterString>
					</otherConstraints>
				</MD_LegalConstraints> -->
		<resourceConstraints>
			<MD_LegalConstraints>
				<accessConstraints>
					<MD_RestrictionCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/gmxCodelists.xml#MD_RestrictionCode" codeListValue="otherRestrictions">otherRestrictions</MD_RestrictionCode> 
				</accessConstraints>
				<otherConstraints>
					<gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/noLimitations">no limitations</gmx:Anchor>
				</otherConstraints>
			</MD_LegalConstraints>
		</resourceConstraints>
		<resourceConstraints>
			<MD_LegalConstraints>
				<useConstraints>
					<MD_RestrictionCode codeList="http://standards.iso.org/iso/19139/resources/gmxCodelists.xml#MD_RestrictionCode" codeListValue="otherRestrictions">otherRestrictions</MD_RestrictionCode>
				</useConstraints>
				<otherConstraints>
					<gco:CharacterString><xsl:value-of select='.'/></gco:CharacterString>
				</otherConstraints>
			</MD_LegalConstraints>
		</resourceConstraints>
		</xsl:for-each>
	

		<srv:serviceType>
			<gco:LocalName codeSpace="www.w3c.org">
				<xsl:choose>
					<xsl:when test="//inspire_vs:ExtendedCapabilities/inspire_common:SpatialDataServiceType"><xsl:value-of select="//inspire_vs:ExtendedCapabilities/inspire_common:SpatialDataServiceType"/></xsl:when>
					<xsl:when test="name(.)='WMT_MS_Capabilities' or name(.)='WMS_Capabilities'">view</xsl:when>
					<xsl:when test="name(.)='WCS_Capabilities'">other</xsl:when>
					<xsl:when test="name(.)='wps:Capabilities'">other</xsl:when>
					<xsl:when test="name(.)='wfs:Capabilities'">download</xsl:when>
					<xsl:otherwise>other</xsl:otherwise>
				</xsl:choose>
			</gco:LocalName>
		</srv:serviceType>
		<srv:serviceTypeVersion>
			<gco:CharacterString><xsl:value-of select='@version'/></gco:CharacterString>
		</srv:serviceTypeVersion>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<srv:accessProperties>
			<MD_StandardOrderProcess>
				<fees>
					<gco:CharacterString><xsl:value-of select="$s/Fees|$s/wms:Fees|$s/wfs:Fees|$s/ows:Fees|$s/ows11:Fees|$s/wcs:fees"/></gco:CharacterString>
				</fees>
			</MD_StandardOrderProcess>
		</srv:accessProperties>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		Extent in OGC spec are somehow differents !

		WCS 1.0.0
		<lonLatEnvelope srsName="WGS84(DD)">
				<gml:pos>-130.85168 20.7052</gml:pos>
				<gml:pos>-62.0054 54.1141</gml:pos>
		</lonLatEnvelope>

		WFS 1.1.0
		<ows:WGS84BoundingBox>
				<ows:LowerCorner>-124.731422 24.955967</ows:LowerCorner>
				<ows:UpperCorner>-66.969849 49.371735</ows:UpperCorner>
		</ows:WGS84BoundingBox>

		WMS 1.1.1
		<LatLonBoundingBox minx="-74.047185" miny="40.679648" maxx="-73.907005" maxy="40.882078"/>

        WMS 1.3.0
        <EX_GeographicBoundingBox>
	        <westBoundLongitude>-178.9988054730254</westBoundLongitude>
	        <eastBoundLongitude>179.0724773329789</eastBoundLongitude>
	        <southBoundLatitude>-0.5014529001680404</southBoundLatitude>
	        <northBoundLatitude>88.9987992292308</northBoundLatitude>
        </EX_GeographicBoundingBox>
        <BoundingBox CRS="EPSG:4326" minx="27.116136375774644" miny="-17.934116876940887" maxx="44.39484823803499" maxy="6.052081516030762"/>

        WPS 0.4.0 : none

        WPS 1.0.0 : none
		 -->
        <xsl:if test="name(.)!='wps:Capabilities'">
		    <srv:extent>
				<EX_Extent>
					<geographicElement>
						<EX_GeographicBoundingBox>
							<xsl:choose>
								<xsl:when test="$ows='true' or name(.)='WCS_Capabilities'">

									<xsl:variable name="boxes">
										<xsl:choose>
											<xsl:when test="$ows='true'">
												<xsl:for-each select="//ows:WGS84BoundingBox/ows:LowerCorner">
													<xmin><xsl:value-of	select="substring-before(., ' ')"/></xmin>
													<ymin><xsl:value-of	select="substring-after(., ' ')"/></ymin>
												</xsl:for-each>
												<xsl:for-each select="//ows:WGS84BoundingBox/ows:UpperCorner">
													<xmax><xsl:value-of	select="substring-before(., ' ')"/></xmax>
													<ymax><xsl:value-of	select="substring-after(., ' ')"/></ymax>
												</xsl:for-each>
											</xsl:when>
											<xsl:when test="name(.)='WCS_Capabilities'">
												<xsl:for-each select="//wcs:lonLatEnvelope/gml:pos[1]">
													<xmin><xsl:value-of	select="substring-before(., ' ')"/></xmin>
													<ymin><xsl:value-of	select="substring-after(., ' ')"/></ymin>
												</xsl:for-each>
												<xsl:for-each select="//wcs:lonLatEnvelope/gml:pos[2]">
													<xmax><xsl:value-of	select="substring-before(., ' ')"/></xmax>
													<ymax><xsl:value-of	select="substring-after(., ' ')"/></ymax>
												</xsl:for-each>
											</xsl:when>
										</xsl:choose>
									</xsl:variable>

									<westBoundLongitude>
										<gco:Decimal><xsl:copy-of select="math:min(exslt:node-set($boxes)/*[name(.)='xmin'])"/></gco:Decimal>
									</westBoundLongitude>
									<eastBoundLongitude>
										<gco:Decimal><xsl:value-of select="math:max(exslt:node-set($boxes)/*[name(.)='xmax'])"/></gco:Decimal>
									</eastBoundLongitude>
									<southBoundLatitude>
										<gco:Decimal><xsl:value-of select="math:min(exslt:node-set($boxes)/*[name(.)='ymin'])"/></gco:Decimal>
									</southBoundLatitude>
									<northBoundLatitude>
										<gco:Decimal><xsl:value-of select="math:max(exslt:node-set($boxes)/*[name(.)='ymax'])"/></gco:Decimal>
									</northBoundLatitude>
								</xsl:when>
								<xsl:otherwise>
									<westBoundLongitude>
										<gco:Decimal><xsl:value-of select="math:min(//wms:EX_GeographicBoundingBox/wms:westBoundLongitude|//LatLonBoundingBox/@minx|//wfs:LatLongBoundingBox/@minx)"/></gco:Decimal>
									</westBoundLongitude>
									<eastBoundLongitude>
										<gco:Decimal><xsl:value-of select="math:max(//wms:EX_GeographicBoundingBox/wms:eastBoundLongitude|//LatLonBoundingBox/@maxx|//wfs:LatLongBoundingBox/@maxx)"/></gco:Decimal>
									</eastBoundLongitude>
									<southBoundLatitude>
										<gco:Decimal><xsl:value-of select="math:min(//wms:EX_GeographicBoundingBox/wms:southBoundLatitude|//LatLonBoundingBox/@miny|//wfs:LatLongBoundingBox/@miny)"/></gco:Decimal>
									</southBoundLatitude>
									<northBoundLatitude>
										<gco:Decimal><xsl:value-of select="math:max(//wms:EX_GeographicBoundingBox/wms:northBoundLatitude|//LatLonBoundingBox/@maxy|//wfs:LatLongBoundingBox/@maxy)"/></gco:Decimal>
									</northBoundLatitude>
								</xsl:otherwise>
							</xsl:choose>
						</EX_GeographicBoundingBox>
					</geographicElement>
				</EX_Extent>
		    </srv:extent>
        </xsl:if>
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<srv:couplingType gco:nilReason="missing"/>
         <srv:containsOperations gco:nilReason="missing"/>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		Done by harvester after data metadata creation
		<xsl:for-each select="//Layer[count(./*[name(.)='Layer'])=0] | FeatureType[count(./*[name(.)='FeatureType'])=0] | CoverageOfferingBrief[count(./*[name(.)='CoverageOfferingBrief'])=0]">
				<srv:operatesOn>
						<MD_DataIdentification uuidref="">
						<xsl:value-of select="Name"/>
						</MD_DataIdentification>
				</srv:operatesOn>
		</xsl:for-each>
		-->

	</xsl:template>


	<!-- ============================================================================= -->
	<!-- === LayerDataIdentification === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="LayerDataIdentification">
		<xsl:param name="Name"/>
		<xsl:param name="topic"/>
		<xsl:param name="ows"/>
		<xsl:param name="lang">eng</xsl:param>
		<citation>
			<CI_Citation>
				<title>
					<gco:CharacterString>
						<xsl:choose>
							<xsl:when test="name(.)='WFS_Capabilities' or name(.)='wfs:WFS_Capabilities' or $ows='true'">
								<xsl:value-of select="//wfs:FeatureType[wfs:Name=$Name]/wfs:Title"/>
							</xsl:when>
							<xsl:when test="name(.)='WMS_Capabilities'">
								<xsl:value-of select="//wms:Layer[wms:Name=$Name]/wms:Title"/>
							</xsl:when>
							<xsl:when test="name(.)='WMT_MS_Capabilities'">
								<xsl:value-of select="//Layer[Name=$Name]/Title"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="//wcs:CoverageOfferingBrief[wcs:name=$Name]/wcs:label"/>
							</xsl:otherwise>
						</xsl:choose>
					</gco:CharacterString>
				</title>
				<date>
					<CI_Date>
						<xsl:variable name="df">[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]</xsl:variable>
						<date>
							<gco:DateTime><xsl:value-of select="format-dateTime(current-dateTime(),$df)"/></gco:DateTime>
						</date>
						<dateType>
							<CI_DateTypeCode codeList="./resources/codeList.xml#CI_DateTypeCode" codeListValue="revision"/>
						</dateType>
					</CI_Date>
				</date>
				<xsl:message>==== Resource Identifier = <xsl:value-of select="$uuid"/> ====</xsl:message>
				<identifier>
                  <RS_Identifier>
                     <code>
                        <gco:CharacterString><xsl:value-of select="$uuid"/>_resource</gco:CharacterString>
                     </code>
                  </RS_Identifier>
               </identifier>
			</CI_Citation>
		</citation>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<abstract>
			<gco:CharacterString>
				<xsl:choose>
					<xsl:when test="name(.)='WFS_Capabilities' or $ows='true'">
						<xsl:value-of select="//wfs:FeatureType[wfs:Name=$Name]/wfs:Abstract"/>
					</xsl:when>
					<xsl:when test="name(.)='WMS_Capabilities'">
						<xsl:value-of select="//wms:Layer[wms:Name=$Name]/wms:Abstract"/>
					</xsl:when>
					<xsl:when test="name(.)='WMT_MS_Capabilities'">
						<xsl:value-of select="//Layer[Name=$Name]/Abstract"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="//wcs:CoverageOfferingBrief[wcs:name=$Name]/wcs:description"/>
					</xsl:otherwise>
				</xsl:choose>
			</gco:CharacterString>
		</abstract>

		<!--idPurp-->

		<status>
			<MD_ProgressCode codeList="./resources/codeList.xml#MD_ProgressCode" codeListValue="completed" />
		</status>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="Service/ContactInformation|wms:Service/wms:ContactInformation">
			<pointOfContact>
				<CI_ResponsibleParty>
					<xsl:apply-templates select="." mode="RespParty"/>
				</CI_ResponsibleParty>
			</pointOfContact>
		</xsl:for-each>
		<xsl:for-each select="//ows:ServiceProvider|//ows11:ServiceProvider">
			<pointOfContact>
				<CI_ResponsibleParty>
					<xsl:apply-templates select="." mode="RespParty"/>
				</CI_ResponsibleParty>
			</pointOfContact>
			</xsl:for-each>

		<!-- <xsl:for-each select="//ContactInformation|//wcs:responsibleParty|//wms:responsibleParty|wms:Service/wms:ContactInformation">
			<pointOfContact>
				<CI_ResponsibleParty>
					<xsl:apply-templates select="." mode="RespParty"/>
				</CI_ResponsibleParty>
			</pointOfContact>
		</xsl:for-each>
		<xsl:for-each select="//ows:ServiceProvider|//ows11:ServiceProvider">
			<pointOfContact>
				<CI_ResponsibleParty>
					<xsl:apply-templates select="." mode="RespParty"/>
				</CI_ResponsibleParty>
			</pointOfContact>
		</xsl:for-each> -->

		<!-- resMaint -->
		<!-- graphOver -->
		<!-- dsFormat-->
		<xsl:for-each select="//Layer[Name=$Name]/KeywordList|keywords">
			<descriptiveKeywords>
				<MD_Keywords>
					<xsl:apply-templates select="." mode="Keywords"/>
				</MD_Keywords>
			</descriptiveKeywords>
		</xsl:for-each>


		<xsl:for-each-group select="//wms:Layer[wms:Name=$Name]/wms:KeywordList/wms:Keyword|wms:Service/wms:KeywordList/wms:Keyword"
			group-by="@vocabulary">
			<descriptiveKeywords>
				<MD_Keywords>
					<xsl:for-each select="../wms:Keyword[@vocabulary = current-grouping-key()]">
						<keyword>
							<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
						</keyword>
					</xsl:for-each>
					<type>
						<MD_KeywordTypeCode codeList="./resources/codeList.xml#MD_KeywordTypeCode" codeListValue="theme" />
					</type>
					<xsl:if test="current-grouping-key() != ''">
						<thesaurusName>
							<CI_Citation>
								<title>
									<gco:CharacterString><xsl:value-of select="current-grouping-key()"/></gco:CharacterString>
								</title>
								<alternateTitle gco:nilReason="missing">
									<gco:CharacterString/>
								</alternateTitle>
								<date gco:nilReason="missing"/>

							</CI_Citation>
						</thesaurusName>
					</xsl:if>
				</MD_Keywords>
			</descriptiveKeywords>
		</xsl:for-each-group>

		<!--<xsl:for-each select="//wfs:FeatureType[wfs:Name=$Name]">
			<descriptiveKeywords>
				<MD_Keywords>
					<xsl:apply-templates select="." mode="Keywords"/>
				</MD_Keywords>
			</descriptiveKeywords>
		</xsl:for-each>-->
		<xsl:for-each select="//wfs:FeatureType[wfs:Name=$Name]/ows:Keywords">
			<descriptiveKeywords>
				<MD_Keywords>
					<xsl:apply-templates select="." mode="Keywords"/>
				</MD_Keywords>
			</descriptiveKeywords>
		</xsl:for-each>
		<xsl:for-each select="//wcs:CoverageOfferingBrief[wcs:name=$Name]/wcs:keywords">
			<descriptiveKeywords>
				<MD_Keywords>
					<xsl:apply-templates select="." mode="Keywords"/>
				</MD_Keywords>
			</descriptiveKeywords>
		</xsl:for-each>

		         <resourceConstraints>
            <MD_LegalConstraints>
               <accessConstraints>
                  <MD_RestrictionCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/gmxCodelists.xml#MD_RestrictionCode"
                                          codeListValue="otherRestrictions">otherRestrictions</MD_RestrictionCode>
               </accessConstraints>
               <otherConstraints>
                  <gmx:Anchor xlink:href="http://inspire.ec.europa.eu/metadata-codelist/LimitationsOnPublicAccess/INSPIRE_Directive_Article13_1e">no limitations</gmx:Anchor>
               </otherConstraints>
               <otherConstraints>
                  <gco:CharacterString/>
               </otherConstraints>
            </MD_LegalConstraints>
         </resourceConstraints>
         <resourceConstraints>
            <MD_LegalConstraints>
               <useConstraints>
                  <MD_RestrictionCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/gmxCodelists.xml#MD_RestrictionCode"
                                          codeListValue="otherRestrictions">otherRestrictions</MD_RestrictionCode>
               </useConstraints>
               <otherConstraints>
                  <gmx:Anchor>no conditions apply</gmx:Anchor>
               </otherConstraints>
            </MD_LegalConstraints>
         </resourceConstraints>


		<xsl:choose>
		 	<xsl:when test="//wfs:FeatureType">
				<spatialRepresentationType>
					<MD_SpatialRepresentationTypeCode codeList="./resources/codeList.xml#MD_SpatialRepresentationTypeCode" codeListValue="vector" />
				</spatialRepresentationType>
			</xsl:when>
			<xsl:when test="//wcs:CoverageOfferingBrief">
				<spatialRepresentationType>
					<MD_SpatialRepresentationTypeCode codeList="./resources/codeList.xml#MD_SpatialRepresentationTypeCode" codeListValue="grid" />
				</spatialRepresentationType>
			</xsl:when>
		</xsl:choose>

		<!-- TODO WCS -->
		<xsl:variable name="minScale" select="//Layer[Name=$Name]/MinScaleDenominator
		  |//wms:Layer[wms:Name=$Name]/wms:MinScaleDenominator"/>
	  <xsl:variable name="minScaleHint" select="//Layer[Name=$Name]/ScaleHint/@min"/>
		<xsl:if test="$minScale or $minScaleHint">
			<spatialResolution>
				<MD_Resolution>
					<equivalentScale>
						<MD_RepresentativeFraction>
							<denominator>
								<gco:Integer><xsl:value-of select="if ($minScale) then format-number($minScale,'0') else format-number(round($minScaleHint div math:sqrt(2) * 72 div 2.54 * 100), '0')"/></gco:Integer>
							</denominator>
						</MD_RepresentativeFraction>
					</equivalentScale>
				</MD_Resolution>
			</spatialResolution>
		</xsl:if>
		<xsl:variable name="maxScale" select="//Layer[Name=$Name]/MaxScaleDenominator
		  |//wms:Layer[wms:Name=$Name]/wms:MaxScaleDenominator"/>
	  <xsl:variable name="maxScaleHint" select="//Layer[Name=$Name]/ScaleHint/@max"/>
		<xsl:if test="$maxScale or $maxScaleHint">
			<spatialResolution>
				<MD_Resolution>
					<equivalentScale>
						<MD_RepresentativeFraction>
							<denominator>
								<gco:Integer>
									<xsl:value-of
										select="
											if ($maxScale)
											then
												format-number($maxScale, '0')
											else
												if ($maxScaleHint = 'Infinity')
												then
													$maxScaleHint
												else
													format-number(round($maxScaleHint div math:sqrt(2) * 72 div 2.54 * 100), '0')"
									/></gco:Integer>
							</denominator>
						</MD_RepresentativeFraction>
					</equivalentScale>
				</MD_Resolution>
			</spatialResolution>
		</xsl:if>
		<xsl:call-template name="language">
			<xsl:with-param name="lang" select="$lang"/>
		</xsl:call-template>


		<characterSet>
			<MD_CharacterSetCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_CharacterSetCode" codeListValue=""/>
		</characterSet>
		<!--
		<topicCategory>
			<MD_TopicCategoryCode><xsl:value-of select="$topic"/></MD_TopicCategoryCode>
		</topicCategory> -->
		<topicCategory>
			<MD_TopicCategoryCode>location</MD_TopicCategoryCode>
		</topicCategory>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		<extent>
				<EX_Extent>
					<geographicElement>
						<EX_GeographicBoundingBox>
							<xsl:choose>
								<xsl:when test="$ows='true' or name(.)='WCS_Capabilities'">
									<xsl:variable name="boxes">
										<xsl:choose>
											<xsl:when test="$ows='true'">
												<xsl:for-each select="//wfs:FeatureType[wfs:Name=$Name]/ows:WGS84BoundingBox/ows:LowerCorner">
													<xmin><xsl:value-of	select="substring-before(., ' ')"/></xmin>
													<ymin><xsl:value-of	select="substring-after(., ' ')"/></ymin>
												</xsl:for-each>
												<xsl:for-each select="//wfs:FeatureType[wfs:Name=$Name]/ows:WGS84BoundingBox/ows:UpperCorner">
													<xmax><xsl:value-of	select="substring-before(., ' ')"/></xmax>
													<ymax><xsl:value-of	select="substring-after(., ' ')"/></ymax>
												</xsl:for-each>
											</xsl:when>
											<xsl:when test="name(.)='WCS_Capabilities'">
												<xsl:for-each select="//wcs:CoverageOfferingBrief[wcs:name=$Name]/wcs:lonLatEnvelope/gml:pos[1]">
													<xmin><xsl:value-of	select="substring-before(., ' ')"/></xmin>
													<ymin><xsl:value-of	select="substring-after(., ' ')"/></ymin>
												</xsl:for-each>
												<xsl:for-each select="//wcs:CoverageOfferingBrief[wcs:name=$Name]/wcs:lonLatEnvelope/gml:pos[2]">
													<xmax><xsl:value-of	select="substring-before(., ' ')"/></xmax>
													<ymax><xsl:value-of	select="substring-after(., ' ')"/></ymax>
												</xsl:for-each>
											</xsl:when>
										</xsl:choose>
									</xsl:variable>

									<westBoundLongitude>
										<gco:Decimal><xsl:value-of select="exslt:node-set($boxes)/*[name(.)='xmin']"/></gco:Decimal>
									</westBoundLongitude>
									<eastBoundLongitude>
										<gco:Decimal><xsl:value-of select="exslt:node-set($boxes)/*[name(.)='xmax']"/></gco:Decimal>
									</eastBoundLongitude>
									<southBoundLatitude>
										<gco:Decimal><xsl:value-of select="exslt:node-set($boxes)/*[name(.)='ymin']"/></gco:Decimal>
									</southBoundLatitude>
									<northBoundLatitude>
										<gco:Decimal><xsl:value-of select="exslt:node-set($boxes)/*[name(.)='ymax']"/></gco:Decimal>
									</northBoundLatitude>
								</xsl:when>
								<xsl:when test="name(.)='WFS_Capabilities'">
									<westBoundLongitude>
										<gco:Decimal><xsl:value-of select="//wfs:FeatureType[wfs:Name=$Name]/wfs:LatLongBoundingBox/@minx"/></gco:Decimal>
									</westBoundLongitude>
									<eastBoundLongitude>
										<gco:Decimal><xsl:value-of select="//wfs:FeatureType[wfs:Name=$Name]/wfs:LatLongBoundingBox/@maxx"/></gco:Decimal>
									</eastBoundLongitude>
									<southBoundLatitude>
										<gco:Decimal><xsl:value-of select="//wfs:FeatureType[wfs:Name=$Name]/wfs:LatLongBoundingBox/@miny"/></gco:Decimal>
									</southBoundLatitude>
									<northBoundLatitude>
										<gco:Decimal><xsl:value-of select="//wfs:FeatureType[wfs:Name=$Name]/wfs:LatLongBoundingBox/@maxy"/></gco:Decimal>
									</northBoundLatitude>
								</xsl:when>
								<xsl:otherwise>
									<westBoundLongitude>
										<gco:Decimal><xsl:value-of select="//Layer[Name=$Name]/LatLonBoundingBox/@minx|
											//wms:Layer[wms:Name=$Name]/wms:EX_GeographicBoundingBox/wms:westBoundLongitude"/></gco:Decimal>
									</westBoundLongitude>
									<eastBoundLongitude>
										<gco:Decimal><xsl:value-of select="//Layer[Name=$Name]/LatLonBoundingBox/@maxx|
											//wms:Layer[wms:Name=$Name]/wms:EX_GeographicBoundingBox/wms:eastBoundLongitude"/></gco:Decimal>
									</eastBoundLongitude>
									<southBoundLatitude>
										<gco:Decimal><xsl:value-of select="//Layer[Name=$Name]/LatLonBoundingBox/@miny|
											//wms:Layer[wms:Name=$Name]/wms:EX_GeographicBoundingBox/wms:southBoundLatitude"/></gco:Decimal>
									</southBoundLatitude>
									<northBoundLatitude>
										<gco:Decimal><xsl:value-of select="//Layer[Name=$Name]/LatLonBoundingBox/@maxy|
											//wms:Layer[wms:Name=$Name]/wms:EX_GeographicBoundingBox/wms:northBoundLatitude"/></gco:Decimal>
									</northBoundLatitude>
								</xsl:otherwise>
							</xsl:choose>
						</EX_GeographicBoundingBox>
					</geographicElement>
				</EX_Extent>
		</extent>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
			TODO : could be added to the GUI ?
		<xsl:for-each select="tpCat">
			<topicCategory>
				<MD_TopicCategoryCode codeList="./resources/codeList.xml#MD_TopicCategoryCode" codeListValue="{TopicCatCd/@value}" />
			</topicCategory>
		</xsl:for-each>

		  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Keywords === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Keywords">
		<!-- TODO : tokenize WFS 100 keywords list -->
		<xsl:for-each select="Keyword|wms:Keyword|ows:Keyword|ows11:Keyword|wfs:Keyword|wcs:keyword">
			<keyword>
				<gco:CharacterString><xsl:value-of select="normalize-space(.)"/></gco:CharacterString>
			</keyword>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
