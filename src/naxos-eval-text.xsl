<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="text()" mode="eval">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value"/>

        <xsl:variable name="text-encoded">
            <xsl:call-template name="encode">
                <xsl:with-param name="expr" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat('t:', $text-encoded, ';')"/>
    </xsl:template>

    <xsl:template match="xsl:text" mode="eval">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value"/>

        <xsl:variable name="text-encoded">
            <xsl:call-template name="encode">
                <xsl:with-param name="expr" select="text()"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat('t:', $text-encoded, ';')"/>
    </xsl:template>
</xsl:stylesheet>