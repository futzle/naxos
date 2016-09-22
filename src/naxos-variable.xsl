<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="lib-datatype.xsl"/>
    <xsl:import href="xpath-parser.xsl"/>
    <xsl:import href="naxos-import.xsl"/>

    <xsl:template match="node()" mode="collect-global-variables">
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
                                mode="collect-global-variables">
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
                <xsl:when test="self::xsl:variable or self::xsl:param">

                    <!-- Variable declaration. -->

                    <xsl:variable name="variable-name-encoded">
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
                        select="concat(';', $variable-name-encoded, ':', $import-level + $all-imports, ':', $stylesheet-relative-href-encoded, ':', generate-id(.), $declarations)"
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
                <xsl:apply-templates select="following-sibling::node()[1]"
                    mode="collect-global-variables">
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

    <xsl:template name="filter-overridden-variable-declarations">
        <xsl:param name="expr"/>

        <xsl:choose>
            <xsl:when test="contains($expr, ';')">
                <xsl:variable name="check">
                    <xsl:call-template name="last-item">
                        <xsl:with-param name="expr" select="$expr"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="overridden">
                    <xsl:call-template name="check-variable-override">
                        <xsl:with-param name="check-variable" select="substring-before($check, ':')"/>
                        <xsl:with-param name="check-import-level"
                            select="substring-before(substring-after($check, ':'), ':')"/>
                        <xsl:with-param name="candidates"
                            select="concat(substring($expr, 1, string-length($expr) - string-length($check) - 1), ';')"
                        />
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$overridden != 0">
                        <xsl:call-template name="filter-overridden-variable-declarations">
                            <xsl:with-param name="expr"
                                select="substring($expr, 1, string-length($expr) - string-length($check) - 1)"
                            />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="remainder">
                            <xsl:call-template name="filter-overridden-variable-declarations">
                                <xsl:with-param name="expr"
                                    select="substring($expr, 1, string-length($expr) - string-length($check) - 1)"
                                />
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of
                            select="concat($remainder, ';', substring-before($check, ':'), ':', substring-after(substring-after($check, ':'), ':'))"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- Last variable can't be overridden. (What would override it?) -->
                <xsl:value-of
                    select="concat(substring-before($expr, ':'), ':', substring-after(substring-after($expr, ':'), ':'))"
                />
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="check-variable-override">
        <xsl:param name="check-variable"/>
        <xsl:param name="check-import-level"/>
        <xsl:param name="candidates"/>

        <xsl:choose>
            <xsl:when test="string-length($candidates) = 0">
                <!-- Not overridden. -->
                <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:when
                test="starts-with($candidates, concat($check-variable, ':', $check-import-level, ':'))">
                <!-- Found declaration earlier in list with same import level.  Raise error. -->
                <xsl:message terminate="yes">
                    <xsl:text>Two variable declarations found at same import level for </xsl:text>
                    <xsl:value-of select="$check-variable"/>
                </xsl:message>
            </xsl:when>
            <xsl:when test="starts-with($candidates, concat($check-variable, ':'))">
                <!-- Found override earlier in list. -->
                <xsl:value-of select="1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="check-variable-override">
                    <xsl:with-param name="check-variable" select="$check-variable"/>
                    <xsl:with-param name="check-import-level" select="$check-import-level"/>
                    <xsl:with-param name="candidates" select="substring-after($candidates, ';')"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="eval-global-variables">
        <xsl:param name="global-variable-declarations"/>
        <xsl:param name="deferred-variable-declarations"/>
        <xsl:param name="global-variable-values" select="';'"/>
        <xsl:param name="progress" select="0"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="contains($global-variable-declarations, ';')">
                <xsl:variable name="first"
                    select="substring-before($global-variable-declarations, ';')"/>
                <xsl:variable name="remainder"
                    select="substring-after($global-variable-declarations, ';')"/>

                <xsl:variable name="first-varname" select="substring-before($first, ':')"/>
                <xsl:variable name="first-href"
                    select="substring-before(substring-after($first, ':'), ':')"/>
                <xsl:variable name="first-id"
                    select="substring-after(substring-after($first, ':'), ':')"/>
                <xsl:variable name="first-nodeset"
                    select="document($first-href, $stylesheet)//*[generate-id() = $first-id]"/>

                <xsl:variable name="first-undefined-variables">
                    <xsl:call-template name="count-undefined-variables">
                        <xsl:with-param name="declaration" select="$first-nodeset"/>
                        <xsl:with-param name="global-variable-values"
                            select="$global-variable-values"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:choose>
                    <xsl:when test="$first-undefined-variables = 0">
                        <!-- Can evaluate this variable. -->
                        <xsl:message>
                            <xsl:text>Evaluating variable </xsl:text>
                            <xsl:value-of select="$first-varname"/>
                        </xsl:message>
                        <xsl:variable name="first-result">
                            <xsl:choose>
                                <xsl:when test="$first-nodeset/@select">
                                    <xsl:variable name="first-parsed">
                                        <xsl:call-template name="parse">
                                            <xsl:with-param name="start-production" select="'Expr'"/>
                                            <xsl:with-param name="expr"
                                                select="string($first-nodeset/@select)"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:call-template name="eval">
                                        <xsl:with-param name="expr" select="$first-parsed"/>
                                        <xsl:with-param name="context">
                                            <xsl:call-template name="hash-replace">
                                                <xsl:with-param name="hash">
                                                  <xsl:call-template name="hash-replace">
                                                  <xsl:with-param name="hash">
                                                  <xsl:call-template name="hash-replace">
                                                  <xsl:with-param name="hash"
                                                  select="';'"/>
                                                  <xsl:with-param name="key"
                                                  select="'variables'"/>
                                                  <xsl:with-param name="value"
                                                  select="$global-variable-values"
                                                  />
                                                  </xsl:call-template>
                                                  </xsl:with-param>
                                                  <xsl:with-param name="key"
                                                  select="'context-node'"/>
                                                  <xsl:with-param name="value" select="'+:'"/>
                                                  </xsl:call-template>
                                                </xsl:with-param>
                                                <xsl:with-param name="key" select="'namespaces'"/>
                                                <xsl:with-param name="value">
                                                  <xsl:call-template name="hash-replace">
                                                  <xsl:with-param name="hash" select="';:;'"/>
                                                  <xsl:with-param name="key" select="'xml'"/>
                                                  <xsl:with-param name="value"
                                                  select="'http://www.w3.org/XML/1998/namespace'"
                                                  />
                                                  </xsl:call-template>
                                                </xsl:with-param>
                                            </xsl:call-template>
                                        </xsl:with-param>
                                        <xsl:with-param name="document" select="$document"/>
                                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- to do: variable with children -->
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:call-template name="eval-global-variables">
                            <xsl:with-param name="global-variable-declarations" select="$remainder"/>
                            <xsl:with-param name="deferred-variable-declarations"
                                select="$deferred-variable-declarations"/>
                            <xsl:with-param name="global-variable-values">
                                <xsl:call-template name="hash-replace">
                                    <xsl:with-param name="hash" select="$global-variable-values"/>
                                    <xsl:with-param name="key" select="$first-varname"/>
                                    <xsl:with-param name="value" select="$first-result"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="progress" select="1"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="eval-global-variables">
                            <xsl:with-param name="global-variable-declarations" select="$remainder"/>
                            <xsl:with-param name="deferred-variable-declarations"
                                select="concat($deferred-variable-declarations, $first, ';')"/>
                            <xsl:with-param name="global-variable-values"
                                select="$global-variable-values"/>
                            <xsl:with-param name="progress" select="$progress"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="string-length($deferred-variable-declarations) = 0">
                <xsl:value-of select="$global-variable-values"/>
            </xsl:when>
            <xsl:when test="$progress">
                <xsl:call-template name="eval-global-variables">
                    <xsl:with-param name="global-variable-declarations"
                        select="$deferred-variable-declarations"/>
                    <xsl:with-param name="global-variable-values" select="$global-variable-values"/>
                    <xsl:with-param name="progress" select="0"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    <xsl:text>Circular definition of global variables: </xsl:text>
                    <xsl:value-of select="$deferred-variable-declarations"/>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="count-undefined-variables">
        <xsl:param name="declaration"/>
        <xsl:param name="global-variable-values"/>

        <xsl:choose>
            <xsl:when test="$declaration/@select">
                <xsl:variable name="xpath">
                    <xsl:call-template name="parse">
                        <xsl:with-param name="start-production" select="'Expr'"/>
                        <xsl:with-param name="expr" select="string($declaration/@select)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="eval-variable-count">
                    <xsl:with-param name="expr" select="$xpath"/>
                    <xsl:with-param name="node" select="$declaration"></xsl:with-param>
                    <xsl:with-param name="defined-variables" select="$global-variable-values"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- to do -->
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="eval-variable-count">
        <xsl:param name="expr"/>
        <xsl:param name="node"></xsl:param>
        <xsl:param name="defined-variables"/>

        <xsl:choose>
            <xsl:when test="substring-before($expr, ':') = 'VariableReference'">
                <xsl:variable name="literal-plus-qname">
                    <xsl:call-template name="decode">
                        <xsl:with-param name="expr" select="substring-after(substring-after($expr, ':'), ':')"></xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="qname" select="substring-after($literal-plus-qname, ';')"></xsl:variable>
                <xsl:variable name="name">
                    <xsl:call-template name="eval">
                        <xsl:with-param name="expr" select="$qname"/>
                        <xsl:with-param name="context">
                            <xsl:call-template name="hash-replace">
                                <xsl:with-param name="hash" select="';'"></xsl:with-param>
                                <xsl:with-param name="key" select="namespaces"></xsl:with-param>
                                <xsl:with-param name="value">
                                    <xsl:call-template name="namespaces-of-node">
                                        <xsl:with-param name="node" select="$node"></xsl:with-param>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="document" select="/.."/>
                        <xsl:with-param name="stylesheet" select="/.."/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="contains($defined-variables, concat(';', $name, ':'))">
                        <xsl:value-of select="0"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="1"/>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="argument">
                    <xsl:call-template name="decode">
                        <xsl:with-param name="expr"
                            select="substring-after(substring-after(string($expr), ':'), ':')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="string-length($argument) = 0">
                        <xsl:value-of select="0"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="eval-variable-count-repeat">
                            <xsl:with-param name="expr" select="$argument"/>
                            <xsl:with-param name="node" select="$node"></xsl:with-param>
                            <xsl:with-param name="defined-variables" select="$defined-variables"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="eval-variable-count-repeat">
        <xsl:param name="expr"/>
        <xsl:param name="node"></xsl:param>
        <xsl:param name="defined-variables"/>

        <xsl:choose>
            <xsl:when test="contains($expr, ';')">
                <xsl:variable name="lhs">
                    <xsl:call-template name="eval-variable-count">
                        <xsl:with-param name="expr" select="substring-before($expr, ';')"/>
                        <xsl:with-param name="node" select="$node"></xsl:with-param>
                        <xsl:with-param name="defined-variables" select="$defined-variables"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="rhs">
                    <xsl:call-template name="eval-variable-count-repeat">
                        <xsl:with-param name="expr" select="substring-after($expr, ';')"/>
                        <xsl:with-param name="node" select="$node"></xsl:with-param>
                        <xsl:with-param name="defined-variables" select="$defined-variables"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$lhs + $rhs"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="eval-variable-count">
                    <xsl:with-param name="expr" select="$expr"/>
                    <xsl:with-param name="node" select="$node"></xsl:with-param>
                    <xsl:with-param name="defined-variables" select="$defined-variables"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

</xsl:stylesheet>
