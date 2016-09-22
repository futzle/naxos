<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="lib-datatype.xsl"/>
    <xsl:import href="xpath-parser.xsl"/>

    <xsl:template name="sort-nodeset">
        <xsl:param name="nodeset"/>
        <xsl:param name="order" select="."/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>

        <xsl:variable name="result">
            <xsl:call-template name="sort-nodeset-repeat">
                <xsl:with-param name="arguments" select="concat(substring-after($nodeset, ':'), ';')"/>
                <xsl:with-param name="order" select="$order/child::*[1][self::xsl:sort]"/>
                <xsl:with-param name="order-first" select="$order/child::*[1][self::xsl:sort]"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                <xsl:with-param name="context" select="$context"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$result = ''">
                <xsl:value-of select="'NS:-'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat('NS:', substring($result, 1, string-length($result) - 1))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="sort-nodeset-repeat">
        <xsl:param name="arguments"/>
        <xsl:param name="order"/>
        <xsl:param name="order-first"/>
        <xsl:param name="order-parsed-expr"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>

        <!-- Collect primary, secondary, ... sort keys and precompile them. -->
        <xsl:choose>
            <xsl:when test="$order">
                <xsl:variable name="new-order-parsed-expr">
                    <xsl:call-template name="encode">
                        <xsl:with-param name="expr">
                            <xsl:call-template name="parse">
                                <xsl:with-param name="expr">
                                    <xsl:choose>
                                        <xsl:when test="$order/@select">
                                            <xsl:value-of select="$order/@select"/>
                                        </xsl:when>
                                        <xsl:otherwise>.</xsl:otherwise>
                                    </xsl:choose>
                                </xsl:with-param>
                                <xsl:with-param name="start-production" select="'Expr'"/>
                            </xsl:call-template>
                            <xsl:if test="$order-parsed-expr = '-'">
                                <xsl:message terminate="yes">
                                    <xsl:text>Cannot parse sort expression </xsl:text>
                                    <xsl:value-of select="$order/@select"/>
                                </xsl:message>
                            </xsl:if>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="sort-nodeset-repeat">
                    <xsl:with-param name="arguments" select="$arguments"/>
                    <xsl:with-param name="order" select="$order/following-sibling::*[1][self::xsl:sort]"/>
                    <xsl:with-param name="order-first" select="$order-first"/>
                    <xsl:with-param name="order-parsed-expr" select="concat($order-parsed-expr, $new-order-parsed-expr, ';')"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="context" select="$context"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="sort-nodes">
                    <xsl:with-param name="arguments" select="$arguments"/>
                    <xsl:with-param name="remainder" select="$arguments"/>
                    <xsl:with-param name="order" select="$order-first"/>
                    <xsl:with-param name="order-parsed-expr" select="$order-parsed-expr"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="context" select="$context"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="sort-nodes">
        <xsl:param name="arguments"/>
        <xsl:param name="remainder"/>
        <xsl:param name="collected"/>
        <xsl:param name="order"/>
        <xsl:param name="order-parsed-expr"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="argument-list-offset" select="1"/>

        <xsl:choose>
            <xsl:when test="$remainder = ''">
                <xsl:value-of select="$collected"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="first" select="substring-before($remainder, ';')"/>
                <xsl:choose>
                    <xsl:when test="contains(concat(';', $collected), concat(';', $first, ';'))">
                        <xsl:call-template name="sort-nodes">
                            <xsl:with-param name="arguments" select="$arguments"/>
                            <xsl:with-param name="remainder" select="substring-after($remainder, ';')"/>
                            <xsl:with-param name="collected" select="$collected"/>
                            <xsl:with-param name="order" select="$order"/>
                            <xsl:with-param name="order-parsed-expr" select="$order-parsed-expr"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="argument-list-offset" select="$argument-list-offset + 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="sort-nodes">
                            <xsl:with-param name="arguments" select="$arguments"/>
                            <xsl:with-param name="remainder" select="$arguments"/>
                            <xsl:with-param name="collected">
                                <xsl:call-template name="sort-nodes-repeat">
                                    <xsl:with-param name="collected" select="$collected"/>
                                    <xsl:with-param name="best-node" select="$first"/>
                                    <xsl:with-param name="best-position" select="$argument-list-offset"/>
                                    <xsl:with-param name="order" select="$order"/>
                                    <xsl:with-param name="order-parsed-expr" select="$order-parsed-expr"/>
                                    <xsl:with-param name="arguments" select="substring-after($remainder, ';')"/>
                                    <xsl:with-param name="argument-list-offset" select="$argument-list-offset + 1"/>
                                    <xsl:with-param name="document" select="$document"/>
                                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                                    <xsl:with-param name="context" select="$context"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="order" select="$order"/>
                            <xsl:with-param name="order-parsed-expr" select="$order-parsed-expr"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            <xsl:with-param name="context" select="$context"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="sort-nodes-repeat">
        <xsl:param name="best-node"/>
        <xsl:param name="best-position"/>
        <xsl:param name="order"/>
        <xsl:param name="order-parsed-expr"/>
        <xsl:param name="collected"/>
        <xsl:param name="arguments"/>
        <xsl:param name="argument-list-offset"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>

        <xsl:choose>
            <xsl:when test="$arguments = ''">
                <xsl:value-of select="concat($collected, $best-node, ';')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="candidate" select="substring-before($arguments, ';')"/>
                <xsl:choose>
                    <xsl:when test="contains(concat(';', $collected), concat(';', $candidate, ';'))">
                        <xsl:call-template name="sort-nodes-repeat">
                            <xsl:with-param name="best-node" select="$best-node"/>
                            <xsl:with-param name="best-position" select="$best-position"/>
                            <xsl:with-param name="order" select="$order"/>
                            <xsl:with-param name="order-parsed-expr" select="$order-parsed-expr"/>
                            <xsl:with-param name="collected" select="$collected"/>
                            <xsl:with-param name="arguments" select="substring-after($arguments, ';')"/>
                            <xsl:with-param name="argument-list-offset" select="$argument-list-offset + 1"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            <xsl:with-param name="context" select="$context"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="result">
                            <xsl:call-template name="compare-sort-values">
                                <xsl:with-param name="lhs" select="$best-node"/>
                                <xsl:with-param name="lhs-position" select="$best-position"></xsl:with-param>
                                <xsl:with-param name="rhs" select="$candidate"/>
                                <xsl:with-param name="rhs-position" select="$argument-list-offset"></xsl:with-param>
                                <xsl:with-param name="order" select="$order"/>
                                <xsl:with-param name="order-parsed-expr" select="$order-parsed-expr"/>
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                                <xsl:with-param name="context" select="$context"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="$result &gt; 0">
                                <xsl:call-template name="sort-nodes-repeat">
                                    <xsl:with-param name="best-node" select="$candidate"/>
                                    <xsl:with-param name="best-position" select="$argument-list-offset"/>
                                    <xsl:with-param name="order" select="$order"/>
                                    <xsl:with-param name="order-parsed-expr" select="$order-parsed-expr"/>
                                    <xsl:with-param name="collected" select="$collected"/>
                                    <xsl:with-param name="arguments" select="substring-after($arguments, ';')"/>
                                    <xsl:with-param name="argument-list-offset" select="$argument-list-offset + 1"/>
                                    <xsl:with-param name="document" select="$document"/>
                                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                                    <xsl:with-param name="context" select="$context"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="sort-nodes-repeat">
                                    <xsl:with-param name="best-node" select="$best-node"/>
                                    <xsl:with-param name="best-position" select="$best-position"/>
                                    <xsl:with-param name="order" select="$order"/>
                                    <xsl:with-param name="order-parsed-expr" select="$order-parsed-expr"/>
                                    <xsl:with-param name="collected" select="$collected"/>
                                    <xsl:with-param name="arguments" select="substring-after($arguments, ';')"/>
                                    <xsl:with-param name="argument-list-offset" select="$argument-list-offset + 1"/>
                                    <xsl:with-param name="document" select="$document"/>
                                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                                    <xsl:with-param name="context" select="$context"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="compare-sort-values">
        <xsl:param name="lhs"/>
        <xsl:param name="lhs-position"/>
        <xsl:param name="rhs"/>
        <xsl:param name="rhs-position"/>
        <xsl:param name="order"/>
        <xsl:param name="order-parsed-expr"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>

        <xsl:choose>
            <xsl:when test="not($order)">
                <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="lhs-value">
                    <xsl:call-template name="eval-outermost">
                        <xsl:with-param name="expr">
                            <xsl:call-template name="decode">
                                <xsl:with-param name="expr" select="substring-before($order-parsed-expr, ';')"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        <xsl:with-param name="context">
                            <xsl:call-template name="hash-replace">
                                <xsl:with-param name="hash">
                                    <xsl:call-template name="hash-replace">
                                        <xsl:with-param name="hash">
                                            <xsl:call-template name="hash-replace">
                                                <xsl:with-param name="hash">
                                                    <xsl:value-of select="$context"/>
                                                </xsl:with-param>
                                                <xsl:with-param name="key" select="'current-node-position'"/>
                                                <xsl:with-param name="value" select="$lhs-position"/>
                                            </xsl:call-template>
                                        </xsl:with-param>
                                        <xsl:with-param name="key" select="'current-node'"/>
                                        <xsl:with-param name="value" select="$lhs"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="key" select="'namespaces'"/>
                                <xsl:with-param name="value">
                                    <xsl:call-template name="namespaces-of-node">
                                        <xsl:with-param name="node" select="$order"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="rhs-value">
                    <xsl:call-template name="eval-outermost">
                        <xsl:with-param name="expr">
                            <xsl:call-template name="decode">
                                <xsl:with-param name="expr" select="substring-before($order-parsed-expr, ';')"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        <xsl:with-param name="context">
                            <xsl:call-template name="hash-replace">
                                <xsl:with-param name="hash">
                                    <xsl:call-template name="hash-replace">
                                        <xsl:with-param name="hash">
                                            <xsl:call-template name="hash-replace">
                                                <xsl:with-param name="hash">
                                                    <xsl:value-of select="$context"/>
                                                </xsl:with-param>
                                                <xsl:with-param name="key" select="'current-node-position'"/>
                                                <xsl:with-param name="value" select="$rhs-position"/>
                                            </xsl:call-template>
                                        </xsl:with-param>
                                        <xsl:with-param name="key" select="'current-node'"/>
                                        <xsl:with-param name="value" select="$rhs"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="key" select="'namespaces'"/>
                                <xsl:with-param name="value">
                                    <xsl:call-template name="namespaces-of-node">
                                        <xsl:with-param name="node" select="$order"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="comparison-result">
                    <xsl:choose>
                        <xsl:when test="$order/@data-type = 'number'">
                            <xsl:variable name="lhs-number">
                                <xsl:call-template name="cast-number">
                                    <xsl:with-param name="expr" select="$lhs-value"/>
                                    <xsl:with-param name="context" select="$context"/>
                                    <xsl:with-param name="document" select="$document"/>
                                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="rhs-number">
                                <xsl:call-template name="cast-number">
                                    <xsl:with-param name="expr" select="$rhs-value"/>
                                    <xsl:with-param name="context" select="$context"/>
                                    <xsl:with-param name="document" select="$document"/>
                                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="not($order/@order) or $order/@order = 'ascending'">
                                    <xsl:value-of select="$lhs-number - $rhs-number"/>
                                </xsl:when>
                                <xsl:when test="$order/@order = 'descending'">
                                    <xsl:value-of select="$rhs-number - $lhs-number"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:message terminate="yes">Unknown sort order</xsl:message>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="not($order/@data-type) or $order/@data-type = 'text'">
                            <xsl:variable name="lhs-string">
                                <xsl:call-template name="cast-string">
                                    <xsl:with-param name="expr" select="$lhs-value"/>
                                    <xsl:with-param name="context" select="$context"/>
                                    <xsl:with-param name="document" select="$document"/>
                                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="rhs-string">
                                <xsl:call-template name="cast-string">
                                    <xsl:with-param name="expr" select="$rhs-value"/>
                                    <xsl:with-param name="context" select="$context"/>
                                    <xsl:with-param name="document" select="$document"/>
                                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="new-best">
                                <xsl:choose>
                                    <xsl:when test="not($order/@order) or $order/@order = 'ascending'">
                                        <xsl:call-template name="strcmp">
                                            <xsl:with-param name="lhs" select="$lhs-string"/>
                                            <xsl:with-param name="rhs" select="$rhs-string"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:when test="$order/@order = 'descending'">
                                        <xsl:call-template name="strcmp">
                                            <xsl:with-param name="lhs" select="$rhs-string"/>
                                            <xsl:with-param name="rhs" select="$lhs-string"/>
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:message terminate="yes">Unknown sort order</xsl:message>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="$new-best = 'rhs'">1</xsl:when>
                                <xsl:when test="$new-best = 'lhs'">-1</xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>

                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:message terminate="yes">Unknown sort data-type</xsl:message>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$comparison-result = 0">
                        <xsl:call-template name="compare-sort-values">
                            <xsl:with-param name="lhs" select="$lhs"></xsl:with-param>
                            <xsl:with-param name="lhs-position" select="$lhs-position"></xsl:with-param>
                            <xsl:with-param name="rhs" select="$rhs"></xsl:with-param>
                            <xsl:with-param name="rhs-position" select="$rhs-position"></xsl:with-param>
                            <xsl:with-param name="order" select="$order/following-sibling::*[1][self::xsl:sort]"></xsl:with-param>
                            <xsl:with-param name="order-parsed-expr" select="substring-after($order-parsed-expr, ';')"></xsl:with-param>
                            <xsl:with-param name="document" select="$document"></xsl:with-param>
                            <xsl:with-param name="stylesheet" select="$stylesheet"></xsl:with-param>
                            <xsl:with-param name="context" select="$context"></xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$comparison-result"/>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
</xsl:stylesheet>
