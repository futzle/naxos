<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template name="count-previous-imports">
        <xsl:param name="node" select="."></xsl:param>
        
        <xsl:variable name="total-previous-imports">
            <xsl:apply-templates select="$node/preceding-sibling::xsl:import | $node/preceding-sibling::xsl:include" mode="count-imports"></xsl:apply-templates>
        </xsl:variable>
        
        <xsl:value-of select="string-length($total-previous-imports)"/>
    </xsl:template>
    
    <xsl:template name="count-imports">
        <xsl:param name="node" select="."></xsl:param>

        <xsl:variable name="total-imports">
            <xsl:apply-templates select="$node" mode="count-imports"/>
        </xsl:variable>

        <xsl:value-of select="string-length($total-imports)"/>
    </xsl:template>

    <xsl:template match="/" mode="count-imports">
        <xsl:apply-templates select="xsl:stylesheet/xsl:import | xsl:stylesheet/xsl:include"
            mode="count-imports"/>
    </xsl:template>
    <xsl:template match="xsl:import" mode="count-imports">
        <xsl:text>.</xsl:text>
        <xsl:apply-templates select="document(@href, .)" mode="count-imports"/>
    </xsl:template>

    <xsl:template match="xsl:include" mode="count-imports">
        <xsl:apply-templates select="document(@href, .)" mode="count-imports"/>
    </xsl:template>
</xsl:stylesheet>
