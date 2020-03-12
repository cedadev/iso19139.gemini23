<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
                xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
                xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="#all">

  <!-- Readonly elements -->
  <!-- Uncomment to make gmd:metadataStandardName and gmd:metadataStandardVersion readonly -->
<xsl:template mode="mode-iso19139" priority="5000" match="gmd:metadataStandardName[$schema='iso19139.gemini23']|gmd:metadataStandardVersion[$schema='iso19139.gemini23']">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="overrideLabel" select="''" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
    <xsl:variable name="fieldLabelConfig"
                  select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)"/>

    <xsl:variable name="labelConfig">
      <xsl:choose>
        <xsl:when test="$overrideLabel != ''">
          <element>
            <label><xsl:value-of select="$overrideLabel"/></label>
          </element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$fieldLabelConfig"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>


    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)" />

    <xsl:call-template name="render-element">
      <xsl:with-param name="label"
                      select="$labelConfig/*"/>
      <xsl:with-param name="value" select="*"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="type" select="gn-fn-metadata:getFieldType($editorConfig, name(), '', $xpath)"/>
      <xsl:with-param name="name" select="''"/>
      <xsl:with-param name="editInfo" select="*/gn:element"/>
      <xsl:with-param name="parentEditInfo" select="gn:element"/>
      <xsl:with-param name="isDisabled" select="true()"/>
    </xsl:call-template>

  </xsl:template>

  <!-- Restrict to gemini 2.3 codelists (same template in iso19139 uses explicitly the codelists from iso19139,
       doesn't use the current schema codelists, so has to be overriden with higher priority than same template in iso19139 (priority=200).
       Be careful with priority to not be higher than the template for gmd:dateType (4000) or will cause side effects. -->

  <xsl:template mode="mode-iso19139" priority="500" match="*[*/@codeList and $schema='iso19139.gemini23']">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="codelists" select="$codelists" required="no"/>
    <xsl:param name="overrideLabel" select="''" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
    <xsl:variable name="elementName" select="name()"/>
    <xsl:variable name="labelConfig">
      <xsl:choose>
        <xsl:when test="$overrideLabel != ''">
          <element>
            <label><xsl:value-of select="$overrideLabel"/></label>
          </element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), '', $xpath)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="render-element">
      <xsl:with-param name="label" select="$labelConfig/*"/>
      <xsl:with-param name="value" select="*/@codeListValue"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="type" select="gn-fn-iso19139:getCodeListType(name())"/>
      <xsl:with-param name="name"
                      select="if ($isEditing) then concat(*/gn:element/@ref, '_codeListValue') else ''"/>
      <xsl:with-param name="editInfo" select="*/gn:element"/>
      <xsl:with-param name="parentEditInfo" select="gn:element"/>
      <xsl:with-param name="listOfValues"
                      select="gn-fn-metadata:getCodeListValues($schema, name(*[@codeListValue]), $codelists, .)"/>
      <xsl:with-param name="isFirst"
                      select="count(preceding-sibling::*[name() = $elementName]) = 0"/>
    </xsl:call-template>

  </xsl:template>

   <!-- otherConstraints with gmx:Anchor -->
  <xsl:template mode="mode-iso19139" priority="200" match="gmd:otherConstraints[$schema='iso19139.gemini23' and gmx:Anchor]">
    <xsl:variable name="name" select="name(.)"/>

    <xsl:variable name="labelConfig" select="gn-fn-metadata:getLabel($schema, $name, $labels)"/>
    <xsl:variable name="helper" select="gn-fn-metadata:getHelper($labelConfig/helper, .)"/>


    <xsl:variable name="attributes">
      <!-- Create form for all existing attribute (not in gn namespace)
      and all non existing attributes not already present. -->
      <xsl:apply-templates mode="render-for-field-for-attribute"
                           select="gmx:Anchor/@*|gmx:Anchor/gn:attribute[not(@name = parent::node()/@*/name())]">
        <xsl:with-param name="ref" select="gmx:Anchor/gn:element/@ref"/>
        <xsl:with-param name="insertRef" select="gmx:Anchor/gn:element/@ref"/>
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:call-template name="render-element">
      <xsl:with-param name="label" select="$labelConfig/label"/>
      <xsl:with-param name="value" select="gmx:Anchor" />
      <xsl:with-param name="name" select="gmx:Anchor/gn:element/@ref" />
      <xsl:with-param name="cls" select="local-name()" />
      <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
      <xsl:with-param name="editInfo" select="gmx:Anchor/gn:element" />
      <xsl:with-param name="isDisabled" select="false()" />
      <xsl:with-param name="attributesSnippet" select="$attributes" />
      <xsl:with-param name="forceDisplayAttributes" select="true()" />
    </xsl:call-template>
  </xsl:template>


  <!-- ===================================================================== -->
  <!-- gml:TimePeriod (format = %Y-%m-%dThh:mm:ss) -->
  <!-- ===================================================================== -->

  <!-- This template is required as iso19139 uses gml (http://www.opengis.net/gml/3.2) and
       GEMINI 2.3 uses gml 3.2 (http://www.opengis.net/gml/3.2).

       Any template to handle gml elements that is defined in iso19139 should be redefined in the GEMINI schema to use
       the correct namespace url.
  -->
  <xsl:template mode="mode-iso19139" match="gml:beginPosition[$schema='iso19139.gemini23']|gml:endPosition[$schema='iso19139.gemini23']|gml:timePosition[$schema='iso19139.gemini23']"
                priority="5000">

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="value" select="normalize-space(text())"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
    <xsl:variable name="labelConfig" select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)"/>


    <xsl:variable name="attributes">
      <xsl:if test="$isEditing">
        <!-- Create form for all existing attribute (not in gn namespace)
        and all non existing attributes not already present. -->
        <xsl:apply-templates mode="render-for-field-for-attribute"
                             select="             @*|           gn:attribute[not(@name = parent::node()/@*/name())]">
          <xsl:with-param name="ref" select="gn:element/@ref"/>
          <xsl:with-param name="insertRef" select="gn:element/@ref"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:variable>


    <xsl:call-template name="render-element">
      <xsl:with-param name="label"
                      select="$labelConfig"/>
      <xsl:with-param name="name" select="gn:element/@ref"/>
      <xsl:with-param name="value" select="text()"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <!--
          Default field type is Date.

          TODO : Add the capability to edit those elements as:
           * xs:time
           * xs:dateTime
           * xs:anyURI
           * xs:decimal
           * gml:CalDate
          See http://trac.osgeo.org/geonetwork/ticket/661
        -->
      <xsl:with-param name="type"
                      select="if (string-length($value) = 10 or $value = '') then 'date' else 'datetime'"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="attributesSnippet" select="$attributes"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Duration

      xsd:duration elements use the following format:

      Format: PnYnMnDTnHnMnS

      *  P indicates the period (required)
      * nY indicates the number of years
      * nM indicates the number of months
      * nD indicates the number of days
      * T indicates the start of a time section (required if you are going to specify hours, minutes, or seconds)
      * nH indicates the number of hours
      * nM indicates the number of minutes
      * nS indicates the number of seconds

      A custom directive is created.
 -->
  <xsl:template mode="mode-iso19139" match="gml:duration[$schema='iso19139.gemini23']" priority="200">

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
    <xsl:variable name="labelConfig" select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)"/>

    <xsl:call-template name="render-element">
      <xsl:with-param name="label"
                      select="$labelConfig"/>
      <xsl:with-param name="value" select="."/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="type" select="'data-gn-field-duration-div'"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="parentEditInfo" select="../gn:element"/>
    </xsl:call-template>

  </xsl:template>


  <!-- Topic categories boxed -->
  <xsl:template mode="mode-iso19139"
                match="gmd:topicCategory[position() =1 and $schema='iso19139.gemini23']"
                priority="2200">

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
    <xsl:variable name="labelConfig" select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)"/>

    <xsl:variable name="elementName" select="name()" />

    <xsl:variable name="topicCategories">
      <xsl:for-each select="../*[name() = $elementName]">
        <xsl:value-of select="gmd:MD_TopicCategoryCode/text()" />
        <xsl:if test="position() != last()">,</xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="errors">
      <xsl:if test="$showValidationErrors">
        <xsl:call-template name="get-errors"/>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="label" select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)"/>

    <xsl:call-template name="render-boxed-element">
      <xsl:with-param name="label" select="$label/label"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="errors" select="$errors"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="subTreeSnippet">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label"
                          select="$labelConfig"/>
          <xsl:with-param name="value" select="$topicCategories"/>
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="xpath" select="$xpath"/>
          <xsl:with-param name="type" select="'data-gn-topiccategory-selector-div'"/>
          <xsl:with-param name="editInfo" select="gn:element"/>
          <xsl:with-param name="parentEditInfo" select="../gn:element"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>


  </xsl:template>


  <!-- Service type boxed -->
  <xsl:template mode="mode-iso19139"
                match="srv:serviceType[$schema='iso19139.gemini23']"
                priority="2200">

    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="overrideLabel" select="''" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>

    <xsl:variable name="labelConfig" select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)"/>

    <xsl:variable name="helper" select="gn-fn-metadata:getHelper($labelConfig/helper, .)"/>

    <xsl:variable name="labelConfig">
      <xsl:choose>
        <xsl:when test="$overrideLabel != ''">
          <element>
            <label><xsl:value-of select="$overrideLabel"/></label>
          </element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$labelConfig"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="errors">
      <xsl:if test="$showValidationErrors">
        <xsl:call-template name="get-errors"/>
      </xsl:if>
    </xsl:variable>

    <xsl:call-template name="render-boxed-element">
      <xsl:with-param name="label" select="$labelConfig/*[1]/label"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="errors" select="$errors"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="subTreeSnippet">
        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="$labelConfig/*[1]"/>
          <xsl:with-param name="value"
                          select="gco:LocalName"/>
          <xsl:with-param name="listOfValues" select="$helper"/>
          <xsl:with-param name="name" select="if ($isEditing) then gco:LocalName/gn:element/@ref else ''"/>
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="xpath" select="$xpath"/>
          <xsl:with-param name="editInfo" select="gco:LocalName/gn:element"/>
          <xsl:with-param name="parentEditInfo" select="gn:element"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- spatial representation type boxed -->
  <xsl:template mode="mode-iso19139"
                match="gmd:spatialRepresentationType[$schema='iso19139.gemini23']"
                priority="2200">

    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="overrideLabel" select="''" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
    <xsl:variable name="elementName" select="name()"/>

    <xsl:variable name="labelConfig" select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)"/>

    <xsl:variable name="labelConfig">
      <xsl:choose>
        <xsl:when test="$overrideLabel != ''">
          <element>
            <label><xsl:value-of select="$overrideLabel"/></label>
          </element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$labelConfig"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="errors">
      <xsl:if test="$showValidationErrors">
        <xsl:call-template name="get-errors"/>
      </xsl:if>
    </xsl:variable>

    <xsl:call-template name="render-boxed-element">
      <xsl:with-param name="label" select="$labelConfig/*[1]/label"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="errors" select="$errors"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="subTreeSnippet">

        <xsl:call-template name="render-element">
          <xsl:with-param name="label" select="$labelConfig/*"/>
          <xsl:with-param name="value" select="*/@codeListValue"/>
          <xsl:with-param name="cls" select="local-name()"/>
          <xsl:with-param name="xpath" select="$xpath"/>
          <xsl:with-param name="type" select="gn-fn-iso19139:getCodeListType(name())"/>
          <xsl:with-param name="name"
                          select="if ($isEditing) then concat(*/gn:element/@ref, '_codeListValue') else ''"/>
          <xsl:with-param name="editInfo" select="*/gn:element"/>
          <xsl:with-param name="parentEditInfo" select="gn:element"/>
          <xsl:with-param name="listOfValues"
                          select="gn-fn-metadata:getCodeListValues($schema, name(*[@codeListValue]), $codelists, .)"/>
          <xsl:with-param name="isFirst"
                          select="count(preceding-sibling::*[name() = $elementName]) = 0"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


 <xsl:template mode="mode-iso19139"
               match="gmd:verticalCRS[(count(gml:*) = 0) and $schema='iso19139.gemini23']"
               priority="2200">

   <xsl:param name="schema" select="$schema" required="no"/>
   <xsl:param name="labels" select="$labels" required="no"/>
   <xsl:param name="overrideLabel" select="''" required="no"/>

   <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
   <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
   <xsl:variable name="labelConfig" select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)"/>
   <xsl:variable name="helper" select="gn-fn-metadata:getHelper($labelConfig/helper, .)"/>
   <xsl:call-template name="render-element">
     <xsl:with-param name="label" select="$labelConfig"/>
     <xsl:with-param name="value"
                     select="@xlink:href"/>
     <xsl:with-param name="name"
                     select="if ($isEditing) then concat(gn:element/@ref, '_xlinkCOLONhref') else ''"/>
     <xsl:with-param name="cls" select="local-name()"/>
     <xsl:with-param name="editInfo" select="gn:element"/>
     <xsl:with-param name="isDisabled" select="false()"/>
     <xsl:with-param name="listOfValues" select="$helper"/>

   </xsl:call-template>


 </xsl:template>
</xsl:stylesheet>
