<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="lib-datatype.xsl"/>
    <xsl:import href="xpath-parser.xsl"/>

    <xsl:import href="naxos-stylesheets.xsl"/>
    <xsl:import href="naxos-variable.xsl"/>
    <xsl:import href="naxos-named-template.xsl"/>
    <xsl:import href="naxos-patterned-template.xsl"/>
    <xsl:import href="naxos-eval.xsl"/>
    <xsl:import href="naxos-serialize.xsl"/>

    <xsl:output method="text"/>

    <xsl:param name="use-stylesheet"/>

    <xsl:template match="/">
        <xsl:variable name="stylesheet-url">
            <xsl:choose>
                <xsl:when test="/processing-instruction('xml-stylesheet')">
                    <!-- To do better.  http://www.w3.org/TR/xml-stylesheet/ -->
                    <xsl:variable name="pi-value" select="string(/processing-instruction('xml-stylesheet'))"/>
                    <xsl:choose>
                        <xsl:when test="contains($pi-value, 'href=&quot;')">
                            <xsl:value-of select="substring-before(substring-after($pi-value, 'href=&quot;'), '&quot;')"/>
                        </xsl:when>
                        <xsl:when test="contains($pi-value, &quot;href='&quot;)">
                            <xsl:value-of select="substring-before(substring-after($pi-value, &quot;href='&quot;), &quot;'&quot;)"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="use-stylesheet">
                    <xsl:value-of select="use-stylesheet"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message terminate="yes">
                        <xsl:text>No xml-stylesheet processing instruction, or use-stylesheet parameter</xsl:text>
                    </xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="stylesheet" select="document($stylesheet-url, /)"/>

        <xsl:choose>
            <xsl:when test="$stylesheet/xsl:stylesheet">
                <xsl:apply-templates select="$stylesheet/xsl:stylesheet" mode="compile">
                    <xsl:with-param name="import-level" select="0"/>
                    <xsl:with-param name="document" select="/"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>
                    <xsl:text>Referenced stylesheet is not a stylesheet</xsl:text>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="xsl:stylesheet" mode="compile">
        <xsl:param name="import-level" select="0"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <!--
        <xsl:variable name="stylesheets">
            <xsl:apply-templates select="child::node()[1]" mode="collect-stylesheets">
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                <xsl:with-param name="stylesheet-relative-href" select="''"/>
                <xsl:with-param name="declarations" select="concat(';', ':', generate-id(/) ';')"/>
            </xsl:apply-templates>
        </xsl:variable>

        <xsl:message>
            <xsl:text>Stylesheet references: </xsl:text>
            <xsl:value-of select="$stylesheets"/>
        </xsl:message>
        -->
        
        <xsl:variable name="all-global-variable-declarations">
            <xsl:apply-templates select="child::node()[1]" mode="collect-global-variables">
                <xsl:with-param name="import-level" select="$import-level"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                <xsl:with-param name="stylesheet-relative-href" select="''"/>
                <xsl:with-param name="declarations" select="';'"/>
            </xsl:apply-templates>
        </xsl:variable>

<!--
        <xsl:message>
            <xsl:text>Global variable declarations: </xsl:text>
            <xsl:value-of select="$all-global-variable-declarations"/>
        </xsl:message>
-->

        <xsl:variable name="global-variable-declarations">
            <xsl:choose>
                <xsl:when test="$all-global-variable-declarations = ';'">
                    <xsl:value-of select="''"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="filter-overridden-variable-declarations">
                        <xsl:with-param name="expr" select="substring($all-global-variable-declarations, 2, string-length($all-global-variable-declarations) - 2)"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

<!--
        <xsl:message>
            <xsl:text>After removing overridden declarations: </xsl:text>
            <xsl:value-of select="$global-variable-declarations"/>
        </xsl:message>
-->

        <xsl:variable name="global-variables">
            <xsl:choose>
                <xsl:when test="$global-variable-declarations = ''">
                    <xsl:value-of select="';'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="eval-global-variables">
                        <xsl:with-param name="global-variable-declarations" select="concat($global-variable-declarations, ';')"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:variable>

<!--
        <xsl:message>
            <xsl:text>Global variable values: </xsl:text>
            <xsl:value-of select="$global-variables"/>
        </xsl:message>
-->

        <xsl:variable name="all-named-template-declarations">
            <xsl:apply-templates select="child::node()[1]" mode="collect-named-templates">
                <xsl:with-param name="import-level" select="$import-level"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                <xsl:with-param name="stylesheet-relative-href" select="''"/>
                <xsl:with-param name="declarations" select="''"/>
            </xsl:apply-templates>
        </xsl:variable>

