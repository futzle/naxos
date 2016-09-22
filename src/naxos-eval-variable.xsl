<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="xsl:variable | xsl:param" mode="eval">
        <!-- no effect on the result tree. -->
    </xsl:template>
    
    <xsl:template match="xsl:variable | xsl:param" mode="update-context">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value"/>

        <xsl:variable name="name">
            <xsl:choose>
                <xsl:when
                    test="contains(@name, ':') and not(namespace::*[local-name() = substring-before(current()/@name, ':')])">
                    <xsl:message terminate="yes">
                        <xsl:text>Variable or parameter declared with unknown namespace</xsl:text>
                    </xsl:message>
                </xsl:when>
                <xsl:when test="contains(@name, ':')">
                    <xsl:value-of
                        select="concat('{', string(namespace::*[local-name() = substring-before(current()/@name, ':')]),
                                          '}', substring-after(@name, ':'))"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('{}', @name)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="variables">
            <xsl:call-template name="hash-lookup">
                <xsl:with-param name="hash" select="$context"/>
                <xsl:with-param name="key" select="'variables'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="parameter">
            <xsl:variable name="parameters">
                <xsl:call-template name="hash-lookup">
                    <xsl:with-param name="hash" select="$context"/>
                    <xsl:with-param name="key" select="'parameters'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$parameters = '-'">
                    <xsl:value-of select="'-'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="hash-lookup">
                        <xsl:with-param name="hash" select="$parameters"/>
                        <xsl:with-param name="key" select="$name"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="result">
            <xsl:choose>
                <xsl:when test="self::xsl:param and $parameter != '-'">
                    <xsl:value-of select="$parameter"/>
                </xsl:when>
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

        <xsl:call-template name="hash-replace">
            <xsl:with-param name="hash" select="$context"/>
            <xsl:with-param name="key" select="'variables'"/>
            <xsl:with-param name="value">
                <xsl:call-template name="hash-replace">
                    <xsl:with-param name="hash" select="$variables"/>
                    <xsl:with-param name="key" select="$name"/>
                    <xsl:with-param name="value" select="$result"/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>