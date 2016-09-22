<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="xsl:with-param">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>

        <xsl:variable name="name">
            <xsl:choose>
                <xsl:when test="contains(@name, ':')">
                    <xsl:value-of
                        select="concat('{', namespace::*[local-name() = substring-before(@name, ':')], '}', substring-after(@name, ':'))"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('{}', @name)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="result">
            <xsl:choose>
                <xsl:when test="@select">
                    <xsl:variable name="parsed-expr">
                        <xsl:call-template name="parse">
                            <xsl:with-param name="expr" select="@select"/>
                            <xsl:with-param name="start-production" select="'Expr'"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:if test="$parsed-expr = '-'">
                        <xsl:message terminate="yes">
                            <xsl:text>Cannot parse expression </xsl:text>
                            <xsl:value-of select="@select"/>
                        </xsl:message>
                    </xsl:if>
                    <xsl:call-template name="eval-outermost">
                        <xsl:with-param name="expr" select="$parsed-expr"/>
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
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Result tree fragment. -->
                    <xsl:text>R:</xsl:text>
                    <xsl:call-template name="eval-template">
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        <xsl:with-param name="context">
                            <xsl:call-template name="hash-replace">
                                <xsl:with-param name="hash" select="$context"/>
                                <xsl:with-param name="key" select="'attribute-allowed'"/>
                                <xsl:with-param name="value" select="'-'"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="node" select="."/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:call-template name="encode">
            <xsl:with-param name="expr" select="$name"></xsl:with-param>
        </xsl:call-template>
        <xsl:text>:</xsl:text>
        <xsl:call-template name="encode">
            <xsl:with-param name="expr" select="$result"></xsl:with-param>
        </xsl:call-template>
        <xsl:text>;</xsl:text>
    </xsl:template>
</xsl:stylesheet>