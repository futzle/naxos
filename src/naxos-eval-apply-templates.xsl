<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="xpath-parser.xsl"/>
    <xsl:import href="naxos-match.xsl"/>
    <xsl:import href="lib-datatype.xsl"/>
    <xsl:import href="naxos-eval-sort.xsl"/>

    <xsl:template name="apply-template">
        <xsl:param name="stylesheet"/>
        <xsl:param name="document"/>
        <xsl:param name="context"/>

        <xsl:param name="current-node">
            <xsl:call-template name="hash-lookup">
                <xsl:with-param name="hash" select="$context"/>
                <xsl:with-param name="key" select="'current-node'"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:variable name="mode">
            <xsl:call-template name="hash-lookup">
                <xsl:with-param name="hash" select="$context"/>
                <xsl:with-param name="key" select="'mode'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="patterned-templates">
            <xsl:call-template name="hash-lookup">
                <xsl:with-param name="hash" select="$context"/>
                <xsl:with-param name="key" select="'patterned-templates'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="applied-from-import">
            <xsl:call-template name="hash-lookup">
                <xsl:with-param name="hash" select="$context"/>
                <xsl:with-param name="key" select="'applied-from-import'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="template-to-apply">
            <xsl:call-template name="find-template-to-apply">
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="current-node" select="$current-node"/>
                <xsl:with-param name="mode" select="$mode"/>
                <xsl:with-param name="patterned-templates" select="$patterned-templates"/>
                <xsl:with-param name="applied-from-import" select="$applied-from-import"/>
            </xsl:call-template>
        </xsl:variable>

<!--
        <xsl:message>
            <xsl:text>Chose to apply template </xsl:text>
            <xsl:value-of select="$template-to-apply"/>
            <xsl:text> to node </xsl:text>
            <xsl:value-of select="$current-node"/>
            <xsl:text> with mode </xsl:text>
            <xsl:value-of select="$mode"/>
            <xsl:text> using imports from </xsl:text>
            <xsl:value-of select="$applied-from-import"/>
        </xsl:message>
-->

        <xsl:choose>
            <xsl:when test="$template-to-apply = '-'">
                <!-- No template matched. -->
                <xsl:call-template name="apply-default-template">
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="current-node" select="$current-node"/>
                    <xsl:with-param name="mode" select="$mode"/>
                    <xsl:with-param name="context" select="$context"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- Apply given template. -->
                <xsl:call-template name="eval-template">
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="context">
                        <xsl:call-template name="hash-replace">
                            <xsl:with-param name="hash" select="$context"/>
                            <xsl:with-param name="key" select="'variables'"/>
                            <xsl:with-param name="value">
                                <xsl:call-template name="hash-lookup">
                                    <xsl:with-param name="hash">
                                        <xsl:call-template name="hash-lookup">
                                            <xsl:with-param name="hash">
                                                <xsl:value-of select="$context"/>
                                            </xsl:with-param>
                                            <xsl:with-param name="key" select="'current-template-document'"></xsl:with-param>
                                            <xsl:with-param name="value" select="substring-before($template-to-apply, ':')"></xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="key" select="'global-variables'"/>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="node" select="document(substring-before($template-to-apply, ':'), $stylesheet)//xsl:template[generate-id() = substring-after($template-to-apply, ':')]"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="apply-default-template">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="current-node"/>
        <xsl:param name="mode"/>
        <xsl:param name="context"/>

        <xsl:variable name="node-type">
            <xsl:choose>
                <xsl:when test="$current-node = '-'">
                    <xsl:message terminate="yes">
                        <xsl:text>Tried to apply default template to empty nodeset.</xsl:text>
                    </xsl:message>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="node-type">
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        <xsl:with-param name="node" select="$current-node"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$node-type = 'element' or $node-type = 'document'">
                <!-- apply templates to children, with matching mode. -->
<!--
                <xsl:message>
                    <xsl:text>Default template (element, document)</xsl:text>
                </xsl:message>
