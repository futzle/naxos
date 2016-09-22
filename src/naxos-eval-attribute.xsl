<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <!-- Attributes affect context, not running value. -->
    <xsl:template match="xsl:attribute" mode="eval"/>
    
    
    <xsl:template match="xsl:attribute" mode="update-context">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value"/>

        <xsl:variable name="attribute-allowed">
            <xsl:call-template name="hash-lookup">
                <xsl:with-param name="hash" select="$context"/>
                <xsl:with-param name="key" select="'attribute-allowed'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="$attribute-allowed != 'yes'">
            <xsl:message terminate="yes">Cannot add attribute after element children.</xsl:message>
        </xsl:if>

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

        <xsl:variable name="attribute-namespaces">
            <xsl:call-template name="hash-lookup">
                <xsl:with-param name="hash" select="$context"/>
                <xsl:with-param name="key" select="'attribute-namespaces'"/>
            </xsl:call-template>
        </xsl:variable>


        <xsl:variable name="tag">
            <xsl:choose>
                <xsl:when test="contains($name, ':')">
                    <xsl:variable name="namespace-for-tag">
                        <xsl:call-template name="hash-lookup">
                            <xsl:with-param name="hash" select="$attribute-namespaces"/>
                            <xsl:with-param name="key" select="substring-before($name, ':')"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="not(@namespace)">
                            <!-- No namespace given; have to hope this one is defined already. -->
                            <xsl:value-of select="substring-before($name, ':')"/>
                        </xsl:when>
                        <xsl:when test="$namespace-for-tag = '-'">
                            <!-- This tag not in use.  May as well use suggestion. -->
                            <xsl:value-of select="substring-before($name, ':')"/>
                        </xsl:when>
                        <xsl:when test="@namespace = $namespace-for-tag">
                            <!-- This tag in use, coincidentally for the same namespace URI.  Re-use it. -->
                            <xsl:value-of select="substring-before($name, ':')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- The tag is being used for something else.  Ignore it. -->
                            <xsl:value-of select="concat('naxos-ns-', generate-id())"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@namespace and namespace::*[string() = @namespace]">
                    <!-- Here's one we prepared earlier. -->
                    <xsl:value-of select="local-name(namespace::*[string() = @namespace])"/>
                </xsl:when>
                <xsl:when test="@namespace">
                    <!-- Never heard of it.  Make something up. -->
                    <xsl:value-of select="concat('naxos-ns-', generate-id())"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''"/>
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
                            <xsl:value-of select="''"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="result">
            <xsl:call-template name="eval-template">
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                <xsl:with-param name="context">
                    <xsl:call-template name="hash-replace">
                        <xsl:with-param name="hash">
                            <xsl:call-template name="hash-replace">
                                <xsl:with-param name="hash">
                                    <xsl:call-template name="hash-replace">
                                        <xsl:with-param name="hash" select="$context"/>
                                        <xsl:with-param name="key" select="'element-attributes'"/>
                                        <xsl:with-param name="value" select="';'"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="key" select="'attribute-namespaces'"/>
                                <xsl:with-param name="value" select="';'"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="key" select="'attribute-allowed'"/>
                        <xsl:with-param name="value" select="'-'"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="node" select="."/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if
            test="not(starts-with($result, 't:'))
            or contains(substring-after($result, ':'), ':')">
            <xsl:message terminate="yes">xsl:attribute produced non-text node</xsl:message>
        </xsl:if>

        <xsl:variable name="new-attribute-namespaces">
            <xsl:choose>
                <xsl:when test="@namespace">
                    <xsl:variable name="namespace-known">
                        <xsl:call-template name="hash-lookup">
                            <xsl:with-param name="hash" select="$attribute-namespaces"/>
                            <xsl:with-param name="key" select="$tag"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="$namespace-known = '-'">
                            <xsl:call-template name="hash-replace">
                                <xsl:with-param name="hash" select="$attribute-namespaces"/>
                                <xsl:with-param name="key" select="$tag"/>
                                <xsl:with-param name="value" select="@namespace"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$attribute-namespaces"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$attribute-namespaces"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="element-attributes">
            <xsl:call-template name="hash-lookup">
                <xsl:with-param name="hash" select="$context"/>
                <xsl:with-param name="key" select="'element-attributes'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="new-element-attributes">
            <xsl:call-template name="hash-replace">
                <xsl:with-param name="hash" select="$element-attributes"/>
                <xsl:with-param name="key">
                    <xsl:choose>
                        <xsl:when test="string-length($namespace) &gt; 0">
                            <xsl:value-of select="concat('{', $namespace, '}', $local-name)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$local-name"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="value">
                    <xsl:value-of select="$tag"/>
                    <xsl:text>:</xsl:text>
                    <xsl:call-template name="serialize-result-tree-fragment-text">
                        <xsl:with-param name="tree" select="$result"/>
                    </xsl:call-template>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="hash-replace">
            <xsl:with-param name="hash">
                <xsl:call-template name="hash-replace">
                    <xsl:with-param name="hash" select="$context"/>
                    <xsl:with-param name="key" select="'attribute-namespaces'"/>
                    <xsl:with-param name="value" select="$new-attribute-namespaces"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="key" select="'element-attributes'"/>
            <xsl:with-param name="value" select="$new-element-attributes"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>