<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="lib-datatype.xsl"/>
    <xsl:import href="xpath-parser.xsl"/>
    <xsl:import href="naxos-import.xsl"/>

    <xsl:template match="node()" mode="collect-named-templates">
        <xsl:param name="import-level"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="stylesheet-relative-href"/>
        <xsl:param name="declarations"/>

        <xsl:variable name="new-declarations">
            <xsl:choose>
                <xsl:when test="self::xsl:import | self::xsl:include">

                    <!-- Imported stylesheet. -->

                    <xsl:variable name="new-stylesheet-relative-href">
                        <!-- to do: proper href resolution -->
                        <xsl:value-of select="string(@href)"/>
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
                            <xsl:apply-templates select="$new-stylesheet/xsl:stylesheet/node()[1]"
                                mode="collect-named-templates">
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
                <xsl:when test="self::xsl:template[not(@name) and not(@match)]">
                    <xsl:message terminate="yes">
                        <xsl:text>Template with neither match or name</xsl:text>
                    </xsl:message>
                </xsl:when>
                <xsl:when test="self::xsl:template[@name]">

                    <!-- Template declaration -->

                    <xsl:variable name="template-name-encoded">
                        <xsl:choose>
                            <xsl:when test="contains(string(self::*/@name), ':')">
                                <xsl:variable name="namespace-encoded">
                                    <xsl:call-template name="encode">
                                        <xsl:with-param name="expr"
                                            select="namespace::*[local-name() = substring-before(string(current()/@name), ':')]"
                                        />
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:value-of
                                    select="concat('{', $namespace-encoded, '}', substring-after(string(self::*/@name), ':'))"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="concat('{}', string(self::*/@name))"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    
                    <xsl:variable name="stylesheet-relative-href-encoded">
                        <xsl:call-template name="encode">
                            <xsl:with-param name="expr" select="$stylesheet-relative-href"/>
                        </xsl:call-template>
                    </xsl:variable>

                    <xsl:variable name="all-imports">
                        <xsl:call-template name="count-imports">
                            <xsl:with-param name="node" select="$stylesheet"></xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    
                    <xsl:value-of
                        select="concat(';', $template-name-encoded, ':', $import-level + $all-imports, ':', $stylesheet-relative-href-encoded, ':', generate-id(.), $declarations)"
                    />
                    
                </xsl:when>
                <xsl:otherwise>

                    <!-- Everything else. -->

                    <xsl:value-of select="$declarations"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="following-sibling::node()">
                <xsl:apply-templates select="following-sibling::node()[1]" mode="collect-named-templates">
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

    <xsl:template name="filter-overridden-named-template-declarations">
        <xsl:param name="expr"/>
        
        <xsl:choose>
            <xsl:when test="contains($expr, ';')">
                <xsl:variable name="check">
                    <xsl:call-template name="last-item">
                        <xsl:with-param name="expr" select="$expr"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="check-template" select="substring-before($check, ':')"></xsl:variable>
                <xsl:variable name="overridden">
                    <xsl:call-template name="check-named-template-override">
                        <xsl:with-param name="check-template" select="$check-template"/>
                        <xsl:with-param name="check-import-level"
                            select="substring-before(substring-after($check, ':'), ':')"/>
                        <xsl:with-param name="candidates"
                            select="concat(substring($expr, 1, string-length($expr) - string-length($check) - 1), '')"
                        />
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$overridden != 0">
                        <xsl:call-template name="filter-overridden-named-template-declarations">
                            <xsl:with-param name="expr"
                                select="substring($expr, 1, string-length($expr) - string-length($check) - 1)"
                            />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="template-node" select="substring-after(substring-after($check, ':'), ':')"></xsl:variable>
                        <xsl:call-template name="hash-replace">
                            <xsl:with-param name="hash">
                                <xsl:call-template name="filter-overridden-named-template-declarations">
                                    <xsl:with-param name="expr"
                                        select="substring($expr, 1, string-length($expr) - string-length($check) - 1)"
                                    />
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="key" select="$check-template"></xsl:with-param>
                            <xsl:with-param name="value" select="$template-node"></xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of
                    select="';'"
                />
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="check-named-template-override">
        <xsl:param name="check-template"/>
        <xsl:param name="check-import-level"/>
        <xsl:param name="candidates"/>
        
        <xsl:choose>
            <xsl:when test="string-length($candidates) = 0">
                <!-- Not overridden. -->
                <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:when
                test="starts-with($candidates, concat($check-template, ':', $check-import-level, ':'))">
                <!-- Found declaration earlier in list with same import level.  Raise error. -->
                <xsl:message terminate="yes">
                    <xsl:text>Two variable declarations found at same import level for </xsl:text>
                    <xsl:value-of select="$check-template"/>
                </xsl:message>
            </xsl:when>
            <xsl:when test="starts-with($candidates, concat($check-template, ':'))">
                <!-- Found override earlier in list. -->
                <xsl:value-of select="1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="check-named-template-override">
                    <xsl:with-param name="check-template" select="$check-template"/>
                    <xsl:with-param name="check-import-level" select="$check-import-level"/>
                    <xsl:with-param name="candidates" select="substring-after($candidates, ';')"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    

</xsl:stylesheet>