-->
                <xsl:call-template name="apply-templates">
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="select" select="'node()'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$node-type = 'text' or $node-type = 'attribute'">
                <xsl:message>
                    <xsl:text>Default template (text, attribute)</xsl:text>
                </xsl:message>
                <xsl:variable name="node-text-value">
                    <xsl:call-template name="encode">
                        <xsl:with-param name="expr">
                            <xsl:call-template name="cast-string">
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                                <xsl:with-param name="context" select="';'"/>
                                <xsl:with-param name="expr" select="concat('NS:', $current-node)"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat('t:', $node-text-value, ';')"/>
            </xsl:when>
            <xsl:when test="$node-type = 'comment' or $node-type = 'namespace' or $node-type = 'processing-instruction'"/>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    <xsl:text>Element type not recognized</xsl:text>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="apply-templates">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="select"/>
        <xsl:param name="context"/>

        <xsl:variable name="select-expr">
            <xsl:call-template name="parse">
                <xsl:with-param name="expr" select="$select"/>
                <xsl:with-param name="start-production" select="'Expr'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="$select-expr = '-'">
            <xsl:message terminate="yes">
                <xsl:text>Failed to parse expression </xsl:text>
                <xsl:value-of select="$select"/>
            </xsl:message>
        </xsl:if>

        <xsl:variable name="select-nodes">
            <xsl:call-template name="eval-outermost">
                <xsl:with-param name="expr" select="$select-expr"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                <xsl:with-param name="context" select="$context"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="not(starts-with($select-nodes, 'NS:'))">
            <xsl:message terminate="yes">
                <xsl:text>apply-templates select did not produce node set</xsl:text>
            </xsl:message>
        </xsl:if>

        <xsl:choose>
            <xsl:when test="$select-nodes = 'NS:-'"/>
            <xsl:otherwise>
                <xsl:call-template name="apply-templates-repeat">
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="arguments" select="concat(substring-after($select-nodes, ':'), ';')"/>
                    <xsl:with-param name="context">
                        <xsl:call-template name="hash-replace">
                            <xsl:with-param name="hash">
                                <xsl:call-template name="hash-replace">
                                    <xsl:with-param name="hash" select="$context"/>
                                    <xsl:with-param name="key" select="'parameters'"/>
                                    <xsl:with-param name="value" select="';'"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="key" select="'current-node-list'"/>
                            <xsl:with-param name="value" select="$select-nodes"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="apply-templates-repeat">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="arguments"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value" select="''"/>
        <xsl:param name="current-node-position" select="1"/>

        <xsl:choose>
            <xsl:when test="string-length($arguments) &gt; 0">
                <xsl:variable name="first" select="substring-before($arguments, ';')"/>

                <xsl:variable name="first-result">
                    <xsl:call-template name="apply-template">
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        <xsl:with-param name="context">
                            <xsl:call-template name="hash-replace">
                                <xsl:with-param name="hash">
                                    <xsl:call-template name="hash-replace">
                                        <xsl:with-param name="hash" select="$context"/>
                                        <xsl:with-param name="key" select="'current-node-position'"/>
                                        <xsl:with-param name="value" select="$current-node-position"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="key" select="'current-node'"/>
                                <xsl:with-param name="value" select="$first"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="new-running-value">
                    <xsl:call-template name="merge-text-nodes">
                        <xsl:with-param name="lhs" select="$running-value"/>
                        <xsl:with-param name="rhs" select="$first-result"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:call-template name="apply-templates-repeat">
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="arguments" select="substring-after($arguments, ';')"/>
                    <xsl:with-param name="running-value" select="$new-running-value"/>
                    <xsl:with-param name="current-node-position" select="$current-node-position + 1"/>
                </xsl:call-template>

            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$running-value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xsl:apply-templates" mode="eval">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value"/>

        <xsl:variable name="mode">
            <xsl:choose>
                <xsl:when test="not(@mode)">
                    <xsl:value-of select="'-'"/>
                </xsl:when>
                <xsl:when test="contains(@mode, ':') and not(namespace::*[local-name() = substring-before(current()/@mode, ':')])">
                    <xsl:message terminate="yes">
                        <xsl:text>Mode declared with unknown namespace</xsl:text>
                    </xsl:message>
                </xsl:when>
                <xsl:when test="contains(@mode, ':')">
                    <xsl:value-of select="concat('{', string(namespace::*[local-name() = substring-before(current()/@mode, ':')]),
                    '}', substring-after(@mode, ':'))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('{}', @mode)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="parsed-expr">
            <xsl:call-template name="parse">
                <xsl:with-param name="expr">
                    <xsl:choose>
                        <xsl:when test="@select">
                            <xsl:value-of select="@select"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'node()'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="start-production" select="'Expr'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="$parsed-expr = '-'">
            <xsl:message terminate="yes">
                <xsl:text>Cannot parse expression </xsl:text>
                <xsl:value-of select="@select"/>
            </xsl:message>
        </xsl:if>

        <xsl:variable name="apply-templates-nodes">
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
        </xsl:variable>

        <xsl:variable name="apply-templates-nodes-type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$apply-templates-nodes"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="$apply-templates-nodes-type != 'nodeset'">
            <xsl:message terminate="yes">
                <xsl:text>apply-templates select result not a node set</xsl:text>
            </xsl:message>
        </xsl:if>

        <xsl:variable name="parameters">
            <xsl:text>;</xsl:text>
            <xsl:apply-templates select="xsl:with-param">
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                <xsl:with-param name="context" select="$context"/>
            </xsl:apply-templates>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$apply-templates-nodes = 'NS:-'"/>
            <xsl:otherwise>
                <xsl:variable name="sorted-apply-templates-nodes">
                    <xsl:call-template name="sort-nodeset">
                        <xsl:with-param name="nodeset" select="$apply-templates-nodes"></xsl:with-param>
                        <xsl:with-param name="document" select="$document"></xsl:with-param>
                        <xsl:with-param name="stylesheet" select="$stylesheet"></xsl:with-param>
                        <xsl:with-param name="context">
                            <xsl:call-template name="hash-replace">
                                <xsl:with-param name="hash" select="$context"></xsl:with-param>
                                <xsl:with-param name="key" select="'current-node-list'"></xsl:with-param>
                                <xsl:with-param name="value" select="$apply-templates-nodes"></xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="apply-templates-repeat">
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="arguments" select="concat(substring-after($sorted-apply-templates-nodes, ':'), ';')"/>
                    <xsl:with-param name="context">
                        <xsl:call-template name="hash-replace">
                            <xsl:with-param name="hash">
                                <xsl:call-template name="hash-replace">
                                    <xsl:with-param name="hash">
                                        <xsl:call-template name="hash-replace">
                                            <xsl:with-param name="hash" select="$context"/>
                                            <xsl:with-param name="key" select="'mode'"/>
                                            <xsl:with-param name="value" select="$mode"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="key" select="'parameters'"/>
                                    <xsl:with-param name="value" select="$parameters"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="key" select="'current-node-list'"/>
                            <xsl:with-param name="value" select="$sorted-apply-templates-nodes"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
