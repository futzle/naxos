<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template name="encode">
        <xsl:param name="expr"/>
        <xsl:variable name="expr-munged" select="translate($expr, '%:;', '%%%')"/>
        <xsl:choose>
            <xsl:when test="not(contains($expr-munged, '%'))">
                <!-- No characters to escape. -->
                <xsl:value-of select="$expr"/>
            </xsl:when>
            <xsl:when test="starts-with($expr, '%')">
                <xsl:variable name="suffix">
                    <xsl:call-template name="encode">
                        <xsl:with-param name="expr" select="substring($expr, 2)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat('%25', string($suffix))"/>
            </xsl:when>
            <xsl:when test="starts-with($expr, ':')">
                <xsl:variable name="suffix">
                    <xsl:call-template name="encode">
                        <xsl:with-param name="expr" select="substring($expr, 2)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat('%3A', string($suffix))"/>
            </xsl:when>
            <xsl:when test="starts-with($expr, ';')">
                <xsl:variable name="suffix">
                    <xsl:call-template name="encode">
                        <xsl:with-param name="expr" select="substring($expr, 2)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat('%3B', string($suffix))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="prefix"
                    select="substring($expr, 1, string-length(substring-before($expr-munged, '%')))"/>
                <xsl:variable name="suffix">
                    <xsl:call-template name="encode">
                        <xsl:with-param name="expr"
                            select="substring($expr, string-length(substring-before($expr-munged, '%')) + 1)"
                        />
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($prefix, string($suffix))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="decode">
        <xsl:param name="expr"/>
        <xsl:choose>
            <xsl:when test="contains($expr,'%')">
                <!-- Build decoded string from parts before and after percent. -->
                <xsl:variable name="prefix" select="substring-before($expr, '%')"/>
                <xsl:variable name="infix">
                    <xsl:choose>
                        <xsl:when test="substring(substring-after($expr, '%'), 1, 2) = '25'">
                            <xsl:value-of select="'%'"/>
                        </xsl:when>
                        <xsl:when test="substring(substring-after($expr, '%'), 1, 2) = '3A'">
                            <xsl:value-of select="':'"/>
                        </xsl:when>
                        <xsl:when test="substring(substring-after($expr, '%'), 1, 2) = '3B'">
                            <xsl:value-of select="';'"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="suffix">
                    <xsl:call-template name="decode">
                        <xsl:with-param name="expr"
                            select="substring(substring-after($expr, '%'), 3)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($prefix, string($infix), string($suffix))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$expr"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="escape-xml">
        <xsl:param name="expr"/>
        <xsl:variable name="expr-munged" select="translate($expr, concat('&lt;&gt;&amp;&quot;',&quot;'&quot;), '&amp;&amp;&amp;&amp;&amp;')"/>
        <xsl:choose>
            <xsl:when test="not(contains($expr-munged, '&amp;'))">
                <!-- No characters to escape. -->
                <xsl:value-of select="$expr"/>
            </xsl:when>
            <xsl:when test="starts-with($expr, '&amp;')">
                <xsl:variable name="suffix">
                    <xsl:call-template name="escape-xml">
                        <xsl:with-param name="expr" select="substring($expr, 2)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat('&amp;amp;', string($suffix))"/>
            </xsl:when>
            <xsl:when test="starts-with($expr, '&lt;')">
                <xsl:variable name="suffix">
                    <xsl:call-template name="escape-xml">
                        <xsl:with-param name="expr" select="substring($expr, 2)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat('&amp;lt;', string($suffix))"/>
            </xsl:when>
            <xsl:when test="starts-with($expr, '&gt;')">
                <xsl:variable name="suffix">
                    <xsl:call-template name="escape-xml">
                        <xsl:with-param name="expr" select="substring($expr, 2)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat('&amp;gt;', string($suffix))"/>
            </xsl:when>
            <xsl:when test="starts-with($expr, '&quot;')">
                <xsl:variable name="suffix">
                    <xsl:call-template name="escape-xml">
                        <xsl:with-param name="expr" select="substring($expr, 2)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat('&amp;quot;', string($suffix))"/>
            </xsl:when>
            <xsl:when test="starts-with($expr, &quot;'&quot;)">
                <xsl:variable name="suffix">
                    <xsl:call-template name="escape-xml">
                        <xsl:with-param name="expr" select="substring($expr, 2)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat('&amp;apos;', string($suffix))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="prefix"
                    select="substring($expr, 1, string-length(substring-before($expr-munged, '&amp;')))"/>
                <xsl:variable name="suffix">
                    <xsl:call-template name="escape-xml">
                        <xsl:with-param name="expr"
                            select="substring($expr, string-length(substring-before($expr-munged, '&amp;')) + 1)"
                        />
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($prefix, string($suffix))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
