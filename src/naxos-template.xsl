<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="lib-datatype.xsl"/>
    <xsl:import href="xpath-parser.xsl"/>

    <xsl:template match="node()" mode="collect-templates">
        <xsl:param name="import-level"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="stylesheet-relative-href"/>
        <xsl:param name="declarations"/>

        <xsl:variable name="new-declarations">
            <xsl:choose>
                <xsl:when test="self::xsl:import">

                    <!-- Imported stylesheet. -->

                    <xsl:variable name="new-stylesheet-relative-href">
                        <!-- to do: proper href resolution -->
                        <xsl:value-of select="string(@href)"/>
                    </xsl:variable>

                    <xsl:variable name="new-stylesheet"
                        select="document($new-stylesheet-relative-href, $stylesheet)"/>

                    <xsl:choose>
                        <xsl:when test="$new-stylesheet/xsl:stylesheet">
                            <xsl:apply-templates select="$new-stylesheet/xsl:stylesheet/node()[1]"
                                mode="collect-templates">
                                <xsl:with-param name="import-level" select="$import-level + 1"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
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
                <xsl:when test="self::xsl:template">

                    <!-- Template declaration -->

                    <xsl:variable name="stylesheet-relative-href-encoded">
                        <xsl:call-template name="encode">
                            <xsl:with-param name="expr" select="$stylesheet-relative-href"/>
                        </xsl:call-template>
                    </xsl:variable>

                    <xsl:variable name="template-encoded">
                        <xsl:choose>
                            <xsl:when test="@match">
                                <xsl:variable name="match-pattern">
                                    <xsl:call-template name="parse">
                                        <xsl:with-param name="start-production" select="'Pattern'"/>
                                        <xsl:with-param name="expr" select="string(@match)"/>
                                    </xsl:call-template>
                                </xsl:variable>

                                <xsl:if test="$match-pattern = '-'">
                                    <xsl:message terminate="yes">
                                        <xsl:text>Could not parse pattern </xsl:text>
                                        <xsl:value-of select="@match"/>
                                    </xsl:message>
                                </xsl:if>

                                <xsl:variable name="match-pattern-alternations">
                                    <xsl:call-template name="decode">
                                        <xsl:with-param name="expr"
                                            select="substring-after(substring-after($match-pattern, ':'), ':')"
                                        />
                                    </xsl:call-template>
                                </xsl:variable>
                                <xsl:call-template name="template-declaration-alternations">
                                    <xsl:with-param name="expr" select="$match-pattern-alternations"/>
                                    <xsl:with-param name="import-level" select="$import-level"/>
                                    <xsl:with-param name="stylesheet-relative-href-encoded"
                                        select="$stylesheet-relative-href-encoded"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="not(@name)">
                                    <xsl:message terminate="yes">
                                        <xsl:text>Template with neither match nor name</xsl:text>
                                    </xsl:message>
                                </xsl:if>
                                <xsl:call-template name="encode">
                                    <xsl:with-param name="expr">
                                        <xsl:call-template name="template-declaration">
                                            <xsl:with-param name="import-level"
                                                select="$import-level"/>
                                            <xsl:with-param name="stylesheet-relative-href-encoded"
                                                select="$stylesheet-relative-href-encoded"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:value-of select="concat($template-encoded,';', $declarations)"/>
                </xsl:when>
                <xsl:otherwise>

                    <!-- Everything else. -->

                    <xsl:value-of select="$declarations"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="following-sibling::node()">
                <xsl:apply-templates select="following-sibling::node()[1]" mode="collect-templates">
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

    <xsl:template name="template-declaration-alternations">
        <xsl:param name="expr"/>
        <xsl:param name="import-level"/>
        <xsl:param name="stylesheet-relative-href-encoded"/>

        <xsl:choose>
            <xsl:when test="contains($expr, ';')">
                <xsl:variable name="first" select="substring-before($expr, ';')"/>
                <xsl:variable name="first-encoded">
                    <xsl:call-template name="encode">
                        <xsl:with-param name="expr">
                            <xsl:call-template name="template-declaration">
                                <xsl:with-param name="parsed-pattern" select="$first"/>
                                <xsl:with-param name="import-level" select="$import-level"/>
                                <xsl:with-param name="stylesheet-relative-href-encoded"
                                    select="$stylesheet-relative-href-encoded"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="remainder">
                    <xsl:call-template name="template-declaration-alternations">
                        <xsl:with-param name="expr"
                            select="substring-after(substring-after($expr, ';'), ';')"/>
                        <xsl:with-param name="import-level" select="$import-level"/>
                        <xsl:with-param name="stylesheet-relative-href-encoded"
                            select="$stylesheet-relative-href-encoded"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="string-length($remainder)">
                        <xsl:value-of select="concat($first-encoded, ';', $remainder)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$first-encoded"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="template-declaration">
        <xsl:param name="parsed-pattern"/>
        <xsl:param name="import-level"/>
        <xsl:param name="stylesheet-relative-href-encoded"/>

        <xsl:value-of select="';'"/>
        <xsl:if test="@name">
            <xsl:text>name:</xsl:text>
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
                        select="concat('{', namespace::*[local-name() = ''], '}', string(self::*/@name))"
                    />
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>;</xsl:text>
        </xsl:if>

        <xsl:if test="@match">
            <xsl:text>match:</xsl:text>
            <xsl:call-template name="encode">
                <xsl:with-param name="expr" select="$parsed-pattern"/>
            </xsl:call-template>
            <xsl:text>;</xsl:text>

            <xsl:choose>
                <xsl:when test="@priority">
                    <xsl:text>priority:</xsl:text>
                    <xsl:value-of select="@priority"/>
                    <xsl:text>;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>priority:</xsl:text>
                    <xsl:call-template name="pattern-default-priority">
                        <xsl:with-param name="expr" select="$parsed-pattern"/>
                    </xsl:call-template>
                    <xsl:text>;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:if>

        <xsl:if test="@mode">
            <xsl:text>mode:</xsl:text>
            <xsl:value-of select="@mode"/>
            <xsl:text>;</xsl:text>
        </xsl:if>


        <xsl:value-of select="concat('import-level:', $import-level, ';')"/>
        <xsl:value-of select="concat('href-encoded:', $stylesheet-relative-href-encoded, ';')"/>
        <xsl:value-of select="concat('id:', generate-id(.), ';')"/>

    </xsl:template>

    <xsl:template name="pattern-default-priority">
        <xsl:param name="expr"/>

        <xsl:variable name="alternation" select="substring-before(substring-after($expr, ':'), ':')"/>
        <xsl:choose>
            <xsl:when test="$alternation = 'Relative'">
                <xsl:call-template name="pattern-default-priority-relative">
                    <xsl:with-param name="expr">
                        <xsl:call-template name="decode">
                            <xsl:with-param name="expr"
                                select="substring-after(substring-after($expr, ':'), ':')"/>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="0.5"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="pattern-default-priority-relative">
        <xsl:param name="expr"/>

        <xsl:param name="argument">
            <xsl:call-template name="decode">
                <xsl:with-param name="expr"
                    select="substring-after(substring-after($expr, ':'), ':')"/>
            </xsl:call-template>
        </xsl:param>
        <xsl:choose>
            <xsl:when test="contains(substring-after($argument, ';'), ';')">
                <xsl:value-of select="0.5"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="pattern-default-priority-step">
                    <xsl:with-param name="expr" select="substring-before($argument, ';')"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="pattern-default-priority-step">
        <xsl:param name="expr"/>

        <xsl:param name="argument">
            <xsl:call-template name="decode">
                <xsl:with-param name="expr"
                    select="substring-after(substring-after($expr, ':'), ':')"/>
            </xsl:call-template>
        </xsl:param>
        <xsl:choose>
            <xsl:when test="substring-after(substring-after($argument, ';'), ';') = ''">
                <xsl:call-template name="pattern-default-priority-nodetest">
                    <xsl:with-param name="expr"
                        select="substring-before(substring-after($argument, ';'), ';')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="0.5"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="pattern-default-priority-nodetest">
        <xsl:param name="expr"/>

        <xsl:variable name="alternation" select="substring-before(substring-after($expr, ':'), ':')"/>

        <xsl:choose>
            <xsl:when test="$alternation = 'ProcessingInstructionLiteral'">
                <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:when test="$alternation = 'QName'">
                <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:when test="$alternation = 'AnyNS'">
                <xsl:value-of select="-0.25"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="-0.5"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="filter-overridden-named-template-declarations">
        <xsl:param name="expr"/>

        <xsl:choose>
            <xsl:when test="contains($expr, ';')">
                <xsl:variable name="last-item">
                    <xsl:call-template name="last-item">
                        <xsl:with-param name="expr" select="$expr"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="check">
                    <xsl:call-template name="decode">
                        <xsl:with-param name="expr" select="$last-item"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="check-name">
                    <xsl:call-template name="hash-lookup">
                        <xsl:with-param name="hash" select="$check"/>
                        <xsl:with-param name="key" select="'name'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="overridden">
                    <xsl:choose>
                        <xsl:when test="$check-name = '-'">
                            <!-- Unnamed templates are omitted from this list. -->
                            <xsl:value-of select="1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="check-named-template-override">
                                <xsl:with-param name="check-name" select="$check-name"/>
                                <xsl:with-param name="check-import-level">
                                    <xsl:call-template name="hash-lookup">
                                        <xsl:with-param name="hash" select="$check"/>
                                        <xsl:with-param name="key" select="name"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="candidates"
                                    select="concat(substring($expr, 1, string-length($expr) - string-length($last-item) - 1), ';')"
                                />
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$overridden != 0">
                        <xsl:call-template name="filter-overridden-named-template-declarations">
                            <xsl:with-param name="expr"
                                select="substring($expr, 1, string-length($expr) - string-length($last-item) - 1)"
                            />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="template-node">
                            <xsl:call-template name="hash-replace">
                                <xsl:with-param name="hash">
                                    <xsl:call-template name="hash-replace">
                                        <xsl:with-param name="hash" select="';'"/>
                                        <xsl:with-param name="key" select="'href-encoded'"/>
                                        <xsl:with-param name="value">
                                            <xsl:call-template name="hash-lookup">
                                                <xsl:with-param name="hash" select="$check"/>
                                                <xsl:with-param name="key" select="'href-encoded'"/>
                                            </xsl:call-template>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="key" select="'id'"/>
                                <xsl:with-param name="value">
                                    <xsl:call-template name="hash-lookup">
                                        <xsl:with-param name="hash" select="$check"/>
                                        <xsl:with-param name="key" select="'id'"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:call-template name="hash-replace">
                            <xsl:with-param name="hash">
                                <xsl:call-template
                                    name="filter-overridden-named-template-declarations">
                                    <xsl:with-param name="expr"
                                        select="substring($expr, 1, string-length($expr) - string-length($last-item) - 1)"
                                    />
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="key" select="'name'"/>
                            <xsl:with-param name="value" select="$template-node"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- Last variable can't be overridden. (What would override it?) -->
                <xsl:value-of select="$expr"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="check-named-template-override">0</xsl:template>

</xsl:stylesheet>