<!--
        <xsl:message>
            <xsl:text>Named template declarations: </xsl:text>
            <xsl:value-of select="$all-named-template-declarations"/>
        </xsl:message>
-->

        <xsl:variable name="named-templates">
            <xsl:choose>
                <xsl:when test="$all-named-template-declarations = ''">
                    <xsl:value-of select="''"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="filter-overridden-named-template-declarations">
                        <xsl:with-param name="expr" select="concat('', substring($all-named-template-declarations, 1, string-length($all-named-template-declarations)))"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

<!--
        <xsl:message>
            <xsl:text>After removing overridden declarations: </xsl:text>
            <xsl:value-of select="$named-templates"/>
        </xsl:message>
-->

        <xsl:variable name="all-patterned-template-declarations">
            <xsl:apply-templates select="child::node()[1]" mode="collect-patterned-templates">
                <xsl:with-param name="import-level" select="$import-level"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                <xsl:with-param name="stylesheet-relative-href" select="''"/>
                <xsl:with-param name="declarations" select="''"/>
            </xsl:apply-templates>
        </xsl:variable>

<!--
        <xsl:message>
            <xsl:text>Patterned template declarations: </xsl:text>
            <xsl:value-of select="$all-patterned-template-declarations"/>
        </xsl:message>
-->

        <xsl:apply-templates select="$stylesheet" mode="run">
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
            <!--
            <xsl:with-param name="stylesheets" select="$stylesheets"></xsl:with-param>
                -->
            <xsl:with-param name="global-variables" select="$global-variables"/>
            <xsl:with-param name="named-templates" select="$named-templates"/>
            <xsl:with-param name="patterned-templates" select="$all-patterned-template-declarations"/>
        </xsl:apply-templates>

    </xsl:template>

    <xsl:template match="/" mode="run">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <!--
        <xsl:param name="stylesheets"></xsl:param>
            -->
        <xsl:param name="global-variables"/>
        <xsl:param name="named-templates"/>
        <xsl:param name="patterned-templates"/>

        <xsl:variable name="result-tree">
            <xsl:call-template name="apply-template">
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                <xsl:with-param name="context">
                    <xsl:call-template name="hash-replace">
                        <xsl:with-param name="hash">
                            <xsl:call-template name="hash-replace">
                                <xsl:with-param name="hash">
                                    <xsl:call-template name="hash-replace">
                                        <xsl:with-param name="hash">
                                            <xsl:call-template name="hash-replace">
                                                <xsl:with-param name="hash">
                                                    <xsl:call-template name="hash-replace">
                                                        <xsl:with-param name="hash">
                                                            <xsl:call-template name="hash-replace">
                                                                <xsl:with-param name="hash">
                                                                    <!--
                                                                    <xsl:call-template name="hash-replace">
                                                                        <xsl:with-param select="hash"> -->
                                                                            <xsl:text>;</xsl:text>
                                                                    <!--
                                                                        </xsl:with-param>
                                                                        <xsl:with-param name="key" select="'stylesheets'"></xsl:with-param>
                                                                        <xsl:with-param name="value" select="$stylesheets"></xsl:with-param>
                                                                    </xsl:call-template> -->
                                                                </xsl:with-param>
                                                                <xsl:with-param name="key" select="'current-node-position'"/>
                                                                <xsl:with-param name="value" select="1"/>
                                                            </xsl:call-template>
                                                        </xsl:with-param>
                                                        <xsl:with-param name="key" select="'current-node-list'"/>
                                                        <xsl:with-param name="value" select="'NS:+:'"/>
                                                    </xsl:call-template>
                                                </xsl:with-param>
                                                <xsl:with-param name="key" select="'current-node'"/>
                                                <xsl:with-param name="value" select="'+:'"/>
                                            </xsl:call-template>
                                        </xsl:with-param>
                                        <xsl:with-param name="key" select="'global-variables'"/>
                                        <xsl:with-param name="value" select="$global-variables"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="key" select="'named-templates'"/>
                                <xsl:with-param name="value" select="$named-templates"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="key" select="'patterned-templates'"/>
                        <xsl:with-param name="value" select="$patterned-templates"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="patterned-templates" select="$patterned-templates"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="serialize-result-tree">
            <xsl:with-param name="tree" select="$result-tree"/>
            <xsl:with-param name="output" select="$stylesheet/xsl:stylesheet/xsl:output[1]"/>
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>
