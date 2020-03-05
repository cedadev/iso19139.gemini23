<?xml version="1.0" encoding="UTF-8"?>

<!--
  ~ Copyright (C) 2001-2016 Food and Agriculture Organization of the
  ~ United Nations (FAO-UN), United Nations World Food Programme (WFP)
  ~ and United Nations Environment Programme (UNEP)
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or (at
  ~ your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful, but
  ~ WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
  ~
  ~ Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
  ~ Rome - Italy. email: geonetwork@osgeo.org
  -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                version="2.0">


  <xsl:template match="/root">
    <xsl:apply-templates select="gmd:*"/>
  </xsl:template>

  <!-- datasets -->

  <xsl:template match="gmd:MD_DataIdentification">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <xsl:copy-of select="gmd:citation" />
      <xsl:copy-of select="gmd:abstract" />
      <xsl:copy-of select="gmd:purpose" />
      <xsl:copy-of select="gmd:credit" />
      <xsl:copy-of select="gmd:status" />
      <xsl:copy-of select="gmd:pointOfContact" />
      <xsl:copy-of select="gmd:resourceMaintenance" />
      <xsl:copy-of select="gmd:graphicOverview" />
      <xsl:copy-of select="gmd:resourceFormat" />
      <xsl:copy-of select="gmd:descriptiveKeywords" />
      <xsl:copy-of select="gmd:resourceSpecificUsage" />
      <xsl:copy-of select="gmd:resourceConstraints" />
      <xsl:copy-of select="gmd:aggregationInfo" />
      <xsl:copy-of select="gmd:spatialRepresentationType" />
      <!-- Add spatialrepresentationtype if missing -->
      <xsl:if test="not(gmd:spatialRepresentationType)">
        <gmd:spatialRepresentationType>
            <gmd:MD_SpatialRepresentationTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/gmxCodelists.xml#MD_SpatialRepresentationTypeCode"
                                                  codeListValue="vector"/>
         </gmd:spatialRepresentationType>
       </xsl:if>
      <xsl:copy-of select="gmd:spatialResolution" />
      <xsl:copy-of select="gmd:language" />
      <xsl:copy-of select="gmd:characterSet" />
      <!-- Add characterSet if missing -->
      <xsl:if test="not(gmd:characterSet)">
        <gmd:characterSet>
          <gmd:MD_CharacterSetCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/gmxCodelists.xml#MD_CharacterSetCode"
                                     codeListValue="utf8">UTF-8</gmd:MD_CharacterSetCode>
        </gmd:characterSet>
      </xsl:if>
      <xsl:copy-of select="gmd:topicCategory" />
      <!-- Add gmd:topicCategory if missing -->
      <xsl:if test="not(gmd:topicCategory)">
        <gmd:topicCategory>
          <gmd:MD_TopicCategoryCode></gmd:MD_TopicCategoryCode>
        </gmd:topicCategory>
      </xsl:if>
      <xsl:copy-of select="gmd:environmentDescription" />

<xsl:variable name="hasTimePeriodElement" select="count(gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition) > 0" />
      <xsl:variable name="hasTimeInstantElement" select="count(gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant) > 0" />
      <xsl:variable name="hasBboxElement" select="count(gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox) > 0" />
      <xsl:variable name="hasVerticalCRSElement" select="count(gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:verticalCRS) > 0" />
      <xsl:variable name="hasVerticalExtentMin" select="count(gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:minimumValue) > 0" />
      <xsl:variable name="hasVerticalExtentMax" select="count(gmd:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:maximumValue) > 0" />

      <xsl:choose>
        <xsl:when test="not(gmd:extent)">
          <!-- No extent element: create it with bbox and temporal extent -->
          <gmd:extent>
            <gmd:EX_Extent>
              <xsl:call-template name="addBboxElement" />
              <xsl:call-template name="addTimePeriodElement" />
            </gmd:EX_Extent>
          </gmd:extent>
        </xsl:when>

       <xsl:when test="(not($hasTimePeriodElement) and not($hasTimeInstantElement)) or not($hasBboxElement) or not($hasVerticalCRSElement)">
          <!-- Add  temporal extent or bbox elements (if missing) to the first gmd:extent -->
          <xsl:for-each select="gmd:extent">
            <xsl:copy>
              <xsl:copy-of select="@*" />

              <xsl:choose>
                <xsl:when test="position() = 1">
                  <xsl:for-each select="gmd:EX_Extent">
                    <xsl:copy>
                      <xsl:copy-of select="@*" />

                      <xsl:apply-templates select="gmd:description" />

                      <xsl:choose>
                        <xsl:when test="not($hasBboxElement)">
                          <xsl:call-template name="addBboxElement" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates select="gmd:geographicElement" />
                        </xsl:otherwise>
                      </xsl:choose>

                      <xsl:choose>
                        <xsl:when test="not($hasTimePeriodElement) and not($hasTimeInstantElement)">
                          <xsl:call-template name="addTimePeriodElement" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates select="gmd:temporalElement" />
                        </xsl:otherwise>
                      </xsl:choose>


                      <xsl:choose>
                        <!-- add vertical CRS if it's missing-->
                        <!-- but only if vertical min and max are present -->
                        <xsl:when test="($hasVerticalExtentMin and $hasVerticalExtentMax) and not($hasVerticalCRSElement)">
                          <xsl:for-each select="gmd:verticalElement">
                            <xsl:copy>
                              <xsl:copy-of select="@*" />

                              <xsl:choose>
                                <xsl:when test="position() = 1">
                                  <xsl:for-each select="gmd:EX_VerticalExtent">
                                    <xsl:copy>
                                      <xsl:copy-of select="@*" />

                                      <xsl:apply-templates select="gmd:minimumValue" />
                                      <xsl:apply-templates select="gmd:maximumValue" />
                                      <xsl:message>Got vertical extent but no CRS</xsl:message>
                                      <xsl:call-template name="addVerticalCRSElement" />
                                    </xsl:copy>
                                  </xsl:for-each>
                                </xsl:when>

                                <xsl:otherwise>
                                  <xsl:apply-templates select="*"/>
                                </xsl:otherwise>
                              </xsl:choose>

                            </xsl:copy>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates select="gmd:verticalElement" />
                        </xsl:otherwise>
                      </xsl:choose>


                    </xsl:copy>

                  </xsl:for-each>
                </xsl:when>





                <xsl:otherwise>
                  <xsl:apply-templates select="*"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:copy>
          </xsl:for-each>
        </xsl:when>


        <xsl:otherwise>
          <xsl:copy-of select="gmd:extent" />
        </xsl:otherwise>
      </xsl:choose>

      <xsl:copy-of select="gmd:supplementalInformation" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gmd:MD_Distribution">
    <xsl:copy>
      <xsl:copy-of select="@*" />

      <xsl:apply-templates select="gmd:distributionFormat" />

      <xsl:if test="not(gmd:distributionFormat)" >
        <gmd:distributionFormat>
            <gmd:MD_Format>
               <gmd:name>
                  <gco:CharacterString xmlns:gco="http://www.isotc211.org/2005/gco"></gco:CharacterString>
               </gmd:name>
               <gmd:version>
                  <gco:CharacterString xmlns:gco="http://www.isotc211.org/2005/gco"></gco:CharacterString>
               </gmd:version>
            </gmd:MD_Format>
         </gmd:distributionFormat>
      </xsl:if>
      <xsl:copy-of select="gmd:transferOptions" />

    </xsl:copy>

  </xsl:template>

  <!-- servicees -->

    <xsl:template match="srv:SV_ServiceIdentification">
      <xsl:copy>
        <xsl:copy-of select="@*" />

        <xsl:copy-of select="gmd:citation" />
        <xsl:copy-of select="gmd:abstract" />
        <xsl:copy-of select="gmd:purpose" />
        <xsl:copy-of select="gmd:credit" />
        <xsl:copy-of select="gmd:status" />
        <xsl:copy-of select="gmd:pointOfContact" />
        <xsl:copy-of select="gmd:resourceMaintenance" />
        <xsl:copy-of select="gmd:graphicOverview" />
        <xsl:copy-of select="gmd:resourceFormat" />
        <xsl:copy-of select="gmd:descriptiveKeywords" />
        <xsl:copy-of select="gmd:resourceSpecificUsage" />
        <xsl:copy-of select="gmd:resourceConstraints" />
        <xsl:copy-of select="srv:serviceType" />
        <!-- Add srv:serviceType if missing -->
        <xsl:if test="not(srv:serviceType)">
          <srv:serviceType>
            <gco:LocalName xmlns:gco="http://www.isotc211.org/2005/gco" codeSpace="INSPIRE"></gco:LocalName>
         </srv:serviceType>
         </xsl:if>
        <!-- add extents of all kinds if missing -->
        <!-- temporal extent is optional for service so don't need to include it -->
      <xsl:variable name="hasBboxElementSrv" select="count(srv:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox) > 0" />
      <xsl:variable name="hasVerticalCRSElementSrv" select="count(srv:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:verticalCRS) > 0" />
      <xsl:variable name="hasVerticalExtentMinSrv" select="count(srv:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:minimumValue) > 0" />
      <xsl:variable name="hasVerticalExtentMaxSrv" select="count(srv:extent/gmd:EX_Extent/gmd:verticalElement/gmd:EX_VerticalExtent/gmd:maximumValue) > 0" />

      <xsl:choose>
        <xsl:when test="not(srv:extent)">
          <!-- No extent element: create it with bbox  -->
          <gmd:extent>
            <gmd:EX_Extent>
              <xsl:call-template name="addBboxElement" />
            </gmd:EX_Extent>
          </gmd:extent>
        </xsl:when>

       <xsl:when test="(not($hasBboxElementSrv) or not($hasVerticalCRSElementSrv))">
          <!-- Add  bbox elements (if missing) to the first gmd:extent -->
          <xsl:for-each select="srv:extent">
            <xsl:copy>
              <xsl:copy-of select="@*" />

              <xsl:choose>
                <xsl:when test="position() = 1">
                  <xsl:for-each select="gmd:EX_Extent">
                    <xsl:copy>
                      <xsl:copy-of select="@*" />

                      <xsl:apply-templates select="gmd:description" />

                      <xsl:choose>
                        <xsl:when test="not($hasBboxElementSrv)">
                          <xsl:call-template name="addBboxElement" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates select="gmd:geographicElement" />
                        </xsl:otherwise>
                      </xsl:choose>


                      <xsl:choose>
                        <!-- add vertical CRS if it's missing-->
                        <!-- but only if vertical min and max are present -->
                        <xsl:when test="($hasVerticalExtentMinSrv and $hasVerticalExtentMaxSrv) and not($hasVerticalCRSElementSrv)">
                          <xsl:for-each select="gmd:verticalElement">
                            <xsl:copy>
                              <xsl:copy-of select="@*" />

                              <xsl:choose>
                                <xsl:when test="position() = 1">
                                  <xsl:for-each select="gmd:EX_VerticalExtent">
                                    <xsl:copy>
                                      <xsl:copy-of select="@*" />

                                      <xsl:apply-templates select="gmd:minimumValue" />
                                      <xsl:apply-templates select="gmd:maximumValue" />
                                      <xsl:message>Got vertical extent but no CRS</xsl:message>
                                      <xsl:call-template name="addVerticalCRSElement" />
                                    </xsl:copy>
                                  </xsl:for-each>
                                </xsl:when>

                                <xsl:otherwise>
                                  <xsl:apply-templates select="*"/>
                                </xsl:otherwise>
                              </xsl:choose>

                            </xsl:copy>
                          </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:apply-templates select="gmd:verticalElement" />
                        </xsl:otherwise>
                      </xsl:choose>


                    </xsl:copy>

                  </xsl:for-each>
                </xsl:when>

                <xsl:otherwise>
                  <xsl:apply-templates select="*"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:copy>
          </xsl:for-each>
        </xsl:when>


        <xsl:otherwise>
          <xsl:copy-of select="srv:extent" />
        </xsl:otherwise>
      </xsl:choose>
        <xsl:copy-of select="srv:couplingType"/>
        <xsl:copy-of select="srv:containsOperations"/>
        <xsl:copy-of select="srv:operatesOn"/>
        <!-- Add srv:operatesOn if missing -->
        <xsl:if test="not(srv:operatesOn)">
          <srv:operatesOn></srv:operatesOn>
         </xsl:if>
      </xsl:copy>
    </xsl:template>

<!-- elements to add -->

  <xsl:template name="addBboxElement">
    <gmd:geographicElement>
      <gmd:EX_GeographicBoundingBox>
        <gmd:westBoundLongitude>
          <gco:Decimal>-8.45</gco:Decimal>
        </gmd:westBoundLongitude>
        <gmd:eastBoundLongitude>
          <gco:Decimal>1.78</gco:Decimal>
        </gmd:eastBoundLongitude>
        <gmd:southBoundLatitude>
          <gco:Decimal>49.86</gco:Decimal>
        </gmd:southBoundLatitude>
        <gmd:northBoundLatitude>
          <gco:Decimal>60.86</gco:Decimal>
        </gmd:northBoundLatitude>
      </gmd:EX_GeographicBoundingBox>
    </gmd:geographicElement>
  </xsl:template>

  <xsl:template name="addTimePeriodElement">
    <gmd:temporalElement>
      <gmd:EX_TemporalExtent>
        <gmd:extent>
          <gml:TimePeriod gml:id="{generate-id()}">
            <gml:beginPosition/>
            <gml:endPosition/>
          </gml:TimePeriod>
        </gmd:extent>
      </gmd:EX_TemporalExtent>
    </gmd:temporalElement>
  </xsl:template>

   <xsl:template name="addVerticalCRSElement">
    <gmd:verticalElement>
       <gmd:EX_VerticalExtent>
         <gmd:verticalCRS xlink:href='http://www.opengis.net/def/crs/EPSG/0/5701'/>
       </gmd:EX_VerticalExtent>
     </gmd:verticalElement>
  </xsl:template>

  <!-- Add gco:Boolean to gmd:pass with nilReason to work nicely in the editor,
    update-fixed-info.xsl should removed if empty to avoid xsd errors  -->
  <xsl:template match="gmd:pass[@gco:nilReason and not(gco:Boolean)]" priority="20">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <gco:Boolean>false</gco:Boolean>
    </xsl:copy>
  </xsl:template>

    <!-- Add gco:CharacterString child nodes to elements with gco:nilReason attributes so they display
    in the editor, then use update-fixed-info.xsl to get rid of them if not required, keep also gco:nilReason attribute -->
    <xsl:template match="//*[(@gco:nilReason='inapplicable' or @gco:nilReason='unknown') and not(gco:CharacterString) and name() != 'gmd:verticalElement' and name() != 'gmd:hierarchyLevelName']" priority="10">
      <xsl:copy>
        <xsl:apply-templates select="@*|*"/>
        <xsl:element name="gco:CharacterString"/>
      </xsl:copy>
    </xsl:template>

  <!-- copy everything else -->

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
