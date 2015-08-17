<?xml version="1.0"?>
 <!--
   Process RangeMessage.xml (download at https://www.isbn-international.org/range_file_generation )
   into a line-based text format suitable for loading and processing by isbnutils.flx 
   (as application of psdatasets.flx)
  -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

 <xsl:output method="text" encoding="utf-8" />

 <xsl:variable name="dataURL" select="'https://www.isbn-international.org/range_file_generation'" />

 <xsl:template match="/">
  <xsl:apply-templates />
 </xsl:template>

 <xsl:template match="/">
  <xsl:apply-templates select="ISBNRangeMessage" />
 </xsl:template>

 <xsl:template match="ISBNRangeMessage">
  <xsl:value-of select="concat(' // MessageSource: ', MessageSource, '&#xA;')"/>
  <xsl:value-of select="concat(' // MessageSerialNumber: ', MessageSerialNumber, '&#xA;')"/>
  <xsl:value-of select="concat(' // MessageDate: ', MessageDate, '&#xA;')"/>
  <xsl:value-of select="concat(' // URL: ', $dataURL, '&#xA;')"/>

  <xsl:value-of select="concat('&#xA;', '### Metadata', '&#xA;')" />

<!-- use '=' instead of ' ' since '=' occurs in data payload -->
  <xsl:value-of select="concat('_Encoding', '=', 'UTF-8 (Ae/Oe/Ue =&gt; Ä/Ö/Ü)', '&#xA;')" />
  <xsl:value-of select="concat('_Namespace', ' ', $dataURL, '#', '&#xA;')" />
  <xsl:value-of select="concat('_Revision', ' ', MessageSerialNumber, '&#xA;')" />
  <!-- xsl:value-of select="concat('_Date', ' ', MessageDate, '&#xA;')" / -->
  <!-- xsl:value-of select="concat('_RefreshURI', ' ', MessageDate, '&#xA;')" / -->

  <xsl:apply-templates select="RegistrationGroups/Group" />

  <xsl:value-of select="concat('&#xA;', '### Finis', '&#xA;')" />
 </xsl:template>

 <xsl:template match="Group">
  <xsl:value-of select="concat('&#xA;', '### Prefix: ', Prefix, ' (', Agency, ')', '&#xA;')" />
  <xsl:value-of select="concat(translate(Prefix, '-',''), '=&gt;', Prefix, '-(', string-length(Prefix)-4, ')', '&#xA;')" />
  <xsl:apply-templates select="Rules/Rule">
   <xsl:with-param name="prefix" select="./Prefix" />
  </xsl:apply-templates>
 </xsl:template>

 <xsl:template match="Rule">
  <xsl:param name="prefix" select="'???'" />
  <xsl:param name="length" select="Length" />
  <xsl:choose>
   <xsl:when test="$length='0'">
    <xsl:value-of select="concat($prefix, '-', substring-before(Range, '-'), '-', '=', Range, '(range not defined for use)&#xA;')" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:variable name="pfirst" select="substring(Range, 1, $length)" />
    <xsl:variable name="rfirst" select="substring(substring-before(Range, '-'), 1+$length)" />
    <xsl:value-of select="concat($prefix, '-', $pfirst, '-', $rfirst, '=', Range, '(', Length, ')&#xA;')" />
<!--
    <xsl:variable name="plast" select="substring(substring-after(Range, '-'), 1, $length)" />
    <xsl:variable name="rlast" select="substring(substring-after(Range, '-'), 1+$length)" />
    <xsl:value-of select="concat($prefix, '-', $plast, '-', $rlast, '=]', Range, '(', Length, ')&#xA;')" />
-->
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

</xsl:stylesheet>

