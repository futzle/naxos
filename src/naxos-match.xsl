<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:nodeset-get-namespaces="http://futzle.com/2006/xslt-interpreter/nodeset-get-namespaces"
    exclude-result-prefixes="nodeset-get-namespaces">

    <xsl:import href="lib-datatype.xsl"/>
    <xsl:import href="xpath-parser.xsl"/>

    <xsl:template name="find-template-to-apply">
        <xsl:param name="stylesheet"/>
        <xsl:param name="document"/>
        <xsl:param name="current-node"/>
        <xsl:param name="match-node" select="$current-node"/>
        <xsl:param name="mode"/>
        <xsl:param name="patterned-templates"/>
        <xsl:param name="matching-templates" select="''"/>
        <xsl:param name="applied-from-import"/>

        <xsl:choose>
            <xsl:when test="$match-node = '-'">
                <xsl:call-template name="resolve-template-conflict">
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="matching-templates" select="$matching-templates"/>
                    <xsl:with-param name="current-node" select="$current-node"/>
                    <xsl:with-param name="mode" select="$mode"/>
                    <!-- more context -->
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="new-matching-templates">
                    <xsl:call-template name="search-templates-for-match">
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="match-node" select="$match-node"/>
                        <xsl:with-param name="current-node" select="$current-node"/>
                        <xsl:with-param name="mode" select="$mode"/>
                        <xsl:with-param name="patterned-templates" select="$patterned-templates"/>
                        <xsl:with-param name="applied-from-import" select="$applied-from-import"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:call-template name="find-template-to-apply">
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="match-node">
                        <xsl:call-template name="node-parent">
                            <xsl:with-param name="node" select="$match-node"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="current-node" select="$current-node"/>
                    <xsl:with-param name="mode" select="$mode"/>
                    <xsl:with-param name="matching-templates">
                        <xsl:choose>
                            <xsl:when test="$new-matching-templates = ''">
                                <xsl:value-of select="$matching-templates"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="concat($new-matching-templates, $matching-templates)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="patterned-templates" select="$patterned-templates"/>
                    <xsl:with-param name="applied-from-import" select="$applied-from-import"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="search-templates-for-match">
        <xsl:param name="stylesheet"/>
        <xsl:param name="document"/>
        <xsl:param name="match-node"/>
        <xsl:param name="current-node"/>
        <xsl:param name="search-node"/>
        <xsl:param name="mode"/>
        <xsl:param name="patterned-templates"/>
        <xsl:param name="applied-from-import"/>
        <xsl:param name="running-value" select="''"/>

        <xsl:choose>
            <xsl:when test="contains($patterned-templates, ';')">
                <xsl:variable name="first-hash">
                    <xsl:call-template name="decode">
                        <xsl:with-param name="expr"
                            select="substring-before($patterned-templates, ';')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="first-pattern">
                    <xsl:call-template name="hash-lookup">
                        <xsl:with-param name="hash" select="$first-hash"/>
                        <xsl:with-param name="key" select="'match'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="first-mode">
                    <xsl:call-template name="hash-lookup">
                        <xsl:with-param name="hash" select="$first-hash"/>
                        <xsl:with-param name="key" select="'mode'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="matched">
                    <xsl:choose>
                        <xsl:when test="$mode != $first-mode">
                            <xsl:value-of select="0"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="matched-nodeset">
                                <xsl:call-template name="eval-outermost">
                                    <xsl:with-param name="expr" select="$first-pattern"/>
                                    <xsl:with-param name="document" select="$document"/>
                                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                                    <xsl:with-param name="context">
                                        <xsl:call-template name="hash-replace">
                                            <xsl:with-param name="hash">
                                                <xsl:call-template name="hash-replace">
                                                  <xsl:with-param name="hash" select="';'"/>
                                                  <xsl:with-param name="key"
                                                  select="'current-node'"/>
                                                  <xsl:with-param name="value"
                                                  select="$match-node"/>
                                                </xsl:call-template>
                                            </xsl:with-param>
                                            <xsl:with-param name="key" select="'namespaces'"/>
                                            <xsl:with-param name="value">
                                                <xsl:call-template name="node-function">
                                                  <xsl:with-param name="path"
                                                  select="$current-node"/>
                                                  <xsl:with-param name="document"
                                                  select="$document"/>
                                                  <xsl:with-param name="stylesheet"
                                                  select="$stylesheet"/>
                                                  <xsl:with-param name="function"
                                                  select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter/nodeset-get-namespaces']"
                                                  />
                                                </xsl:call-template>
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="$matched-nodeset = 'NS:-'">
                                    <xsl:value-of select="0"/>
                                </xsl:when>
                                <xsl:when
                                    test="contains(concat(';', substring-after($matched-nodeset, ':'), ';'),
                                    concat(';', $current-node, ';'))">
                                    <xsl:value-of select="1"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="0"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="remainder">
                    <xsl:call-template name="search-templates-for-match">
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        <xsl:with-param name="match-node" select="$match-node"/>
                        <xsl:with-param name="current-node" select="$current-node"/>
                        <xsl:with-param name="mode" select="$mode"/>
                        <xsl:with-param name="patterned-templates"
                            select="substring-after($patterned-templates, ';')"/>
                        <xsl:with-param name="applied-from-import" select="$applied-from-import"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$matched != 0">
                        <xsl:variable name="first-import-level">
                            <xsl:call-template name="hash-lookup">
                                <xsl:with-param name="hash" select="$first-hash"/>
                                <xsl:with-param name="key" select="'import-level'"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="first-priority">
                            <xsl:call-template name="hash-lookup">
                                <xsl:with-param name="hash" select="$first-hash"/>
                                <xsl:with-param name="key" select="'priority'"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="first-href-encoded">
                            <xsl:call-template name="hash-lookup">
                                <xsl:with-param name="hash" select="$first-hash"/>
                                <xsl:with-param name="key" select="'href-encoded'"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="first-id">
                            <xsl:call-template name="hash-lookup">
                                <xsl:with-param name="hash" select="$first-hash"/>
                                <xsl:with-param name="key" select="'id'"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="first-info"
                            select="concat($first-import-level, ':',
                            $first-priority, ':',
                            $first-href-encoded, ':',
                            $first-id)"/>
                        <xsl:value-of select="concat($first-info, ';', $remainder)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$remainder"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="resolve-template-conflict">
        <xsl:param name="stylesheet"/>
        <xsl:param name="document"/>
        <xsl:param name="matching-templates"/>
        <xsl:param name="current-node"/>
        <xsl:param name="mode"/>
        <xsl:param name="best-template" select="'-'"/>
        <xsl:param name="best-import-level" select="'-'"/>
        <xsl:param name="best-priority" select="'-'"/>

        <xsl:choose>
            <xsl:when test="contains($matching-templates, ';')">
                <xsl:variable name="first-template"
                    select="substring-before($matching-templates, ';')"/>
                <xsl:variable name="first-import-level"
                    select="substring-before($first-template, ':')"/>
                <xsl:variable name="first-priority"
                    select="substring-before(substring-after($first-template, ':'), ':')"/>
                <xsl:choose>
                    <xsl:when test="$best-template != '-' and $best-template = substring-after(substring-after($first-template, ':'), ':')">
                        <!-- Same template can never clash. -->
                        <xsl:call-template name="resolve-template-conflict">
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="matching-templates"
                                select="substring-after($matching-templates, ';')"/>
                            <xsl:with-param name="current-node" select="$current-node"/>
                            <xsl:with-param name="mode" select="$mode"/>
                            <xsl:with-param name="best-template" select="$best-template"/>
                            <xsl:with-param name="best-import-level" select="$best-import-level"/>
                            <xsl:with-param name="best-priority" select="$best-priority"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when
                        test="($best-import-level = '-' or $first-import-level &gt; $best-import-level)
                            or ($first-import-level = $best-import-level and $best-priority = '-')
                            or ($first-import-level = $best-import-level and $first-priority &gt; $best-priority)">
                        <xsl:call-template name="resolve-template-conflict">
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="matching-templates"
                                select="substring-after($matching-templates, ';')"/>
                            <xsl:with-param name="current-node" select="$current-node"/>
                            <xsl:with-param name="mode" select="$mode"/>
                            <xsl:with-param name="best-template"
                                select="substring-after(substring-after($first-template, ':'), ':')"/>
                            <xsl:with-param name="best-import-level" select="$first-import-level"/>
                            <xsl:with-param name="best-priority" select="$first-priority"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when
                        test="$first-import-level = $best-import-level and $first-priority = $best-priority">
                        <xsl:message terminate="yes">
                            <xsl:text>More than one candidate template to match </xsl:text>
                            <xsl:value-of select="$current-node"/>
                            <xsl:text> with mode </xsl:text>
                            <xsl:value-of select="$mode"/>
                        </xsl:message>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="resolve-template-conflict">
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="matching-templates"
                                select="substring-after($matching-templates, ';')"/>
                            <xsl:with-param name="current-node" select="$current-node"/>
                            <xsl:with-param name="mode" select="$mode"/>
                            <xsl:with-param name="best-template" select="$best-template"/>
                            <xsl:with-param name="best-import-level" select="$best-import-level"/>
                            <xsl:with-param name="best-priority" select="$best-priority"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$best-template"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <nodeset-get-namespaces:function/>
    <xsl:template
        match="*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter/nodeset-get-namespaces']">
        <xsl:param name="context-node"/>
        <xsl:call-template name="namespaces-of-node">
            <xsl:with-param name="node" select="$context-node"/>
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>
