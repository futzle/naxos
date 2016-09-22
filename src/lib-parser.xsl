<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:include href="encoding.xsl"/>

    <!-- Set these in the importing stylesheet. -->
    <xsl:param name="grammar-document"/>
    <xsl:param name="grammar-namespace-prefix"/>
    
    <!-- Entry point. -->
    <xsl:template name="parse">
        <xsl:param name="expr"/>
        <xsl:param name="start-production"/>
        <!-- <xsl:message>Parsing <xsl:value-of select="$expr"/></xsl:message> -->
        <xsl:variable name="result">
            <xsl:call-template name="production">
                <xsl:with-param name="expr" select="$expr"/>
                <xsl:with-param name="index" select="1"/>
                <xsl:with-param name="rule" select="$start-production"/>
            </xsl:call-template>
        </xsl:variable>
        <!-- Any garbage at end? -->
        <xsl:choose>
            <xsl:when
                test="string-length(normalize-space(substring($expr, number(substring-before($result, ';'))))) = 0">
                <xsl:value-of select="substring-after($result, ';')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'-'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="production">
        <xsl:param name="expr"/>
        <xsl:param name="index"/>
        <xsl:param name="rule"/>
        <xsl:param name="alternation" select="1"/>
        <!--<xsl:message>Trying production <xsl:value-of select="$rule"/></xsl:message>-->
        <xsl:choose>
            <xsl:when
                test="$alternation &gt;
                count($grammar-document/xsl:stylesheet/*[local-name() = 'rule'][namespace-uri() = concat($grammar-namespace-prefix, $rule)]
                    /sequence)">
                <!-- Failed. -->
                <xsl:value-of select="'-'"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- Try this alternation. -->
                <xsl:variable name="alternation-result">
                    <xsl:call-template name="production-alternation">
                        <xsl:with-param name="expr" select="$expr"/>
                        <xsl:with-param name="index" select="$index"/>
                        <xsl:with-param name="rule" select="$rule"/>
                        <xsl:with-param name="alternation" select="$alternation"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <!-- So, how'd it go? -->
                    <xsl:when test="$alternation-result = '-'">
                        <!-- Nope, try the next one. -->
                        <xsl:call-template name="production">
                            <xsl:with-param name="expr" select="$expr"/>
                            <xsl:with-param name="index" select="$index"/>
                            <xsl:with-param name="rule" select="$rule"/>
                            <xsl:with-param name="alternation" select="$alternation + 1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- This alternation succeeded; return it. -->
                        <xsl:value-of select="$alternation-result"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="production-alternation">
        <xsl:param name="expr"/>
        <xsl:param name="index"/>
        <xsl:param name="rule"/>
        <xsl:param name="alternation"/>
        <xsl:param name="step" select="1"/>
        <xsl:param name="built-result" select="''"/>

        <!--<xsl:message>Trying production <xsl:value-of select="$rule"/> alternation <xsl:value-of
                select="$alternation"/></xsl:message>-->

        <xsl:choose>
            <xsl:when
                test="$step &gt; count($grammar-document/xsl:stylesheet/*[local-name() = 'rule'][namespace-uri() = concat($grammar-namespace-prefix, $rule)]
                /sequence[$alternation]/*)">
                <!-- Still going at end.  Must be a match. -->
                <xsl:variable name="encoded-result">
                    <xsl:call-template name="encode">
                        <xsl:with-param name="expr" select="$built-result"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="alternation-name">
                    <xsl:choose>
                        <xsl:when
                            test="$grammar-document/xsl:stylesheet/*[local-name() = 'rule'][namespace-uri() = concat($grammar-namespace-prefix, $rule)]
                            /sequence[$alternation]/@name">
                            <xsl:value-of
                                select="string($grammar-document/xsl:stylesheet/*[local-name() = 'rule'][namespace-uri() = concat($grammar-namespace-prefix, $rule)]
                                /sequence[$alternation]/@name)"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$alternation"/>
                        </xsl:otherwise>
                    </xsl:choose>

                </xsl:variable>
                <xsl:value-of
                    select="concat($index, ';', $rule, ':', $alternation-name, ':', $encoded-result)"
                />
            </xsl:when>
            <!--        
            <xsl:when test="$index &gt; string-length($expr)">
                <xsl:value-of select="'-'"/>
            </xsl:when>
-->
            <xsl:when
                test="$index &lt;= string-length($expr) and contains(' &#x0A;&#x09;', substring($expr, $index, 1))">
                <!-- Skip white space between tokens. -->
                <xsl:call-template name="production-alternation">
                    <xsl:with-param name="expr" select="$expr"/>
                    <xsl:with-param name="index" select="$index + 1"/>
                    <xsl:with-param name="rule" select="$rule"/>
                    <xsl:with-param name="alternation" select="$alternation"/>
                    <xsl:with-param name="step" select="$step"/>
                    <xsl:with-param name="built-result" select="$built-result"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- Need to test next step. -->
                <xsl:variable name="step-type"
                    select="local-name($grammar-document/xsl:stylesheet/*[local-name() = 'rule'][namespace-uri() = concat($grammar-namespace-prefix, $rule)]
                    /sequence[$alternation]/*[$step])"/>
                <xsl:variable name="step-result">
                    <xsl:choose>
                        <xsl:when test="$step-type = 'literal'">
                            <xsl:call-template name="step-literal">
                                <xsl:with-param name="expr" select="$expr"/>
                                <xsl:with-param name="index" select="$index"/>
                                <xsl:with-param name="rule" select="$rule"/>
                                <xsl:with-param name="alternation" select="$alternation"/>
                                <xsl:with-param name="step" select="$step"/>
                                <xsl:with-param name="built-result" select="$built-result"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$step-type = 'nonterminal'">
                            <xsl:call-template name="step-nonterminal">
                                <xsl:with-param name="expr" select="$expr"/>
                                <xsl:with-param name="index" select="$index"/>
                                <xsl:with-param name="rule" select="$rule"/>
                                <xsl:with-param name="alternation" select="$alternation"/>
                                <xsl:with-param name="step" select="$step"/>
                                <xsl:with-param name="built-result" select="$built-result"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$step-type = 'literal-ncname'">
                            <xsl:call-template name="step-literal-ncname">
                                <xsl:with-param name="expr" select="$expr"/>
                                <xsl:with-param name="index" select="$index"/>
                                <xsl:with-param name="rule" select="$rule"/>
                                <xsl:with-param name="alternation" select="$alternation"/>
                                <xsl:with-param name="step" select="$step"/>
                                <xsl:with-param name="built-result" select="$built-result"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$step-type = 'literal-span'">
                            <xsl:call-template name="step-literal-span">
                                <xsl:with-param name="expr" select="$expr"/>
                                <xsl:with-param name="index" select="$index"/>
                                <xsl:with-param name="rule" select="$rule"/>
                                <xsl:with-param name="alternation" select="$alternation"/>
                                <xsl:with-param name="step" select="$step"/>
                                <xsl:with-param name="built-result" select="$built-result"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$step-type = 'literal-digits'">
                            <xsl:call-template name="step-literal-digits">
                                <xsl:with-param name="expr" select="$expr"/>
                                <xsl:with-param name="index" select="$index"/>
                                <xsl:with-param name="rule" select="$rule"/>
                                <xsl:with-param name="alternation" select="$alternation"/>
                                <xsl:with-param name="step" select="$step"/>
                                <xsl:with-param name="built-result" select="$built-result"/>
                            </xsl:call-template>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>

                <xsl:choose>
                    <xsl:when test="$step-result = '-'">
                        <!-- Match failed. Alternation fails too. -->
                        <xsl:value-of select="'-'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Match succeeded.  Go to next step. -->
                        <xsl:variable name="step-result-newindex"
                            select="number(substring-before($step-result,';'))"/>

                        <xsl:variable name="step-result-value">
                            <xsl:choose>
                                <xsl:when
                                    test="$grammar-document/xsl:stylesheet/*[local-name() = 'rule'][namespace-uri() = concat($grammar-namespace-prefix, $rule)]
                                    /sequence[$alternation]/*[$step]/@unwrap = 'true'">
                                    <xsl:call-template name="decode">
                                        <xsl:with-param name="expr"
                                            select="substring-after(substring-after(substring-after($step-result, ';'), ':'), ':')"
                                        />
                                    </xsl:call-template>

                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="substring-after($step-result, ';')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>

                        <xsl:variable name="next-built-result">
                            <xsl:choose>
                                <xsl:when test="$step = 1">
                                    <xsl:value-of select="$step-result-value"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="concat($built-result, ';', $step-result-value)"/>
                                </xsl:otherwise>
                            </xsl:choose>

                        </xsl:variable>
                        <xsl:call-template name="production-alternation">
                            <xsl:with-param name="expr" select="$expr"/>
                            <xsl:with-param name="index" select="$step-result-newindex"/>
                            <xsl:with-param name="rule" select="$rule"/>
                            <xsl:with-param name="alternation" select="$alternation"/>
                            <xsl:with-param name="step" select="$step + 1"/>
                            <xsl:with-param name="built-result" select="$next-built-result"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="step-nonterminal">
        <xsl:param name="expr"/>
        <xsl:param name="index"/>
        <xsl:param name="rule"/>
        <xsl:param name="alternation"/>
        <xsl:param name="step"/>
        <xsl:param name="built-result"/>

        <xsl:variable name="nonterminal-production-name"
            select="string($grammar-document/xsl:stylesheet/*[local-name() = 'rule'][namespace-uri() = concat($grammar-namespace-prefix, $rule)]
            /sequence[$alternation]/*[$step]/@name)"/>
        <!--<xsl:message>Expecting nonterminal <xsl:value-of select="$nonterminal-production-name"/></xsl:message>-->

        <xsl:variable name="result">
            <xsl:call-template name="production">
                <xsl:with-param name="expr" select="$expr"/>
                <xsl:with-param name="index" select="$index"/>
                <xsl:with-param name="rule" select="$nonterminal-production-name"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$result = '-'">
                <xsl:value-of select="'-'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$result"/>
                <!--                <xsl:call-template name="encode">
                    <xsl:with-param name="expr" select="$result"/>
                </xsl:call-template>
-->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="step-literal">
        <xsl:param name="expr"/>
        <xsl:param name="index"/>
        <xsl:param name="rule"/>
        <xsl:param name="alternation"/>
        <xsl:param name="step"/>
        <xsl:param name="built-result"/>

        <xsl:variable name="wanted"
            select="string($grammar-document/xsl:stylesheet/*[local-name() = 'rule'][namespace-uri() = concat($grammar-namespace-prefix, $rule)]
            /sequence[$alternation]/*[$step]/@value)"/>
        <!-- <xsl:message>Expecting literal <xsl:value-of select="$wanted"/></xsl:message> -->

        <xsl:choose>
            <xsl:when
                test="substring($expr, $index, string-length($wanted)) = $wanted
                and (not($grammar-document/xsl:stylesheet/*[local-name() = 'rule'][namespace-uri() = concat($grammar-namespace-prefix, $rule)]
                /sequence[$alternation]/*[$step]/@type = 'alphanumeric')
                              or string-length($wanted) + $index &gt; string-length($expr)
                              or not(contains('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_',
                                              substring($expr, $index + string-length($wanted), 1) )))">
                <!-- Yes, matches. -->
                <xsl:variable name="encoded">
                    <xsl:call-template name="encode">
                        <xsl:with-param name="expr" select="$wanted"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of
                    select="concat($index + string-length($wanted), ';literal:', string($encoded))"
                />
            </xsl:when>
            <xsl:otherwise>
                <!-- No, doesn't match. -->
                <xsl:value-of select="'-'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="step-literal-digits">
        <xsl:param name="expr"/>
        <xsl:param name="index"/>
        <xsl:param name="rule"/>
        <xsl:param name="alternation"/>
        <xsl:param name="step"/>
        <xsl:param name="built-result"/>
        <xsl:param name="built-span" select="''"/>

        <!-- <xsl:message>Expecting literal digits (got '<xsl:value-of select="$built-span"/>')</xsl:message> -->

        <xsl:choose>
            <xsl:when
                test="$index &gt; string-length($expr) or not(contains('0123456789',substring($expr, $index, 1)))">
                <!-- Found non-digit.  Successful iff string-length($built-span) is greater than 0. -->
                <xsl:choose>
                    <xsl:when test="string-length($built-span) = 0">
                        <xsl:value-of select="'-'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($index, ';literal-digits:',$built-span)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="step-literal-digits">
                    <xsl:with-param name="expr" select="$expr"/>
                    <xsl:with-param name="index" select="$index + 1"/>
                    <xsl:with-param name="rule" select="$rule"/>
                    <xsl:with-param name="alternation" select="$alternation"/>
                    <xsl:with-param name="step" select="$step"/>
                    <xsl:with-param name="built-result" select="$built-result"/>
                    <xsl:with-param name="built-span"
                        select="concat($built-span,substring($expr, $index, 1))"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="step-literal-ncname">
        <xsl:param name="expr"/>
        <xsl:param name="index"/>
        <xsl:param name="rule"/>
        <xsl:param name="alternation"/>
        <xsl:param name="step"/>
        <xsl:param name="built-result"/>
        <xsl:param name="built-span" select="''"/>

        <!-- <xsl:message>Expecting literal NCName (got '<xsl:value-of select="$built-span"/>')</xsl:message> -->

        <xsl:choose>
            <xsl:when
                test="$index &gt; string-length($expr)
                or string-length($built-span) = 0 and not(contains('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_',substring($expr, $index, 1)))
                or not(contains('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.',substring($expr, $index, 1)))">
                <!-- Found end.  Successful iff string-length($built-span) is greater than 0. -->
                <xsl:choose>
                    <xsl:when test="string-length($built-span) = 0">
                        <xsl:value-of select="'-'"/>
                    </xsl:when>
                    <xsl:when
                        test="not(contains($built-span, ' ')) and 
                        contains($grammar-document/xsl:stylesheet/*[local-name() = 'rule'][namespace-uri() = concat($grammar-namespace-prefix, $rule)]
                        /sequence[$alternation]/*[$step]/@except, concat(' ', $built-span, ' '))">
                        <xsl:value-of select="'-'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($index, ';literal-ncname:',$built-span)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="step-literal-ncname">
                    <xsl:with-param name="expr" select="$expr"/>
                    <xsl:with-param name="index" select="$index + 1"/>
                    <xsl:with-param name="rule" select="$rule"/>
                    <xsl:with-param name="alternation" select="$alternation"/>
                    <xsl:with-param name="step" select="$step"/>
                    <xsl:with-param name="built-result" select="$built-result"/>
                    <xsl:with-param name="built-span"
                        select="concat($built-span,substring($expr, $index, 1))"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="step-literal-span">
        <xsl:param name="expr"/>
        <xsl:param name="index"/>
        <xsl:param name="rule"/>
        <xsl:param name="alternation"/>
        <xsl:param name="step"/>
        <xsl:param name="built-result"/>
        <xsl:param name="built-span" select="''"/>

        <!-- <xsl:message>Expecting literal span (got '<xsl:value-of select="$built-span"/>')</xsl:message> -->

        <xsl:choose>
            <xsl:when test="$index &gt; string-length($expr)">
                <!-- End of string.  Failed. -->
                <xsl:value-of select="'-'"/>
            </xsl:when>
            <xsl:when
                test="substring($expr, $index, 1) = $grammar-document/xsl:stylesheet/*[local-name() = 'rule'][namespace-uri() = concat($grammar-namespace-prefix, $rule)]
                /sequence[$alternation]/*[$step]/@until">
                <!-- Found terminator.  Success. -->
                <xsl:variable name="result">
                    <xsl:call-template name="encode">
                        <xsl:with-param name="expr" select="$built-span"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($index, ';literal-span:',$result)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="step-literal-span">
                    <xsl:with-param name="expr" select="$expr"/>
                    <xsl:with-param name="index" select="$index + 1"/>
                    <xsl:with-param name="rule" select="$rule"/>
                    <xsl:with-param name="alternation" select="$alternation"/>
                    <xsl:with-param name="step" select="$step"/>
                    <xsl:with-param name="built-result" select="$built-result"/>
                    <xsl:with-param name="built-span"
                        select="concat($built-span,substring($expr, $index, 1))"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
