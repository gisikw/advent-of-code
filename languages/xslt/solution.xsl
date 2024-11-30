<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:param name="part" />

    <xsl:template match="/content">
        <!-- Using analyze-string to split lines by newline character -->
        <xsl:variable name="lines" as="node()*">
            <xsl:analyze-string select="." regex="&#xA;">
                <xsl:matching-substring>
                    <line><xsl:value-of select="."/></line>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>

        <!-- Count non-empty lines -->
        <xsl:variable name="line-count" select="count($lines/line[normalize-space() != ''])"/>

        <!-- Output the result -->
        <xsl:text>Received </xsl:text>
        <xsl:value-of select="$line-count"/>
        <xsl:text> lines of input for part </xsl:text>
        <xsl:value-of select="$part"/>
    </xsl:template>

</xsl:stylesheet>
