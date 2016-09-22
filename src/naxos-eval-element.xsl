<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="xsl:element" mode="eval">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value"/>

        <xsl:variable name="name">
            <!-- { to do } -->
            <xsl:value-of select="@name"/>
        </xsl:variable>

        <xsl:variable name="local-name">
            <xsl:choose>
                <xsl:when test="contains($name, ':')">
                    <xsl:value-of select="substring-after($name, ':')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$name"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="tag">
            <xsl:choose>
                <xsl:when
                    test="contains($name, ':') and (
                    not(@namespace) or 
                    @namespace and not(namespace::*[local-name() = substring-before($name, ':')]) or
                    @namespace and @namespace = string(namespace::*[local-name() = substring-before($name, ':')]))">
                    <!-- Ok, suggested tag name is OK. -->
                    <xsl:value-of select="substring-before($name, ':')"/>
                </xsl:when>
                <xsl:when test="@namespace and namespace::*[string() = @namespace]">
                    <xsl:value-of select="local-name(namespace::*[string() = @namespace])"/>
                </xsl:when>
                <xsl:when test="@namespace">
                    <xsl:value-of select="concat('naxos-ns-', generate-id())"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="local-name(namespace::*[string() = ''])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:if
            test="contains($name, ':') and not(@namespace) and not(namespace::*[local-name() = $tag])">
            <xsl:message terminate="yes">
                <xsl:text>Tag </xsl:text>
                <xsl:value-of select="$tag"/>
                <xsl:text> is not known and no namespace attribute given.</xsl:text>
            </xsl:message>
        </xsl:if>

        <xsl:variable name="namespace">
            <xsl:call-template name="encode">
                <xsl:with-param name="expr">
                    <xsl:choose>
                        <xsl:when test="@namespace">
                            <xsl:value-of select="@namespace"/>
                        </xsl:when>
                        <xsl:when
                            test="contains($name, ':') and namespace::*[local-name() = substring-before($name, ':')]">
                            <xsl:value-of
                                select="string(namespace::*[local-name() = substring-before($name, ':')])"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="string(namespace::*[local-name() = ''])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="new-context">
            <xsl:call-template name="hash-replace">
                <xsl:with-param name="hash">
                    <xsl:call-template name="hash-replace">
                        <xsl:with-param name="hash">
                            <xsl:call-template name="hash-replace">
                                <xsl:with-param name="hash" select="$context"/>
                                <xsl:with-param name="key" select="'attribute-allowed'"/>
                                <xsl:with-param name="value" select="'yes'"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="key" select="'attribute-namespaces'"/>
                        <xsl:with-param name="value">
                            <xsl:call-template name="namespaces-of-node">
                                <xsl:with-param name="node" select="."/>
                            </xsl:call-template>
                            <!-- If explicit namespace given, may not match any known tag. -->
                            <xsl:if
                                test="@namespace and not(namespace::*[string(.) = current()/@namespace])">
                                <xsl:value-of select="$tag"/>
                                <xsl:text>:</xsl:text>
                                <xsl:call-template name="encode">
                                    <xsl:with-param name="expr" select="@namespace"/>
                                </xsl:call-template>
                                <xsl:text>;</xsl:text>
                            </xsl:if>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="key" select="'element-attributes'"/>
                <xsl:with-param name="value" select="';'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="result">
            <xsl:call-template name="encode">
                <xsl:with-param name="expr">
                    <xsl:call-template name="eval-template">
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        <xsl:with-param name="context" select="$new-context"/>
                        <xsl:with-param name="node" select="."/>
                    </xsl:call-template>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:value-of
            select="concat('e:', $tag, ':', $namespace, ':', $local-name, ':', $result, ';')"/>
    </xsl:template>
</xsl:stylesheet>