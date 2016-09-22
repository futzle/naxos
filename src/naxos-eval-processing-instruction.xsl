<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="xsl:processing-instruction" mode="eval">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value"/>

        <xsl:if test="not(@name)">
            <xsl:message terminate="yes">xsl:processing-instruction without name
            attribute</xsl:message>
        </xsl:if>

        <xsl:variable name="name">
            <!-- { to do } -->
            <xsl:value-of select="@name"/>
        </xsl:variable>

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
            <xsl:message terminate="yes">xsl:processing-instruction produced non-text
            node</xsl:message>
        </xsl:if>

        <xsl:if test="contains($result, '?>')">
            <xsl:message terminate="yes">xsl:processing-instruction produced sequence
            ?&gt;.</xsl:message>
        </xsl:if>

        <xsl:value-of select="concat('p:', $name, ':', substring-after($result, ':'))"/>
    </xsl:template>
</xsl:stylesheet>