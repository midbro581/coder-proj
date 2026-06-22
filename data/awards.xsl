<?xml version="1.0" encoding="UTF-8"?>
<!--
  CODER — awards.xsl
  XSLT Stylesheet: transforms awards.xml into an HTML table
  Applied via JavaScript XSLTProcessor on the about.html page
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Output as HTML -->
  <xsl:output method="html" indent="yes"/>

  <!-- Root template -->
  <xsl:template match="/awards">
    <div class="awards-xslt-container">
      <table class="awards-table">
        <thead>
          <tr>
            <th>Award</th>
            <th>Organisation</th>
            <th>Year</th>
            <th>Description</th>
          </tr>
        </thead>
        <tbody>
          <!-- Loop over every <award> element -->
          <xsl:for-each select="award">
            <xsl:sort select="year" order="descending" data-type="number"/>
            <tr>
              <td><xsl:value-of select="title"/></td>
              <td><xsl:value-of select="organization"/></td>
              <td><xsl:value-of select="year"/></td>
              <td><xsl:value-of select="description"/></td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </div>
  </xsl:template>

</xsl:stylesheet>
