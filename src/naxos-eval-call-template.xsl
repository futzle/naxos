<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="lib-datatype.xsl"/>
    
    <xsl:template match="xsl:call-template" mode="eval">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value"/>

        <xsl:variable name="name">
            <xsl:choose>
                <xsl:when test="contains(@name, ':')">
                    <xsl:value-of select="concat('{', namespace::*[local-name() = substring-before(@name, ':')], '}', substring-after(@name, ':'))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('{}', @name)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="template-location">
            <xsl:call-template name="hash-lookup">
                <xsl:with-param name="hash">
                    <xsl:call-template name="hash-lookup">
                        <xsl:with-param name="hash" select="$context"/>
                        <xsl:with-param name="key" select="'named-templates'"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="key" select="$name"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="$template-location = '-'">
            <xsl:message terminate="yes">
                <xsl:text>Cannot locate template </xsl:text>
                <xsl:value-of select="$name"/>
            </xsl:message>
        </xsl:if>

        <xsl:variable name="template-document">
            <xsl:call-template name="decode">
                <xsl:with-param name="expr" select="substring-before($template-location, ':')"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="parameters">
            <xsl:text>;</xsl:text>
            <xsl:apply-templates select="xsl:with-param">
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                <xsl:with-param name="context" select="$context"/>
            </xsl:apply-templates>
        </xsl:variable>

        <xsl:call-template name="eval-template">
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
            <xsl:with-param name="node" select="document($template-document, $stylesheet)//xsl:template[generate-id() = substring-after($template-location, ':')]"/>
            <xsl:with-param name="context">
                <xsl:call-template name="hash-replace">
                    <xsl:with-param name="hash">
                        <xsl:call-template name="hash-replace">
                            <xsl:with-param name="hash">
                                <xsl:value-of select="$context"/>
                            </xsl:with-param>
                            <xsl:with-param name="key" select="'current-template-document'"></xsl:with-param>
                            <xsl:with-param name="value" select="$template-document"></xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="key" select="'parameters'"/>
                    <xsl:with-param name="value" select="$parameters"/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
