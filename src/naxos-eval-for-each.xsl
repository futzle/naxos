<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:import href="lib-datatype.xsl"/>
    <xsl:import href="naxos-eval-sort.xsl"/>
    
    <xsl:template match="xsl:for-each" mode="eval">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="context"/>
        <xsl:param name="running-value"/>

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

        <xsl:variable name="for-each-nodes">
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

        <xsl:variable name="for-each-nodes-type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$for-each-nodes"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="$for-each-nodes-type != 'nodeset'">
            <xsl:message terminate="yes">
                <xsl:text>for-each select result not a node set</xsl:text>
            </xsl:message>
        </xsl:if>

        <xsl:choose>
            <xsl:when test="$for-each-nodes = 'NS:-'"/>
            <xsl:otherwise>
                <xsl:variable name="sorted-for-each-nodes">
                    <xsl:call-template name="sort-nodeset">
                        <xsl:with-param name="nodeset" select="$for-each-nodes"></xsl:with-param>
                        <xsl:with-param name="document" select="$document"></xsl:with-param>
                        <xsl:with-param name="stylesheet" select="$stylesheet"></xsl:with-param>
                        <xsl:with-param name="context">
                            <xsl:call-template name="hash-replace">
                                <xsl:with-param name="hash" select="$context"></xsl:with-param>
                                <xsl:with-param name="key" select="'current-node-list'"></xsl:with-param>
                                <xsl:with-param name="value" select="$for-each-nodes"></xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="for-each-repeat">
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="arguments"
                        select="concat(substring-after($sorted-for-each-nodes, ':'), ';')"/>
                    <xsl:with-param name="context">
                        <xsl:call-template name="hash-replace">
                            <xsl:with-param name="hash" select="$context"/>
                            <xsl:with-param name="key" select="'current-node-list'"/>
                            <xsl:with-param name="value" select="$sorted-for-each-nodes"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    
    <xsl:template name="for-each-repeat">
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="arguments"/>
        <xsl:param name="context"/>
        <xsl:param name="current-node-position" select="1"/>
        
        <xsl:choose>
            <xsl:when test="contains($arguments, ';')">
                <xsl:call-template name="eval-template">
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="context">
                        <xsl:call-template name="hash-replace">
                            <xsl:with-param name="hash">
                                <xsl:call-template name="hash-replace">
                                    <xsl:with-param name="hash">
                                        <xsl:value-of select="$context"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="key" select="'current-node'"/>
                                    <xsl:with-param name="value"
                                        select="substring-before($arguments, ';')"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="key" select="'current-node-position'"/>
                            <xsl:with-param name="value" select="$current-node-position"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="node" select="."/>
                </xsl:call-template>
                <xsl:call-template name="for-each-repeat">
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="arguments" select="substring-after($arguments, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="current-node-position" select="$current-node-position + 1"
                    />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>