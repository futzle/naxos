<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="lib-datatype.xsl"/>
    <xsl:import href="xpath-parser.xsl"/>

    <xsl:output method="text"/>

    <xsl:template match="variable">
        <xsl:call-template name="encode">
            <xsl:with-param name="expr" select="concat(@ns,@name)"/>
        </xsl:call-template>
        <xsl:text>:</xsl:text>
        <xsl:call-template name="encode">
            <xsl:with-param name="expr" select="@value"/>
        </xsl:call-template>
        <xsl:text>;</xsl:text>
    </xsl:template>

    <xsl:variable name="expr-context">
        <xsl:call-template name="hash-replace">
            <xsl:with-param name="hash">
                <xsl:call-template name="hash-replace">
                    <xsl:with-param name="hash">
                        <xsl:call-template name="hash-replace">
                            <xsl:with-param name="hash" select="';'"/>
                            <xsl:with-param name="key" select="'variables'"/>
                            <xsl:with-param name="value">
                                <xsl:text>;</xsl:text>
                                <xsl:apply-templates select="//variable"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="key" select="'context-node'"/>
                    <xsl:with-param name="value" select="'+:'"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="key" select="'namespaces'"></xsl:with-param>
            <xsl:with-param name="value">
                <xsl:call-template name="hash-replace">
                    <xsl:with-param name="hash" select="';:;'"></xsl:with-param>
                    <xsl:with-param name="key" select="'xml'"></xsl:with-param>
                    <xsl:with-param name="value" select="'http://www.w3.org/XML/1998/namespace'"></xsl:with-param>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:apply-templates select="*/test"/>
    </xsl:template>

    <xsl:template match="//test">
        <xsl:variable name="parsed">
            <xsl:call-template name="parse">
                <xsl:with-param name="start-production" select="'Expr'"/>
                <xsl:with-param name="expr" select="string(@expr)"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:message>Parsed to: <xsl:value-of select="$parsed"/></xsl:message>
  
        <xsl:variable name="result">
            <xsl:call-template name="eval">
                <xsl:with-param name="expr" select="$parsed"/>
                <xsl:with-param name="context" select="$expr-context"/>
                <xsl:with-param name="document" select="/"/>
                <xsl:with-param name="stylesheet" select="document('',/)"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:message>Evaluated to: <xsl:value-of select="$result"/></xsl:message>
        <xsl:value-of select="$result"/>
         
    </xsl:template>
</xsl:stylesheet>
