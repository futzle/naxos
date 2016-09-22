<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="xsl:message" mode="eval">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value"/>

        <xsl:variable name="result">
            <xsl:call-template name="serialize-result-tree-fragment-text">
                <xsl:with-param name="tree">
                    <xsl:call-template name="eval-template">
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="node" select="."/>
                    </xsl:call-template>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="@terminate = 'yes'">
                <xsl:message terminate="yes">
                    <xsl:value-of select="$result"/>
                </xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>
                    <xsl:value-of select="$result"/>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>