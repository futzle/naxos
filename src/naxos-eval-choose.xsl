<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="xsl:choose" mode="eval">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value"/>

        <xsl:apply-templates select="xsl:when[1]" mode="eval">
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="running-value" select="$running-value"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="xsl:when" mode="eval">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value"/>

        <xsl:variable name="parsed-expr">
            <xsl:call-template name="parse">
                <xsl:with-param name="expr" select="@test"/>
                <xsl:with-param name="start-production" select="'Expr'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="$parsed-expr = '-'">
            <xsl:message terminate="yes">
                <xsl:text>Cannot parse expression </xsl:text>
                <xsl:value-of select="@select"/>
            </xsl:message>
        </xsl:if>

        <xsl:variable name="result">
            <xsl:call-template name="cast-boolean">
                <xsl:with-param name="expr">
                    <xsl:call-template name="eval-outermost">
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        <xsl:with-param name="context">
                            <xsl:call-template name="hash-replace">
                                <xsl:with-param name="hash" select="$context"/>
                                <xsl:with-param name="key" select="'namespaces'"/>
                                <xsl:with-param name="value">
                                    <xsl:call-template name="namespaces-of-node">
                                        <xsl:with-param name="node" select="."/>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="expr" select="$parsed-expr"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$result != 0">
                <xsl:call-template name="eval-template">
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="node" select="."/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="following-sibling::*[1]" mode="eval">
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="running-value" select="$running-value"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xsl:otherwise" mode="eval">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value"/>

        <xsl:call-template name="eval-template">
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="node" select="."/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>