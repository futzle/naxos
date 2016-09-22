<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="*" mode="eval">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value"/>

        <xsl:choose>
            <xsl:when
                test="namespace-uri() = 'http://www.w3.org/1999/XSL/Transform' or 
                 namespace-uri() != '' and 
                 (ancestor-or-self::*[contains(concat(' ', translate(@exclude-result-prefixes, '&#x20;&#x0a;&#x09;&#x0d;', '    '), ' '), concat(' ', local-name(namespace::*[local-name() != '' and string() = namespace-uri(current())]), ' '))]
                or ancestor-or-self::*[contains(concat(' ', translate(@exclude-result-prefixes, '&#x20;&#x0a;&#x09;&#x0d;', '    '), ' '), ' #default ') and local-name(namespace::*[string() = namespace-uri(current())]) = ''])">
                <!-- Result prefix is excluded. -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="local-name" select="local-name()"/>
                <xsl:variable name="tag"
                    select="local-name(namespace::*[string() = namespace-uri(current())])"/>
                <xsl:variable name="namespace" select="namespace-uri()"/>

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
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="key" select="'element-attributes'"/>
                        <xsl:with-param name="value">
                            <xsl:text>;</xsl:text>
                            <xsl:for-each select="@*">
                                <xsl:if
                                    test="namespace-uri() = '' or
                                    namespace-uri != 'http://www.w3.org/1999/XSL/Transform' and
                                    not(ancestor::*[contains(concat(' ', translate(@exclude-result-prefixes, '&#x20;&#x0a;&#x09;&#x0d;', '    '), ' '), concat(' ', local-name(namespace::*[local-name() != '' and string() = namespace-uri(current())]), ' '))])">
                                    <xsl:variable name="attribute-local-name" select="local-name()"/>
                                    <xsl:variable name="attribute-namespace-encoded">
                                        <xsl:call-template name="encode">
                                            <xsl:with-param name="expr" select="namespace-uri()"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:variable name="attribute-tag"
                                        select="local-name(../namespace::*[string() = namespace-uri(current())])"/>
                                    <xsl:variable name="attribute-value">
                                        <!-- { to do } -->
                                        <xsl:value-of select="string(.)"/>
                                    </xsl:variable>
                                    <xsl:call-template name="encode">
                                        <xsl:with-param name="expr">
                                            <xsl:if test="namespace-uri() != ''">
                                                <xsl:text>{</xsl:text>
                                                <xsl:value-of select="$attribute-namespace-encoded"/>
                                                <xsl:text>}</xsl:text>
                                            </xsl:if>
                                            <xsl:value-of select="$attribute-local-name"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                    <xsl:text>:</xsl:text>
                                    <xsl:call-template name="encode">
                                        <xsl:with-param name="expr">
                                            <xsl:value-of
                                                select="concat($attribute-tag, ':', $attribute-value)"
                                            />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                    <xsl:text>;</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:with-param>
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

            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
</xsl:stylesheet>