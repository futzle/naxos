<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="encoding.xsl"/>
    <xsl:import href="lib-datatype.xsl"/>

    <!-- Set these in the importing stylesheet. -->
    <xsl:param name="grammar-document"/>
    <xsl:param name="grammar-namespace-prefix"/>

    <xsl:template name="eval-outermost">
        <xsl:param name="expr"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        
        <xsl:call-template name="eval">
            <xsl:with-param name="expr" select="$expr"></xsl:with-param>
            <xsl:with-param name="context">
                <xsl:call-template name="hash-replace">
                    <xsl:with-param name="hash">
                        <xsl:call-template name="hash-replace">
                            <xsl:with-param name="hash">
                                <xsl:call-template name="hash-replace">
                                    <xsl:with-param name="hash" select="$context"></xsl:with-param>
                                    <xsl:with-param name="key" select="'context-node'"></xsl:with-param>
                                    <xsl:with-param name="value">
                                        <xsl:call-template name="hash-lookup">
                                            <xsl:with-param name="hash" select="$context"></xsl:with-param>
                                            <xsl:with-param name="key" select="'current-node'"></xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="key" select="'context-position'"></xsl:with-param>
                            <xsl:with-param name="value">
                                <xsl:call-template name="hash-lookup">
                                    <xsl:with-param name="hash" select="$context"></xsl:with-param>
                                    <xsl:with-param name="key" select="'current-node-position'"></xsl:with-param>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="key" select="'context-size'"></xsl:with-param>
                    <xsl:with-param name="value">
                        <xsl:call-template name="nodeset-size">
                            <xsl:with-param name="expr">
                                <xsl:call-template name="hash-lookup">
                                    <xsl:with-param name="hash" select="$context"></xsl:with-param>
                                    <xsl:with-param name="key" select="'current-node-list'"></xsl:with-param>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="document" select="$document"></xsl:with-param>
            <xsl:with-param name="stylesheet" select="$stylesheet"></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="eval">
        <xsl:param name="expr"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>


        <xsl:variable name="rule" select="substring-before(string($expr), ':')"/>
        <xsl:variable name="alternation"
            select="substring-before(substring-after(string($expr), ':'), ':')"/>
        <xsl:variable name="argument">
            <xsl:call-template name="decode">
                <xsl:with-param name="expr"
                    select="substring-after(substring-after(string($expr), ':'), ':')"/>
            </xsl:call-template>
        </xsl:variable>

<!--        <xsl:message>Evaluating <xsl:value-of select="$rule"/> <xsl:value-of
                select="$alternation"/> <xsl:value-of select="$argument"/></xsl:message>
-->
        <xsl:apply-templates
            select="$grammar-document/xsl:stylesheet/*[local-name() = 'rule'][namespace-uri() = concat($grammar-namespace-prefix, $rule)]">
            <xsl:with-param name="alternation" select="$alternation"/>
            <xsl:with-param name="argument" select="string($argument)"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:apply-templates>
    </xsl:template>

</xsl:stylesheet>
