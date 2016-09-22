<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="xsl:comment" mode="eval">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value"/>

        <xsl:variable name="result">
            <xsl:call-template name="eval-template">
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="node" select="."/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if
            test="not(starts-with($result, 't:'))
            or contains(substring-after($result, ':'), ':')">
            <xsl:message terminate="yes">xsl:comment produced non-text node</xsl:message>
        </xsl:if>

        <xsl:if test="contains($result, '--')">
            <xsl:message terminate="yes">xsl:comment produced sequence --.</xsl:message>
        </xsl:if>

        <xsl:if test="substring($result, string-length($result)-1, 2) = '-;'">
            <xsl:message terminate="yes">xsl:comment ends in -.</xsl:message>
        </xsl:if>

        <xsl:value-of select="concat('c:', substring-after($result, ':'))"/>
    </xsl:template>
</xsl:stylesheet>