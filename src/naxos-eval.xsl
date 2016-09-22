<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="lib-datatype.xsl"/>
    <xsl:import href="xpath-parser.xsl"/>
    <xsl:import href="naxos-serialize.xsl"/>
    <xsl:include href="naxos-eval-apply-templates.xsl"/>
    <xsl:include href="naxos-eval-call-template.xsl"/>
    <xsl:include href="naxos-eval-value-of.xsl"/>
    <xsl:include href="naxos-eval-for-each.xsl"/>
    <xsl:include href="naxos-eval-variable.xsl"/>
    <xsl:include href="naxos-eval-choose.xsl"/>
    <xsl:include href="naxos-eval-if.xsl"/>
    <xsl:include href="naxos-eval-element.xsl"/>
    <xsl:include href="naxos-eval-attribute.xsl"/>
    <xsl:include href="naxos-eval-message.xsl"/>
    <xsl:include href="naxos-eval-text.xsl"/>
    <xsl:include href="naxos-eval-processing-instruction.xsl"/>
    <xsl:include href="naxos-eval-comment.xsl"/>
    <xsl:include href="naxos-eval-literal-element.xsl"/>
    <xsl:include href="naxos-eval-with-param.xsl"/>    

    <xsl:template name="eval-template">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="node"/>
        <xsl:param name="context"/>

        <xsl:choose>
            <xsl:when
                test="$node/node()[self::* or self::text()[normalize-space() != ''] or self::text()[not(../*)]]">
                <xsl:apply-templates
                    select="$node/node()[self::* or self::text()[normalize-space() != ''] or self::text()[not(../*)]][1]"
                    mode="eval-template-walk">
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="running-value" select="''"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="collect-namespaces">
                    <xsl:with-param name="hash">
                        <xsl:call-template name="hash-lookup">
                            <xsl:with-param name="hash" select="$context"/>
                            <xsl:with-param name="key" select="'attribute-namespaces'"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="collect-attributes">
                    <xsl:with-param name="hash">
                        <xsl:call-template name="hash-lookup">
                            <xsl:with-param name="hash" select="$context"/>
                            <xsl:with-param name="key" select="'element-attributes'"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="node()" mode="eval-template-walk">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value"/>

        <xsl:variable name="result">
            <xsl:apply-templates select="." mode="eval">
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
                <xsl:with-param name="running-value" select="$running-value"/>
            </xsl:apply-templates>
        </xsl:variable>

        <xsl:variable name="new-context">
            <xsl:apply-templates select="." mode="update-context">
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="running-value" select="$running-value"/>
            </xsl:apply-templates>
        </xsl:variable>

        <xsl:variable name="new-running-value">
            <xsl:call-template name="merge-text-nodes">
                <xsl:with-param name="lhs" select="$running-value"/>
                <xsl:with-param name="rhs" select="$result"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when
                test="following-sibling::node()[self::* or self::text()[normalize-space() != ''] or self::text()[not(../*)]]">
                <xsl:apply-templates
                    select="following-sibling::node()[self::* or self::text()[normalize-space() != ''] or self::text()[not(../*)]][1]"
                    mode="eval-template-walk">
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="context" select="$new-context"/>
                    <xsl:with-param name="running-value" select="$new-running-value"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="collect-namespaces">
                    <xsl:with-param name="hash">
                        <xsl:call-template name="hash-lookup">
                            <xsl:with-param name="hash" select="$new-context"/>
                            <xsl:with-param name="key" select="'attribute-namespaces'"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="collect-attributes">
                    <xsl:with-param name="hash">
                        <xsl:call-template name="hash-lookup">
                            <xsl:with-param name="hash" select="$new-context"/>
                            <xsl:with-param name="key" select="'element-attributes'"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
                <xsl:value-of select="$new-running-value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="collect-attributes">
        <xsl:param name="hash"/>
        <xsl:call-template name="collect-attributes-repeat">
            <xsl:with-param name="attributes" select="substring-after($hash, ';')"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="collect-attributes-repeat">
        <xsl:param name="attributes"/>
        <xsl:param name="running-value"/>

        <xsl:choose>
            <xsl:when test="string-length($attributes) != 0">
                <xsl:variable name="first" select="substring-before($attributes, ';')"/>
                <xsl:variable name="first-key">
                    <xsl:call-template name="decode">
                        <xsl:with-param name="expr" select="substring-before($first, ':')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="first-value">
                    <xsl:call-template name="decode">
                        <xsl:with-param name="expr" select="substring-after($first, ':')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="tag">
                    <xsl:value-of select="substring-before($first-value, ':')"/>
                </xsl:variable>
                <!-- Don't need this (I think)
                <xsl:variable name="namespace">
                    <xsl:choose>
                        <xsl:when test="starts-with($first-key, '{')">
                            <xsl:call-template name="encode">
                                <xsl:with-param name="expr"
                                    select="substring-before(substring-after($first-key, '{'), '}')"
                                />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="''"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                    -->
                <xsl:variable name="local-name">
                    <xsl:choose>
                        <xsl:when test="starts-with($first-key, '{')">
                            <xsl:value-of select="substring-after($first-key, '}')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$first-key"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="value">
                    <xsl:call-template name="encode">
                        <xsl:with-param name="expr" select="substring-after($first-value, ':')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="result">
                    <xsl:value-of select="concat('a:', $tag, ':', $local-name, ':', $value, ';')"/>
                </xsl:variable>
                <xsl:call-template name="collect-attributes-repeat">
                    <xsl:with-param name="attributes" select="substring-after($attributes, ';')"/>
                    <xsl:with-param name="running-value" select="concat($running-value, $result)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$running-value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="collect-namespaces">
        <xsl:param name="hash"/>
        <xsl:call-template name="collect-namespaces-repeat">
            <xsl:with-param name="namespaces" select="substring-after($hash, ';')"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="collect-namespaces-repeat">
        <xsl:param name="namespaces"/>
        <xsl:param name="running-value"/>

        <xsl:choose>
            <xsl:when test="string-length($namespaces) != 0">
                <xsl:variable name="first" select="substring-before($namespaces, ';')"/>
                <xsl:variable name="result">
                    <xsl:value-of select="concat('ns:', $first, ';')"/>
                </xsl:variable>
                <xsl:call-template name="collect-namespaces-repeat">
                    <xsl:with-param name="namespaces" select="substring-after($namespaces, ';')"/>
                    <xsl:with-param name="running-value" select="concat($running-value, $result)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$running-value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="comment() | processing-instruction()" mode="eval"/>

    <xsl:template match="xsl:apply-imports" mode="eval">
        <!-- To do -->
    </xsl:template>

    <xsl:template match="xsl:copy-of" mode="eval">
        <!-- To do -->
    </xsl:template>

    <xsl:template match="xsl:number" mode="eval">
        <!-- To do -->
    </xsl:template>

    <xsl:template match="xsl:copy" mode="eval">
        <!-- To do -->
    </xsl:template>

    <xsl:template match="xsl:fallback" mode="eval">
        <!-- To do -->
    </xsl:template>

    <xsl:template match="xsl:sort" mode="eval"/>

    <!-- Default for in-template commands. -->
    <xsl:template match="xsl:*" mode="eval">
        <xsl:message terminate="yes">
            <xsl:text>Unknown XSL element xsl:</xsl:text>
            <xsl:value-of select="local-name(.)"/>
        </xsl:message>
    </xsl:template>

    <xsl:template match="comment() | text()[normalize-space() = '']" mode="update-context">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value"/>

        <!-- Comments don't stop attributes being allowed. -->
        <xsl:value-of select="$context"/>
    </xsl:template>

    <!-- Default effect on context for a command. -->
    <xsl:template match="node()" mode="update-context">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value"/>

        <!-- After any node, attributes are not allowed. -->
        <xsl:call-template name="hash-replace">
            <xsl:with-param name="hash" select="$context"/>
            <xsl:with-param name="key" select="'attribute-allowed'"/>
            <xsl:with-param name="value" select="'-'"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
