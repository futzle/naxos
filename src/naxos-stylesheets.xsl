<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:import href="lib-datatype.xsl"/>
    <xsl:import href="naxos-import.xsl"/>
    
    <xsl:template match="node()" mode="collect-stylesheets">
        <xsl:param name="import-level"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="stylesheet-relative-href"/>
        <xsl:param name="declarations"/>
        
        <xsl:variable name="new-declarations">
            <xsl:choose>
                <xsl:when test="self::xsl:import | self::xsl:include">
                    
                    <!-- Imported stylesheet. -->
                    
                    <xsl:variable name="new-stylesheet-relative-href">
                        <xsl:call-template name="resolve-href">
                            <xsl:with-param name="base" select="$stylesheet-relative-href"></xsl:with-param>
                            <xsl:with-param name="href" select="@href"></xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <xsl:variable name="new-stylesheet"
                        select="document($new-stylesheet-relative-href, $stylesheet)"/>
                    
                    <xsl:variable name="previous-imports">
                        <xsl:call-template name="count-previous-imports">
                            <xsl:with-param name="node" select="."></xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <xsl:choose>
                        <xsl:when test="$new-stylesheet/xsl:stylesheet">
                            
                            <xsl:value-of select="generate-id()"/>
                            <xsl:text>:</xsl:text>
                            <xsl:call-template name="encode">
                                <xsl:with-param name="expr" select="$new-stylesheet-relative-href"></xsl:with-param>
                            </xsl:call-template>
                            
                            <xsl:apply-templates select="$new-stylesheet/xsl:stylesheet/node()[1]"
                                mode="collect-stylesheets">
                                <xsl:with-param name="import-level" select="$import-level + $previous-imports"/>
                                <xsl:with-param name="stylesheet" select="$new-stylesheet"/>
                                <xsl:with-param name="stylesheet-relative-href"
                                    select="$new-stylesheet-relative-href"/>
                                <xsl:with-param name="declarations" select="$declarations"/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:message terminate="yes">
                                <xsl:text>Imported file is not a stylesheet</xsl:text>
                            </xsl:message>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    
                    <!-- Everything else. -->
                    
                    <xsl:value-of select="$declarations"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="following-sibling::node()">
                <xsl:apply-templates select="following-sibling::node()[1]" mode="collect-stylesheets">
                    <xsl:with-param name="import-level" select="$import-level"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="stylesheet-relative-href"
                        select="$stylesheet-relative-href"/>
                    <xsl:with-param name="declarations" select="$new-declarations"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$declarations"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
