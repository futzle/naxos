<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="lib-datatype.xsl"/>
    <xsl:import href="xpath-parser.xsl"/>
    <xsl:import href="naxos-import.xsl"/>

    <xsl:template match="node()" mode="collect-patterned-templates">
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
                            <xsl:with-param name="node" select="."/>
                        </xsl:call-template>
                    </xsl:variable>

                    <xsl:choose>
                        <xsl:when test="$new-stylesheet/xsl:stylesheet">
                            <xsl:apply-templates select="$new-stylesheet/xsl:stylesheet/node()[1]"
                                mode="collect-patterned-templates">
                                <xsl:with-param name="import-level"
                                    select="$import-level + $previous-imports"/>
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
                <xsl:when test="self::xsl:template[@match]">

                    <!-- Template declaration -->

                    <xsl:variable name="stylesheet-relative-href-encoded">
                        <xsl:call-template name="encode">
                            <xsl:with-param name="expr" select="$stylesheet-relative-href"/>
                        </xsl:call-template>
                    </xsl:variable>

                    <xsl:variable name="template-encoded">
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

                        <xsl:variable name="all-imports">
                            <xsl:call-template name="count-imports">
                                <xsl:with-param name="node" select="$stylesheet"/>
                            </xsl:call-template>
                        </xsl:variable>

                        <xsl:call-template name="template-declaration-alternations">
                            <xsl:with-param name="expr" select="$match-pattern-alternations"/>
                            <xsl:with-param name="import-level"
                                select="$import-level + $all-imports"/>
                            <xsl:with-param name="stylesheet-relative-href-encoded"
                                select="$stylesheet-relative-href-encoded"/>
                        </xsl:call-template>
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
                <xsl:apply-templates select="following-sibling::node()[1]"
                    mode="collect-patterned-templates">
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

            <xsl:text>mode:</xsl:text>
            <xsl:call-template name="encode">
                <xsl:with-param name="expr">
                    <xsl:choose>
                        <xsl:when test="not(@mode)"><xsl:value-of select="'-'"/></xsl:when>
                        <xsl:when
                            test="contains(@mode, ':') and not(namespace::*[local-name() = substring-before(current()/@mode, ':')])">
                            <xsl:message terminate="yes">
                                <xsl:text>Mode declared with unknown namespace</xsl:text>
                            </xsl:message>
                        </xsl:when>
                        <xsl:when test="contains(@mode, ':')">
                            <xsl:value-of
                                select="concat('{', string(namespace::*[local-name() = substring-before(current()/@mode, ':')]),
                            '}', substring-after(@mode, ':'))"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat('{}', @mode)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:text>;</xsl:text>

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

</xsl:stylesheet>
