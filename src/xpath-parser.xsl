<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:Expr="http://futzle.com/2006/xslt-grammar/Expr"
    xmlns:PrimaryExpr="http://futzle.com/2006/xslt-grammar/PrimaryExpr"
    xmlns:FunctionCall="http://futzle.com/2006/xslt-grammar/FunctionCall"
    xmlns:ArgumentList-star="http://futzle.com/2006/xslt-grammar/ArgumentList-star"
    xmlns:Argument="http://futzle.com/2006/xslt-grammar/Argument"
    xmlns:OrExpr="http://futzle.com/2006/xslt-grammar/OrExpr"
    xmlns:OrExpr-prime="http://futzle.com/2006/xslt-grammar/OrExpr-prime"
    xmlns:AndExpr="http://futzle.com/2006/xslt-grammar/AndExpr"
    xmlns:AndExpr-prime="http://futzle.com/2006/xslt-grammar/AndExpr-prime"
    xmlns:EqualityExpr="http://futzle.com/2006/xslt-grammar/EqualityExpr"
    xmlns:EqualityExpr-prime="http://futzle.com/2006/xslt-grammar/EqualityExpr-prime"
    xmlns:RelationalExpr="http://futzle.com/2006/xslt-grammar/RelationalExpr"
    xmlns:RelationalExpr-prime="http://futzle.com/2006/xslt-grammar/RelationalExpr-prime"
    xmlns:AdditiveExpr="http://futzle.com/2006/xslt-grammar/AdditiveExpr"
    xmlns:AdditiveExpr-prime="http://futzle.com/2006/xslt-grammar/AdditiveExpr-prime"
    xmlns:MultiplicativeExpr="http://futzle.com/2006/xslt-grammar/MultiplicativeExpr"
    xmlns:MultiplicativeExpr-prime="http://futzle.com/2006/xslt-grammar/MultiplicativeExpr-prime"
    xmlns:UnaryExpr="http://futzle.com/2006/xslt-grammar/UnaryExpr"
    xmlns:UnionExpr="http://futzle.com/2006/xslt-grammar/UnionExpr"
    xmlns:UnionExpr-prime="http://futzle.com/2006/xslt-grammar/UnionExpr-prime"
    xmlns:PathExpr="http://futzle.com/2006/xslt-grammar/PathExpr"
    xmlns:FilterExpr="http://futzle.com/2006/xslt-grammar/FilterExpr"
    xmlns:FilterExpr-prime="http://futzle.com/2006/xslt-grammar/FilterExpr-prime"
    xmlns:LocationPath="http://futzle.com/2006/xslt-grammar/LocationPath"
    xmlns:RelativeLocationPath="http://futzle.com/2006/xslt-grammar/RelativeLocationPath"
    xmlns:RelativeLocationPath-prime="http://futzle.com/2006/xslt-grammar/RelativeLocationPath-prime"
    xmlns:Step="http://futzle.com/2006/xslt-grammar/Step"
    xmlns:AxisSpecifier="http://futzle.com/2006/xslt-grammar/AxisSpecifier"
    xmlns:AxisName="http://futzle.com/2006/xslt-grammar/AxisName"
    xmlns:NodeTest="http://futzle.com/2006/xslt-grammar/NodeTest"
    xmlns:NodeType="http://futzle.com/2006/xslt-grammar/NodeType"
    xmlns:Predicate-star="http://futzle.com/2006/xslt-grammar/Predicate-star"
    xmlns:Predicate="http://futzle.com/2006/xslt-grammar/Predicate"
    xmlns:PredicateExpr="http://futzle.com/2006/xslt-grammar/PredicateExpr"
    xmlns:Literal="http://futzle.com/2006/xslt-grammar/Literal"
    xmlns:Number="http://futzle.com/2006/xslt-grammar/Number"
    xmlns:FunctionName="http://futzle.com/2006/xslt-grammar/FunctionName"
    xmlns:VariableReference="http://futzle.com/2006/xslt-grammar/VariableReference"
    xmlns:NCName="http://futzle.com/2006/xslt-grammar/NCName"
    xmlns:QName="http://futzle.com/2006/xslt-grammar/QName"
    xmlns:Pattern="http://futzle.com/2006/xslt-grammar/Pattern"
    xmlns:Pattern-prime="http://futzle.com/2006/xslt-grammar/Pattern-prime"
    xmlns:LocationPathPattern="http://futzle.com/2006/xslt-grammar/LocationPathPattern"
    xmlns:IdKeyPattern="http://futzle.com/2006/xslt-grammar/IdKeyPattern"
    xmlns:RelativePathPattern="http://futzle.com/2006/xslt-grammar/RelativePathPattern"
    xmlns:RelativePathPattern-prime="http://futzle.com/2006/xslt-grammar/RelativePathPattern-prime"
    xmlns:StepPattern="http://futzle.com/2006/xslt-grammar/StepPattern"
    xmlns:ChildOrAttributeAxisSpecifier="http://futzle.com/2006/xslt-grammar/ChildOrAttributeAxisSpecifier"
    xmlns:nodeset-step="http://futzle.com/2006/xslt-interpreter/nodeset-step"
    xmlns:nodeset-compare-binary-lhs="http://futzle.com/2006/xslt-interpreter/nodeset-compare-binary-lhs"
    xmlns:nodeset-compare-binary-rhs="http://futzle.com/2006/xslt-interpreter/nodeset-compare-binary-rhs"
    exclude-result-prefixes="Expr PrimaryExpr Expr PrimaryExpr FunctionCall ArgumentList-star Argument OrExpr OrExpr-prime AndExpr AndExpr-prime EqualityExpr EqualityExpr-prime RelationalExpr RelationalExpr-prime AdditiveExpr AdditiveExpr-prime MultiplicativeExpr MultiplicativeExpr-prime UnaryExpr UnionExpr UnionExpr-prime PathExpr FilterExpr FilterExpr-prime LocationPath RelativeLocationPath RelativeLocationPath-prime Step AxisSpecifier AxisName NodeTest NodeType Predicate-star Predicate PredicateExpr Literal Number FunctionName VariableReference NCName QName
                             nodeset-step nodeset-compare-binary-lhs nodeset-compare-binary-rhs">

    <xsl:import href="lib-datatype.xsl"/>
    <xsl:import href="lib-parser.xsl"/>
    <xsl:import href="lib-interpret.xsl"/>
    <xsl:import href="xpath-functions.xsl"/>
    <xsl:import href="xslt-functions.xsl"/>

    <!-- This document, so that the parser library can read it. -->
    <xsl:variable name="grammar-document" select="document('')"/>
    <xsl:variable name="grammar-namespace-prefix" select="'http://futzle.com/2006/xslt-grammar/'"/>

    <xsl:variable name="function-documents"
        select="document('xpath-functions.xsl')|document('xslt-functions.xsl')"/>
    <xsl:variable name="function-namespace-prefix" select="'http://futzle.com/2006/xslt-function/'"/>

    <!--      -->
    <!-- Expr -->
    <!--      -->
    <Expr:rule>
        <sequence>
            <nonterminal name="OrExpr"/>
        </sequence>
    </Expr:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/Expr']">
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="eval">
            <xsl:with-param name="expr" select="$argument"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <!--             -->
    <!-- PrimaryExpr -->
    <!--             -->
    <PrimaryExpr:rule>
        <sequence name="Variable">
            <nonterminal name="VariableReference"/>
        </sequence>
        <sequence name="ExprInParentheses">
            <literal value="("/>
            <nonterminal name="Expr"/>
            <literal value=")"/>
        </sequence>
        <sequence name="Literal">
            <nonterminal name="Literal"/>
        </sequence>
        <sequence name="Number">
            <nonterminal name="Number"/>
        </sequence>
        <sequence name="FunctionCall">
            <nonterminal name="FunctionCall"/>
        </sequence>
    </PrimaryExpr:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/PrimaryExpr']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="$alternation = 'ExprInParentheses'">
                <xsl:call-template name="eval">
                    <xsl:with-param name="expr"
                        select="substring-before(substring-after($argument, ';'), ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="eval">
                    <xsl:with-param name="expr" select="$argument"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--              -->
    <!-- FunctionCall -->
    <!--              -->
    <FunctionCall:rule>
        <sequence name="NoArgs">
            <nonterminal name="FunctionName"/>
            <literal value="("/>
            <literal value=")"/>
        </sequence>
        <sequence name="Args">
            <nonterminal name="FunctionName"/>
            <literal value="("/>
            <nonterminal name="Argument"/>
            <nonterminal name="ArgumentList-star" unwrap="true"/>
            <literal value=")"/>
        </sequence>
    </FunctionCall:rule>
    <ArgumentList-star:rule>
        <sequence>
            <literal value=","/>
            <nonterminal name="Argument"/>
            <nonterminal name="ArgumentList-star" unwrap="true"/>
        </sequence>
        <sequence/>
    </ArgumentList-star:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/FunctionCall']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="eval-function">
            <xsl:with-param name="fname">
                <xsl:call-template name="eval">
                    <xsl:with-param name="expr" select="substring-before($argument, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="arguments">
                <xsl:choose>
                    <xsl:when test="$alternation = 'NoArgs'">
                        <xsl:value-of select="''"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="unwrap-function-arguments">
                            <xsl:with-param name="expr"
                                select="substring-after(substring-after($argument, ';'), ';')"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>

        </xsl:call-template>
    </xsl:template>

    <xsl:template name="unwrap-function-arguments">
        <xsl:param name="expr"/>
        <xsl:choose>
            <xsl:when test="contains($expr, ';;')">
                <xsl:variable name="prefix" select="substring-before($expr, ';')"/>
                <xsl:variable name="suffix">
                    <xsl:call-template name="unwrap-function-arguments">
                        <xsl:with-param name="expr"
                            select="substring-after(substring-after($expr, ';'), ';')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($prefix, ';', $suffix)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="count-function-arguments">
        <xsl:param name="expr"/>

        <xsl:choose>
            <xsl:when test="contains($expr, ';')">
                <xsl:variable name="remainder">
                    <xsl:call-template name="count-function-arguments">
                        <xsl:with-param name="expr" select="substring-after($expr, ';')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="1 + $remainder"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="eval-function">
        <xsl:param name="fname"/>
        <xsl:param name="arguments"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:variable name="fname-namespace"
            select="substring-before(substring-after($fname, '{'), '}')"/>

        <xsl:variable name="fname-local-name" select="substring-after($fname, '}')"/>

        <xsl:variable name="catchall-function"
            select="$function-documents/xsl:stylesheet/*[namespace-uri() = concat($function-namespace-prefix, $fname-namespace, '/', $fname-local-name)]"/>

        <xsl:choose>
            <xsl:when test="count($catchall-function) = 1">
                <xsl:apply-templates select="$catchall-function">
                    <xsl:with-param name="arguments" select="$arguments"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="argument-count">
                    <xsl:call-template name="count-function-arguments">
                        <xsl:with-param name="expr" select="$arguments"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:choose>
                    <xsl:when test="$argument-count = 0">
                        <xsl:variable name="specific-function"
                            select="$function-documents/xsl:stylesheet/*[namespace-uri() = concat('http://futzle.com/2006/xslt-function/', $fname-namespace, '/', $fname-local-name, '/0')]"/>
                        <xsl:choose>
                            <xsl:when test="count($specific-function) = 1">
                                <xsl:apply-templates select="$specific-function">
                                    <xsl:with-param name="fname-namespace" select="$fname-namespace"/>
                                    <xsl:with-param name="fname-local-name"
                                        select="$fname-local-name"/>
                                    <xsl:with-param name="context" select="$context"/>
                                    <xsl:with-param name="document" select="$document"/>
                                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:message terminate="yes">
                                    <xsl:text>No function {</xsl:text>
                                    <xsl:value-of select="$fname-namespace"/>
                                    <xsl:text>}</xsl:text>
                                    <xsl:value-of select="$fname-local-name"/>
                                </xsl:message>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$argument-count = 1">
                        <xsl:variable name="arg1">
                            <xsl:call-template name="eval">
                                <xsl:with-param name="expr"
                                    select="substring-before($arguments, ';')"/>
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="arg1-type">
                            <xsl:call-template name="value-type">
                                <xsl:with-param name="expr" select="$arg1"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="specific-function"
                            select="$function-documents/xsl:stylesheet/*[namespace-uri() = concat('http://futzle.com/2006/xslt-function/', $fname-namespace, '/', $fname-local-name, '/1')]"/>
                        <xsl:choose>
                            <xsl:when test="count($specific-function) = 1">
                                <xsl:apply-templates select="$specific-function">
                                    <xsl:with-param name="fname-namespace" select="$fname-namespace"/>
                                    <xsl:with-param name="fname-local-name"
                                        select="$fname-local-name"/>
                                    <xsl:with-param name="arg1" select="$arg1"/>
                                    <xsl:with-param name="arg1-type" select="$arg1-type"/>
                                    <xsl:with-param name="context" select="$context"/>
                                    <xsl:with-param name="document" select="$document"/>
                                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:message terminate="yes">
                                    <xsl:text>No function {</xsl:text>
                                    <xsl:value-of select="$fname-namespace"/>
                                    <xsl:text>}</xsl:text>
                                    <xsl:value-of select="$fname-local-name"/>
                                    <xsl:text>(</xsl:text>
                                    <xsl:value-of select="$arg1-type"/>
                                    <xsl:text>)</xsl:text>
                                </xsl:message>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$argument-count = 2">
                        <xsl:variable name="arg1">
                            <xsl:call-template name="eval">
                                <xsl:with-param name="expr"
                                    select="substring-before($arguments, ';')"/>
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="arg1-type">
                            <xsl:call-template name="value-type">
                                <xsl:with-param name="expr" select="$arg1"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="arg2">
                            <xsl:call-template name="eval">
                                <xsl:with-param name="expr"
                                    select="substring-before(substring-after($arguments, ';'), ';')"/>
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="arg2-type">
                            <xsl:call-template name="value-type">
                                <xsl:with-param name="expr" select="$arg2"/>
                            </xsl:call-template>
                        </xsl:variable>

                        <xsl:variable name="specific-function"
                            select="$function-documents/xsl:stylesheet/*[namespace-uri() = concat('http://futzle.com/2006/xslt-function/', $fname-namespace, '/', $fname-local-name, '/2')]"/>
                        <xsl:choose>
                            <xsl:when test="count($specific-function) = 1">
                                <xsl:apply-templates select="$specific-function">
                                    <xsl:with-param name="fname-namespace" select="$fname-namespace"/>
                                    <xsl:with-param name="fname-local-name"
                                        select="$fname-local-name"/>
                                    <xsl:with-param name="arg1" select="$arg1"/>
                                    <xsl:with-param name="arg1-type" select="$arg1-type"/>
                                    <xsl:with-param name="arg2" select="$arg2"/>
                                    <xsl:with-param name="arg2-type" select="$arg2-type"/>
                                    <xsl:with-param name="context" select="$context"/>
                                    <xsl:with-param name="document" select="$document"/>
                                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:message terminate="yes">
                                    <xsl:text>No function {</xsl:text>
                                    <xsl:value-of select="$fname-namespace"/>
                                    <xsl:text>}</xsl:text>
                                    <xsl:value-of select="$fname-local-name"/>
                                    <xsl:text>(</xsl:text>
                                    <xsl:value-of select="$arg1-type"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$arg2-type"/>
                                    <xsl:text>)</xsl:text>
                                </xsl:message>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$argument-count = 3">
                        <xsl:variable name="arg1">
                            <xsl:call-template name="eval">
                                <xsl:with-param name="expr"
                                    select="substring-before($arguments, ';')"/>
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="arg1-type">
                            <xsl:call-template name="value-type">
                                <xsl:with-param name="expr" select="$arg1"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="arg2">
                            <xsl:call-template name="eval">
                                <xsl:with-param name="expr"
                                    select="substring-before(substring-after($arguments, ';'), ';')"/>
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="arg2-type">
                            <xsl:call-template name="value-type">
                                <xsl:with-param name="expr" select="$arg2"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="arg3">
                            <xsl:call-template name="eval">
                                <xsl:with-param name="expr"
                                    select="substring-before(substring-after(substring-after($arguments, ';'), ';'), ';')"/>
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="arg3-type">
                            <xsl:call-template name="value-type">
                                <xsl:with-param name="expr" select="$arg3"/>
                            </xsl:call-template>
                        </xsl:variable>

                        <xsl:variable name="specific-function"
                            select="$function-documents/xsl:stylesheet/*[namespace-uri() = concat('http://futzle.com/2006/xslt-function/', $fname-namespace, '/', $fname-local-name, '/3')]"/>
                        <xsl:choose>
                            <xsl:when test="count($specific-function) = 1">
                                <xsl:apply-templates select="$specific-function">
                                    <xsl:with-param name="fname-namespace" select="$fname-namespace"/>
                                    <xsl:with-param name="fname-local-name"
                                        select="$fname-local-name"/>
                                    <xsl:with-param name="arg1" select="$arg1"/>
                                    <xsl:with-param name="arg1-type" select="$arg1-type"/>
                                    <xsl:with-param name="arg2" select="$arg2"/>
                                    <xsl:with-param name="arg2-type" select="$arg2-type"/>
                                    <xsl:with-param name="arg3" select="$arg3"/>
                                    <xsl:with-param name="arg3-type" select="$arg3-type"/>
                                    <xsl:with-param name="context" select="$context"/>
                                    <xsl:with-param name="document" select="$document"/>
                                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:message terminate="yes">
                                    <xsl:text>No function {</xsl:text>
                                    <xsl:value-of select="$fname-namespace"/>
                                    <xsl:text>}</xsl:text>
                                    <xsl:value-of select="$fname-local-name"/>
                                    <xsl:text>(</xsl:text>
                                    <xsl:value-of select="$arg1-type"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$arg2-type"/>
                                    <xsl:text>,</xsl:text>
                                    <xsl:value-of select="$arg3-type"/>
                                    <xsl:text>)</xsl:text>
                                </xsl:message>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message terminate="yes">No function has that many
                        arguments!</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--          -->
    <!-- Argument -->
    <!--          -->
    <Argument:rule>
        <sequence>
            <nonterminal name="Expr"/>
        </sequence>
    </Argument:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/Argument']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="eval">
            <xsl:with-param name="expr" select="$argument"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>


    <!--        -->
    <!-- OrExpr -->
    <!--        -->
    <OrExpr:rule>
        <sequence>
            <nonterminal name="AndExpr"/>
            <nonterminal name="OrExpr-prime" unwrap="true"/>
        </sequence>
    </OrExpr:rule>
    <OrExpr-prime:rule>
        <sequence>
            <literal value="or" type="alphanumeric"/>
            <nonterminal name="AndExpr"/>
            <nonterminal name="OrExpr-prime" unwrap="true"/>
        </sequence>
        <sequence/>
    </OrExpr-prime:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/OrExpr']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:variable name="lhs">
            <xsl:call-template name="eval">
                <xsl:with-param name="expr" select="substring-before($argument, ';')"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="string-length(substring-after($argument, ';')) = 0">
                <xsl:value-of select="$lhs"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="OrExpr-repeat">
                    <xsl:with-param name="running-value">
                        <xsl:call-template name="cast-boolean">
                            <xsl:with-param name="expr" select="$lhs"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="remainder" select="substring-after($argument, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="OrExpr-repeat">
        <xsl:param name="running-value"/>
        <xsl:param name="remainder"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="$running-value">
                <xsl:call-template name="construct-boolean">
                    <xsl:with-param name="expr" select="true()"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="string-length($remainder) = 0">
                <xsl:call-template name="construct-boolean">
                    <xsl:with-param name="expr" select="false()"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="arguments" select="substring-after($remainder, ';')"/>
                <xsl:call-template name="OrExpr-repeat">
                    <xsl:with-param name="running-value">
                        <xsl:call-template name="eval">
                            <xsl:with-param name="expr" select="substring-before($arguments, ';')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="remainder" select="substring-after($arguments, ';')"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--         -->
    <!-- AndExpr -->
    <!--         -->
    <AndExpr:rule>
        <sequence>
            <nonterminal name="EqualityExpr"/>
            <nonterminal name="AndExpr-prime" unwrap="true"/>
        </sequence>
    </AndExpr:rule>
    <AndExpr-prime:rule>
        <sequence>
            <literal value="and" type="alphanumeric"/>
            <nonterminal name="EqualityExpr"/>
            <nonterminal name="AndExpr-prime" unwrap="true"/>
        </sequence>
        <sequence/>
    </AndExpr-prime:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/AndExpr']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:variable name="lhs">
            <xsl:call-template name="eval">
                <xsl:with-param name="expr" select="substring-before($argument, ';')"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="string-length(substring-after($argument, ';')) = 0">
                <xsl:value-of select="$lhs"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="AndExpr-repeat">
                    <xsl:with-param name="running-value">
                        <xsl:call-template name="cast-boolean">
                            <xsl:with-param name="expr" select="$lhs"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="remainder" select="substring-after($argument, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="AndExpr-repeat">
        <xsl:param name="running-value"/>
        <xsl:param name="remainder"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="not($running-value)">
                <xsl:call-template name="construct-boolean">
                    <xsl:with-param name="expr" select="false()"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="string-length($remainder) = 0">
                <xsl:call-template name="construct-boolean">
                    <xsl:with-param name="expr" select="true()"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="arguments" select="substring-after($remainder, ';')"/>
                <xsl:call-template name="AndExpr-repeat">
                    <xsl:with-param name="running-value">
                        <xsl:call-template name="eval">
                            <xsl:with-param name="expr" select="substring-before($arguments, ';')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="remainder" select="substring-after($arguments, ';')"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--              -->
    <!-- EqualityExpr -->
    <!--              -->
    <EqualityExpr:rule>
        <sequence>
            <nonterminal name="RelationalExpr"/>
            <nonterminal name="EqualityExpr-prime" unwrap="true"/>
        </sequence>
    </EqualityExpr:rule>
    <EqualityExpr-prime:rule>
        <sequence>
            <literal value="="/>
            <nonterminal name="RelationalExpr"/>
            <nonterminal name="EqualityExpr-prime" unwrap="true"/>
        </sequence>
        <sequence>
            <literal value="!="/>
            <nonterminal name="RelationalExpr"/>
            <nonterminal name="EqualityExpr-prime" unwrap="true"/>
        </sequence>
        <sequence/>
    </EqualityExpr-prime:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/EqualityExpr']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="EqualityExpr-repeat">
            <xsl:with-param name="running-value">
                <xsl:call-template name="eval">
                    <xsl:with-param name="expr" select="substring-before($argument, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="remainder" select="substring-after($argument, ';')"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="EqualityExpr-repeat">
        <xsl:param name="running-value"/>
        <xsl:param name="remainder"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="string-length($remainder) = 0">
                <xsl:value-of select="$running-value"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="operator"
                    select="substring-after(substring-before($remainder, ';'), ':')"/>
                <xsl:variable name="arguments" select="substring-after($remainder, ';')"/>
                <xsl:variable name="result">
                    <xsl:call-template name="compare-binary">
                        <xsl:with-param name="lhs" select="$running-value"/>
                        <xsl:with-param name="rhs">
                            <xsl:call-template name="eval">
                                <xsl:with-param name="expr"
                                    select="substring-before($arguments, ';')"/>
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="operator" select="$operator"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="EqualityExpr-repeat">
                    <xsl:with-param name="running-value" select="$result"/>
                    <xsl:with-param name="remainder" select="substring-after($arguments, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--                -->
    <!-- RelationalExpr -->
    <!--                -->
    <RelationalExpr:rule>
        <sequence>
            <nonterminal name="AdditiveExpr"/>
            <nonterminal name="RelationalExpr-prime" unwrap="true"/>
        </sequence>
    </RelationalExpr:rule>
    <RelationalExpr-prime:rule>
        <sequence>
            <literal value="&lt;="/>
            <nonterminal name="AdditiveExpr"/>
            <nonterminal name="RelationalExpr-prime" unwrap="true"/>
        </sequence>
        <sequence>
            <literal value="&gt;="/>
            <nonterminal name="AdditiveExpr"/>
            <nonterminal name="RelationalExpr-prime" unwrap="true"/>
        </sequence>
        <sequence>
            <literal value="&lt;"/>
            <nonterminal name="AdditiveExpr"/>
            <nonterminal name="RelationalExpr-prime" unwrap="true"/>
        </sequence>
        <sequence>
            <literal value="&gt;"/>
            <nonterminal name="AdditiveExpr"/>
            <nonterminal name="RelationalExpr-prime" unwrap="true"/>
        </sequence>
        <sequence/>
    </RelationalExpr-prime:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/RelationalExpr']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="RelationalExpr-repeat">
            <xsl:with-param name="running-value">
                <xsl:call-template name="eval">
                    <xsl:with-param name="expr" select="substring-before($argument, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="remainder" select="substring-after($argument, ';')"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="RelationalExpr-repeat">
        <xsl:param name="running-value"/>
        <xsl:param name="remainder"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="string-length($remainder) = 0">
                <xsl:value-of select="$running-value"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="operator"
                    select="substring-after(substring-before($remainder, ';'), ':')"/>
                <xsl:variable name="arguments" select="substring-after($remainder, ';')"/>
                <xsl:variable name="result">
                    <xsl:call-template name="compare-binary">
                        <xsl:with-param name="lhs" select="$running-value"/>
                        <xsl:with-param name="rhs">
                            <xsl:call-template name="eval">
                                <xsl:with-param name="expr"
                                    select="substring-before($arguments, ';')"/>
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="operator" select="$operator"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="RelationalExpr-repeat">
                    <xsl:with-param name="running-value" select="$result"/>
                    <xsl:with-param name="remainder" select="substring-after($arguments, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--              -->
    <!-- AdditiveExpr -->
    <!--              -->
    <AdditiveExpr:rule>
        <sequence>
            <nonterminal name="MultiplicativeExpr"/>
            <nonterminal name="AdditiveExpr-prime" unwrap="true"/>
        </sequence>
    </AdditiveExpr:rule>
    <AdditiveExpr-prime:rule>
        <sequence>
            <literal value="+"/>
            <nonterminal name="MultiplicativeExpr"/>
            <nonterminal name="AdditiveExpr-prime" unwrap="true"/>
        </sequence>
        <sequence>
            <literal value="-"/>
            <nonterminal name="MultiplicativeExpr"/>
            <nonterminal name="AdditiveExpr-prime" unwrap="true"/>
        </sequence>
        <sequence/>
    </AdditiveExpr-prime:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/AdditiveExpr']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="AdditiveExpr-repeat">
            <xsl:with-param name="running-value">
                <xsl:call-template name="eval">
                    <xsl:with-param name="expr" select="substring-before($argument, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="remainder" select="substring-after($argument, ';')"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="AdditiveExpr-repeat">
        <xsl:param name="running-value"/>
        <xsl:param name="remainder"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="string-length($remainder) = 0">
                <xsl:value-of select="$running-value"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="operator"
                    select="substring-after(substring-before($remainder, ';'), ':')"/>
                <xsl:variable name="arguments" select="substring-after($remainder, ';')"/>
                <xsl:variable name="result">
                    <xsl:call-template name="arithmetic-binary">
                        <xsl:with-param name="lhs" select="$running-value"/>
                        <xsl:with-param name="rhs">
                            <xsl:call-template name="eval">
                                <xsl:with-param name="expr"
                                    select="substring-before($arguments, ';')"/>
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="operator" select="$operator"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="AdditiveExpr-repeat">
                    <xsl:with-param name="running-value" select="$result"/>
                    <xsl:with-param name="remainder" select="substring-after($arguments, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--                    -->
    <!-- MultiplicativeExpr -->
    <!--                    -->
    <MultiplicativeExpr:rule>
        <sequence>
            <nonterminal name="UnaryExpr"/>
            <nonterminal name="MultiplicativeExpr-prime" unwrap="true"/>
        </sequence>
    </MultiplicativeExpr:rule>
    <MultiplicativeExpr-prime:rule>
        <sequence>
            <literal value="*"/>
            <nonterminal name="UnaryExpr"/>
            <nonterminal name="MultiplicativeExpr-prime" unwrap="true"/>
        </sequence>
        <sequence>
            <literal value="div" type="alphanumeric"/>
            <nonterminal name="UnaryExpr"/>
            <nonterminal name="MultiplicativeExpr-prime" unwrap="true"/>
        </sequence>
        <sequence>
            <literal value="mod" type="alphanumeric"/>
            <nonterminal name="UnaryExpr"/>
            <nonterminal name="MultiplicativeExpr-prime" unwrap="true"/>
        </sequence>
        <sequence/>
    </MultiplicativeExpr-prime:rule>

    <xsl:template
        match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/MultiplicativeExpr']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="MultiplicativeExpr-repeat">
            <xsl:with-param name="running-value">
                <xsl:call-template name="eval">
                    <xsl:with-param name="expr" select="substring-before($argument, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="remainder" select="substring-after($argument, ';')"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="MultiplicativeExpr-repeat">
        <xsl:param name="running-value"/>
        <xsl:param name="remainder"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="string-length($remainder) = 0">
                <xsl:value-of select="$running-value"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="operator"
                    select="substring-after(substring-before($remainder, ';'), ':')"/>
                <xsl:variable name="arguments" select="substring-after($remainder, ';')"/>
                <xsl:variable name="result">
                    <xsl:call-template name="arithmetic-binary">
                        <xsl:with-param name="lhs" select="$running-value"/>
                        <xsl:with-param name="rhs">
                            <xsl:call-template name="eval">
                                <xsl:with-param name="expr"
                                    select="substring-before($arguments, ';')"/>
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="operator" select="$operator"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="MultiplicativeExpr-repeat">
                    <xsl:with-param name="running-value" select="$result"/>
                    <xsl:with-param name="remainder" select="substring-after($arguments, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--           -->
    <!-- UnaryExpr -->
    <!--           -->
    <UnaryExpr:rule>
        <sequence name="plus">
            <nonterminal name="UnionExpr"/>
        </sequence>
        <sequence name="minus">
            <literal value="-"/>
            <nonterminal name="UnaryExpr"/>
        </sequence>
    </UnaryExpr:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/UnaryExpr']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="$alternation = 'plus'">
                <xsl:call-template name="eval">
                    <xsl:with-param name="expr" select="$argument"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$alternation = 'minus'">
                <xsl:variable name="result">
                    <xsl:call-template name="cast-number">
                        <xsl:with-param name="expr">
                            <xsl:call-template name="eval">
                                <xsl:with-param name="expr" select="substring-after($argument, ';')"/>
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="construct-number">
                    <xsl:with-param name="expr" select="-$result"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!--           -->
    <!-- UnionExpr -->
    <!--           -->
    <UnionExpr:rule>
        <sequence>
            <nonterminal name="PathExpr"/>
            <nonterminal name="UnionExpr-prime" unwrap="true"/>
        </sequence>
    </UnionExpr:rule>
    <UnionExpr-prime:rule>
        <sequence>
            <literal value="|"/>
            <nonterminal name="PathExpr"/>
            <nonterminal name="UnionExpr-prime" unwrap="true"/>
        </sequence>
        <sequence/>
    </UnionExpr-prime:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/UnionExpr']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="UnionExpr-repeat">
            <xsl:with-param name="running-value">
                <xsl:call-template name="eval">
                    <xsl:with-param name="expr" select="substring-before($argument, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="remainder" select="substring-after($argument, ';')"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="UnionExpr-repeat">
        <xsl:param name="running-value"/>
        <xsl:param name="remainder"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="string-length($remainder) = 0">
                <xsl:value-of select="$running-value"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="arguments" select="substring-after($remainder, ';')"/>
                <xsl:variable name="rhs">
                    <xsl:call-template name="eval">
                        <xsl:with-param name="expr" select="substring-before($arguments, ';')"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="result">
                    <xsl:call-template name="union">
                        <xsl:with-param name="lhs" select="$running-value"/>
                        <xsl:with-param name="rhs" select="$rhs"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="UnionExpr-repeat">
                    <xsl:with-param name="running-value" select="$result"/>
                    <xsl:with-param name="remainder" select="substring-after($arguments, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <!--          -->
    <!-- PathExpr -->
    <!--          -->
    <PathExpr:rule>
        <sequence name="FilterPathDescendant">
            <nonterminal name="FilterExpr"/>
            <literal value="//"/>
            <nonterminal name="RelativeLocationPath"/>
        </sequence>
        <sequence name="FilterPath">
            <nonterminal name="FilterExpr"/>
            <literal value="/"/>
            <nonterminal name="RelativeLocationPath"/>
        </sequence>
        <sequence name="Filter">
            <nonterminal name="FilterExpr"/>
        </sequence>
        <sequence name="LocationPath">
            <nonterminal name="LocationPath"/>
        </sequence>
    </PathExpr:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/PathExpr']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="$alternation = 'Filter' or $alternation = 'LocationPath'">
                <xsl:call-template name="eval">
                    <xsl:with-param name="expr" select="$argument"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="running-value">
                    <xsl:call-template name="eval">
                        <xsl:with-param name="expr" select="substring-before($argument, ';')"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="running-value-type">
                    <xsl:call-template name="value-type">
                        <xsl:with-param name="expr" select="$running-value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:if test="$running-value-type != 'nodeset'">
                    <xsl:message terminate="yes">
                        <xsl:text>Expected nodeset in PathExpr</xsl:text>
                    </xsl:message>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="substring-after(substring-before($argument, ';'), ':') = '/'">
                        <xsl:call-template name="location-path">
                            <xsl:with-param name="running-value"
                                select="substring-after($running-value, ':')"/>
                            <xsl:with-param name="continue-expr"
                                select="substring-after(substring-after($argument, ';'), ';')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="substring-after(substring-before($argument, ';'), ':') = '//'">
                        <xsl:call-template name="slash-slash-location-path">
                            <xsl:with-param name="running-value"
                                select="substring-after($running-value, ':')"/>
                            <xsl:with-param name="continue-expr"
                                select="substring-after(substring-after($argument, ';'), ';')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--            -->
    <!-- FilterExpr -->
    <!--            -->
    <FilterExpr:rule>
        <sequence>
            <nonterminal name="PrimaryExpr"/>
            <nonterminal name="FilterExpr-prime" unwrap="true"/>
        </sequence>
    </FilterExpr:rule>
    <FilterExpr-prime:rule>
        <sequence>
            <nonterminal name="Predicate"/>
            <nonterminal name="FilterExpr-prime" unwrap="true"/>
        </sequence>
        <sequence/>
    </FilterExpr-prime:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/FilterExpr']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="FilterExpr-repeat">
            <xsl:with-param name="running-value">
                <xsl:call-template name="eval">
                    <xsl:with-param name="expr" select="substring-before($argument, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="remainder" select="substring-after($argument, ';')"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="FilterExpr-repeat">
        <xsl:param name="running-value"/>
        <xsl:param name="remainder"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="string-length($remainder) = 0">
                <xsl:value-of select="$running-value"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="running-value-type">
                    <xsl:call-template name="value-type">
                        <xsl:with-param name="expr" select="$running-value"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:if test="$running-value-type != 'nodeset'">
                    <xsl:message terminate="yes">
                        <xsl:text>Expected nodeset in FilterExpr</xsl:text>
                    </xsl:message>
                </xsl:if>

                <xsl:variable name="arguments" select="$remainder"/>

                <xsl:variable name="result">
                    <xsl:call-template name="filter">
                        <xsl:with-param name="running-value" select="$running-value"/>
                        <xsl:with-param name="filter-expr">
                            <xsl:call-template name="eval">
                                <xsl:with-param name="expr"
                                    select="substring-before($arguments, ';')"/>
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        <xsl:with-param name="axis" select="'child'"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:call-template name="FilterExpr-repeat">
                    <xsl:with-param name="running-value" select="$result"/>
                    <xsl:with-param name="remainder" select="substring-after($arguments, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


    <!--              -->
    <!-- LocationPath -->
    <!--              -->
    <LocationPath:rule>
        <sequence name="Relative">
            <nonterminal name="RelativeLocationPath"/>
        </sequence>
        <sequence name="AbsoluteAny">
            <literal value="//"/>
            <nonterminal name="RelativeLocationPath"/>
        </sequence>
        <sequence name="Absolute">
            <literal value="/"/>
            <nonterminal name="RelativeLocationPath"/>
        </sequence>
        <sequence name="RootOnly">
            <literal value="/"/>
        </sequence>
    </LocationPath:rule>

    <!--                     -->
    <!-- LocationPathPattern -->
    <!--                     -->
    <LocationPathPattern:rule>
        <sequence name="IdKeyAny">
            <nonterminal name="IdKeyPattern"/>
            <literal value="//"/>
            <nonterminal name="RelativePathPattern"/>
        </sequence>
        <sequence name="IdKey">
            <nonterminal name="IdKeyPattern"/>
            <literal value="/"/>
            <nonterminal name="RelativePathPattern"/>
        </sequence>
        <sequence name="IdKeyOnly">
            <nonterminal name="IdKeyPattern"/>
        </sequence>
        <sequence name="Relative">
            <nonterminal name="RelativePathPattern"/>
        </sequence>
        <sequence name="AbsoluteAny">
            <literal value="//"/>
            <nonterminal name="RelativePathPattern"/>
        </sequence>
        <sequence name="Absolute">
            <literal value="/"/>
            <nonterminal name="RelativePathPattern"/>
        </sequence>
        <sequence name="RootOnly">
            <literal value="/"/>
        </sequence>
    </LocationPathPattern:rule>

    <xsl:template
        match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/LocationPath'
                        or namespace-uri()='http://futzle.com/2006/xslt-grammar/LocationPathPattern']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="$alternation = 'RootOnly'">
                <xsl:variable name="document-root">
                    <xsl:call-template name="document-root">
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat('NS:', $document-root)"/>
            </xsl:when>
            <xsl:when test="$alternation = 'AbsoluteAny'">
                <xsl:variable name="document-root">
                    <xsl:call-template name="document-root">
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="slash-slash-location-path">
                    <xsl:with-param name="running-value" select="$document-root"/>
                    <xsl:with-param name="continue-expr" select="substring-after($argument, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="running-context">
                    <xsl:choose>
                        <xsl:when test="$alternation = 'Relative'">
                            <xsl:call-template name="context-node">
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$alternation = 'Absolute'">
                            <xsl:call-template name="document-root">
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            </xsl:call-template>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="path-expr">
                    <xsl:choose>
                        <xsl:when test="$alternation = 'Relative'">
                            <xsl:value-of select="$argument"/>
                        </xsl:when>
                        <xsl:when test="$alternation = 'Absolute' or $alternation = 'AbsoluteAny'">
                            <xsl:value-of select="substring-after($argument, ';')"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>

                <xsl:call-template name="location-path">
                    <xsl:with-param name="running-value" select="$running-context"/>
                    <xsl:with-param name="continue-expr" select="$path-expr"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--                      -->
    <!-- RelativeLocationPath -->
    <!--                      -->
    <RelativeLocationPath:rule>
        <sequence>
            <nonterminal name="Step"/>
            <nonterminal name="RelativeLocationPath-prime" unwrap="true"/>
        </sequence>
    </RelativeLocationPath:rule>
    <RelativeLocationPath-prime:rule>
        <sequence>
            <literal value="//"/>
            <nonterminal name="Step"/>
            <nonterminal name="RelativeLocationPath-prime" unwrap="true"/>
        </sequence>
        <sequence>
            <literal value="/"/>
            <nonterminal name="Step"/>
            <nonterminal name="RelativeLocationPath-prime" unwrap="true"/>
        </sequence>
        <sequence/>
    </RelativeLocationPath-prime:rule>

    <!--                     -->
    <!-- RelativePathPattern -->
    <!--                     -->
    <RelativePathPattern:rule>
        <sequence>
            <nonterminal name="StepPattern"/>
            <nonterminal name="RelativePathPattern-prime" unwrap="true"/>
        </sequence>
    </RelativePathPattern:rule>
    <RelativePathPattern-prime:rule>
        <sequence>
            <literal value="//"/>
            <nonterminal name="StepPattern"/>
            <nonterminal name="RelativePathPattern-prime" unwrap="true"/>
        </sequence>
        <sequence>
            <literal value="/"/>
            <nonterminal name="StepPattern"/>
            <nonterminal name="RelativePathPattern-prime" unwrap="true"/>
        </sequence>
        <sequence/>
    </RelativePathPattern-prime:rule>

    <xsl:template
        match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/RelativeLocationPath'
              or namespace-uri()='http://futzle.com/2006/xslt-grammar/RelativePathPattern']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="RelativeLocationPath-repeat">
            <xsl:with-param name="running-value">
                <xsl:call-template name="eval">
                    <xsl:with-param name="expr" select="substring-before($argument, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="remainder" select="substring-after($argument, ';')"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="RelativeLocationPath-repeat">
        <xsl:param name="running-value"/>
        <xsl:param name="remainder"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="string-length($remainder) = 0">
                <xsl:value-of select="$running-value"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="running-value-type">
                    <xsl:call-template name="value-type">
                        <xsl:with-param name="expr" select="$running-value"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:if test="$running-value-type != 'nodeset'">
                    <xsl:message terminate="yes">
                        <xsl:text>Expected nodeset in RelativeLocationPath</xsl:text>
                    </xsl:message>
                </xsl:if>

                <xsl:variable name="remainder-encoded">
                    <xsl:call-template name="encode">
                        <xsl:with-param name="expr" select="substring-after($remainder, ';')"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:choose>
                    <xsl:when test="substring-after(substring-before($remainder, ';'), ':') = '/'">
                        <xsl:call-template name="location-path">
                            <xsl:with-param name="running-value"
                                select="substring-after($running-value, ':')"/>
                            <xsl:with-param name="continue-expr"
                                select="concat('RelativeLocationPath:1:', $remainder-encoded)"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="substring-after(substring-before($remainder, ';'), ':') = '//'">
                        <xsl:call-template name="slash-slash-location-path">
                            <xsl:with-param name="running-value"
                                select="substring-after($running-value, ':')"/>
                            <xsl:with-param name="continue-expr"
                                select="concat('RelativeLocationPath:1:', $remainder-encoded)"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--      -->
    <!-- Step -->
    <!--      -->
    <Step:rule>
        <sequence name="DotDot">
            <literal value=".."/>
        </sequence>
        <sequence name="Dot">
            <literal value="."/>
        </sequence>
        <sequence name="Normal">
            <nonterminal name="AxisSpecifier"/>
            <nonterminal name="NodeTest"/>
            <nonterminal name="Predicate-star" unwrap="true"/>
        </sequence>
    </Step:rule>

    <!--             -->
    <!-- StepPattern -->
    <!--             -->
    <StepPattern:rule>
        <sequence name="Normal">
            <nonterminal name="ChildOrAttributeAxisSpecifier"/>
            <nonterminal name="NodeTest"/>
            <nonterminal name="Predicate-star" unwrap="true"/>
        </sequence>
    </StepPattern:rule>

    <xsl:template
        match="*[namespace-uri() = 'http://futzle.com/2006/xslt-grammar/Step'
                        or namespace-uri() = 'http://futzle.com/2006/xslt-grammar/StepPattern']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="$alternation = 'DotDot'">
                <xsl:call-template name="location-path-step">
                    <xsl:with-param name="axis" select="'parent'"/>
                    <xsl:with-param name="node-type" select="'node'"/>
                    <xsl:with-param name="namespace" select="*"/>
                    <xsl:with-param name="local-name" select="*"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$alternation = 'Dot'">
                <xsl:call-template name="location-path-step">
                    <xsl:with-param name="axis" select="'self'"/>
                    <xsl:with-param name="node-type" select="'node'"/>
                    <xsl:with-param name="namespace" select="*"/>
                    <xsl:with-param name="local-name" select="*"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="axis">
                    <xsl:call-template name="eval">
                        <xsl:with-param name="expr" select="substring-before($argument, ';')"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="node-test">
                    <xsl:call-template name="eval">
                        <xsl:with-param name="expr"
                            select="substring-before(substring-after($argument, ';'), ';')"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="namespace">
                    <xsl:choose>
                        <xsl:when
                            test="$axis = 'attribute' and starts-with(substring-after($node-test, ':'), '{}')">
                            <!-- Attributes without a namespace tag do not take the default namespace. -->
                            <xsl:value-of select="''"/>
                        </xsl:when>
                        <xsl:when
                            test="$axis != 'namespace' and starts-with(substring-after($node-test, ':'), '{}')">
                            <!-- Elements without a namespace tag take the default namespace, if it exists. --> 
                            <xsl:variable name="namespace-check">
                                <xsl:call-template name="hash-lookup">
                                    <xsl:with-param name="hash">
                                        <xsl:call-template name="hash-lookup">
                                            <xsl:with-param name="hash" select="$context"/>
                                            <xsl:with-param name="key" select="'namespaces'"/>
                                        </xsl:call-template>
                                    </xsl:with-param>
                                    <xsl:with-param name="key" select="''"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="$namespace-check = '-'">
                                    <xsl:value-of select="''"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$namespace-check"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="starts-with(substring-after($node-test, ':'), '{')">
                            <xsl:call-template name="decode">
                                <xsl:with-param name="expr">
                                    <xsl:value-of
                                        select="substring-before(substring-after($node-test, ':{'), '}')"
                                    />
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'*'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="local-name">
                    <xsl:choose>
                        <xsl:when test="starts-with(substring-after($node-test, ':'), '{')">
                            <xsl:value-of select="substring-after($node-test, '}')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring-after($node-test, ':')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="Step-repeat">
                    <xsl:with-param name="running-value">
                        <xsl:call-template name="location-path-step">
                            <xsl:with-param name="axis" select="$axis"/>
                            <xsl:with-param name="node-type"
                                select="substring-before($node-test, ':')"/>
                            <xsl:with-param name="namespace" select="$namespace"/>
                            <xsl:with-param name="local-name" select="$local-name"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="remainder"
                        select="substring-after(substring-after($argument, ';'), ';')"/>
                    <xsl:with-param name="axis" select="$axis"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="Step-repeat">
        <xsl:param name="running-value"/>
        <xsl:param name="remainder"/>
        <xsl:param name="axis"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="string-length($remainder) = 0">
                <xsl:value-of select="$running-value"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="Step-repeat">
                    <xsl:with-param name="running-value">
                        <xsl:call-template name="filter">
                            <xsl:with-param name="running-value" select="$running-value"/>
                            <xsl:with-param name="filter-expr">
                                <xsl:call-template name="eval">
                                    <xsl:with-param name="expr"
                                        select="substring-before($remainder, ';')"/>
                                    <xsl:with-param name="context" select="$context"/>
                                    <xsl:with-param name="document" select="$document"/>
                                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                                </xsl:call-template>
                            </xsl:with-param>
                            <xsl:with-param name="axis" select="$axis"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="remainder" select="substring-after($remainder, ';')"/>
                    <xsl:with-param name="axis" select="$axis"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--               -->
    <!-- AxisSpecifier -->
    <!--               -->
    <AxisSpecifier:rule>
        <sequence name="Named">
            <nonterminal name="AxisName" unwrap="true"/>
            <literal value="::"/>
        </sequence>
        <sequence name="AttributeAbbrev">
            <literal value="@"/>
        </sequence>
        <sequence name="ChildAbbrev"/>
    </AxisSpecifier:rule>

    <!--                               -->
    <!-- ChildOrAttributeAxisSpecifier -->
    <!--                               -->
    <ChildOrAttributeAxisSpecifier:rule>
        <sequence name="Named">
            <literal value="attribute" type="alphanumeric"/>
            <literal value="::"/>
        </sequence>
        <sequence name="Named">
            <literal value="child" type="alphanumeric"/>
            <literal value="::"/>
        </sequence>
        <sequence name="AttributeAbbrev">
            <literal value="@"/>
        </sequence>
        <sequence name="ChildAbbrev"/>
    </ChildOrAttributeAxisSpecifier:rule>

    <xsl:template
        match="*[namespace-uri() = 'http://futzle.com/2006/xslt-grammar/AxisSpecifier'
                        or namespace-uri() = 'http://futzle.com/2006/xslt-grammar/ChildOrAttributeAxisSpecifier']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>

        <!-- Expand out abbreviated forms so that caller doesn't have to deal with them. -->
        <xsl:choose>
            <xsl:when test="$alternation = 'ChildAbbrev'">
                <xsl:value-of select="'child'"/>
            </xsl:when>
            <xsl:when test="$alternation = 'AttributeAbbrev'">
                <xsl:value-of select="'attribute'"/>
            </xsl:when>
            <xsl:when test="$alternation = 'Named'">
                <xsl:value-of select="substring-after(substring-before($argument, ';'), ':')"/>
            </xsl:when>
        </xsl:choose>

    </xsl:template>


    <!--          -->
    <!-- AxisName -->
    <!--          -->
    <AxisName:rule>
        <sequence>
            <literal value="ancestor-or-self" type="alphanumeric"/>
        </sequence>
        <sequence>
            <literal value="ancestor" type="alphanumeric"/>
        </sequence>
        <sequence>
            <literal value="attribute" type="alphanumeric"/>
        </sequence>
        <sequence>
            <literal value="child" type="alphanumeric"/>
        </sequence>
        <sequence>
            <literal value="descendant-or-self" type="alphanumeric"/>
        </sequence>
        <sequence>
            <literal value="descendant" type="alphanumeric"/>
        </sequence>
        <sequence>
            <literal value="following-sibling" type="alphanumeric"/>
        </sequence>
        <sequence>
            <literal value="following" type="alphanumeric"/>
        </sequence>
        <sequence>
            <literal value="namespace" type="alphanumeric"/>
        </sequence>
        <sequence>
            <literal value="parent" type="alphanumeric"/>
        </sequence>
        <sequence>
            <literal value="preceding-sibling" type="alphanumeric"/>
        </sequence>
        <sequence>
            <literal value="preceding" type="alphanumeric"/>
        </sequence>
        <sequence>
            <literal value="self" type="alphanumeric"/>
        </sequence>
    </AxisName:rule>


    <!--          -->
    <!-- NodeTest -->
    <!--          -->
    <NodeTest:rule>
        <sequence name="Any">
            <literal value="*"/>
        </sequence>
        <sequence name="AnyNS">
            <nonterminal name="NCName" unwrap="true"/>
            <literal value=":"/>
            <literal value="*"/>
        </sequence>
        <sequence name="ProcessingInstructionLiteral">
            <literal value="processing-instruction" type="alphanumeric"/>
            <literal value="("/>
            <nonterminal name="Literal"/>
            <literal value=")"/>
        </sequence>
        <sequence name="NodeType">
            <nonterminal name="NodeType" unwrap="true"/>
            <literal value="("/>
            <literal value=")"/>
        </sequence>
        <sequence name="QName">
            <nonterminal name="QName"/>
        </sequence>
    </NodeTest:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/NodeTest']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="$alternation = 'Any'">
                <xsl:value-of select="'default:*'"/>
            </xsl:when>
            <xsl:when test="$alternation = 'AnyNS'">
                <xsl:variable name="namespace-tag"
                    select="substring-after(substring-before($argument, ';'), ':')"/>
                <xsl:variable name="namespace-uri">
                    <xsl:call-template name="namespace-tag-to-uri">
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="namespace-tag" select="$namespace-tag"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat('default:{', $namespace-uri, '}*')"/>
            </xsl:when>
            <xsl:when test="$alternation = 'QName'">
                <xsl:variable name="name">
                    <xsl:call-template name="eval">
                        <xsl:with-param name="expr" select="$argument"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat('default:', $name)"/>
            </xsl:when>
            <xsl:when test="$alternation = 'NodeType'">
                <xsl:value-of
                    select="concat(substring-after(substring-before($argument, ';'), ':'), ':*')"/>
            </xsl:when>
            <xsl:when test="$alternation = 'ProcessingInstructionLiteral'">
                <xsl:variable name="name">
                    <xsl:call-template name="eval">
                        <xsl:with-param name="expr"
                            select="substring-before(substring-after(substring-after($argument, ';'), ';'), ';')"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of
                    select="concat('processing-instruction:', substring-after($name, ':'))"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>



    <!--          -->
    <!-- NodeType -->
    <!--          -->
    <NodeType:rule>
        <sequence>
            <literal value="comment" type="alphanumeric"/>
        </sequence>
        <sequence>
            <literal value="text" type="alphanumeric"/>
        </sequence>
        <sequence>
            <literal value="processing-instruction" type="alphanumeric"/>
        </sequence>
        <sequence>
            <literal value="node" type="alphanumeric"/>
        </sequence>
    </NodeType:rule>

    <Predicate-star:rule>
        <sequence>
            <nonterminal name="Predicate"/>
            <nonterminal name="Predicate-star" unwrap="true"/>
        </sequence>
        <sequence/>
    </Predicate-star:rule>

    <Predicate:rule>
        <sequence>
            <literal value="["/>
            <nonterminal name="PredicateExpr"/>
            <literal value="]"/>
        </sequence>
    </Predicate:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/Predicate']">
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="eval">
            <xsl:with-param name="expr"
                select="substring-before(substring-after($argument, ';'), ';')"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <PredicateExpr:rule>
        <sequence>
            <nonterminal name="Expr"/>
        </sequence>
    </PredicateExpr:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/PredicateExpr']">
        <xsl:param name="argument"/>

        <xsl:value-of select="$argument"/>
    </xsl:template>


    <!--         -->
    <!-- Literal -->
    <!--         -->
    <Literal:rule>
        <sequence>
            <literal value="&apos;"/>
            <literal-span until="&apos;"/>
            <literal value="&apos;"/>
        </sequence>
        <sequence>
            <literal value="&quot;"/>
            <literal-span until="&quot;"/>
            <literal value="&quot;"/>
        </sequence>
    </Literal:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/Literal']">
        <xsl:param name="argument"/>
        <xsl:variable name="value">
            <xsl:call-template name="decode">
                <xsl:with-param name="expr"
                    select="concat('S:', substring-after(substring-before(substring-after($argument, ';'), ';'), ':'))"
                />
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$value"/>
    </xsl:template>

    <!--        -->
    <!-- Number -->
    <!--        -->
    <Number:rule>
        <sequence name="both">
            <literal-digits/>
            <literal value="."/>
            <literal-digits/>
        </sequence>
        <sequence name="before">
            <literal-digits/>
            <literal value="."/>
        </sequence>
        <sequence name="after">
            <literal value="."/>
            <literal-digits/>
        </sequence>
        <sequence name="neither">
            <literal-digits/>
        </sequence>
    </Number:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/Number']">
        <xsl:param name="alternation"/>
        <xsl:param name="argument"/>

        <xsl:variable name="string-representation">
            <xsl:choose>
                <xsl:when test="$alternation = 'both'">
                    <xsl:value-of
                        select="concat(substring-after(substring-before($argument, ';'), ':'),
                    '.',
                    substring-after(substring-after(substring-after($argument, ';'), ';'), ':'))"
                    />
                </xsl:when>
                <xsl:when test="$alternation = 'before'">
                    <xsl:value-of
                        select="concat(substring-after(substring-before($argument, ';'), ':'),
                    '.')"
                    />
                </xsl:when>
                <xsl:when test="$alternation = 'after'">
                    <xsl:value-of
                        select="concat('.',
                    substring-after(substring-after($argument, ';'), ':'))"
                    />
                </xsl:when>
                <xsl:when test="$alternation = 'neither'">
                    <xsl:value-of select="substring-after($argument, ':')"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat('N:', string(number($string-representation)))"/>
    </xsl:template>

    <!--              -->
    <!-- FunctionName -->
    <!--              -->
    <FunctionName:rule>
        <sequence name="NS">
            <literal-ncname/>
            <literal value=":"/>
            <literal-ncname/>
        </sequence>
        <sequence name="NoNS">
            <literal-ncname except=" comment text processing-instruction node "/>
        </sequence>
    </FunctionName:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/FunctionName']">
        <xsl:param name="argument"/>
        <xsl:param name="alternation"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="$alternation = 'NS'">
                <xsl:variable name="namespace-tag"
                    select="substring-after(substring-before($argument, ';'), ':')"/>
                <xsl:variable name="namespace-uri">
                    <xsl:call-template name="encode">
                        <xsl:with-param name="expr">
                            <xsl:call-template name="namespace-tag-to-uri">
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="namespace-tag" select="$namespace-tag"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="name"
                    select="substring-after(substring-after(substring-after($argument, ';'), ';'), ':')"/>
                <xsl:value-of select="concat('{', $namespace-uri, '}', $name)"/>
            </xsl:when>
            <xsl:when test="$alternation = 'NoNS'">
                <xsl:value-of select="concat('{}', substring-after($argument, ':'))"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <!--                   -->
    <!-- VariableReference -->
    <!--                   -->
    <VariableReference:rule>
        <sequence>
            <literal value="$"/>
            <nonterminal name="QName"/>
        </sequence>
    </VariableReference:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/VariableReference']">
        <xsl:param name="argument"/>
        <xsl:param name="alternation"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>


        <xsl:variable name="variables">
            <xsl:call-template name="hash-lookup">
                <xsl:with-param name="hash" select="$context"/>
                <xsl:with-param name="key" select="'variables'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="name">
            <xsl:call-template name="eval">
                <xsl:with-param name="expr" select="substring-after($argument, ';')"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="value">
            <xsl:call-template name="hash-lookup">
                <xsl:with-param name="hash" select="$variables"/>
                <xsl:with-param name="key" select="$name"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$value = '-'">
                <xsl:message terminate="yes">
                    <xsl:text>Variable '</xsl:text>
                    <xsl:value-of select="$name"/>
                    <xsl:text>' unknown.</xsl:text>
                </xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


    <!--        -->
    <!-- NCName -->
    <!--        -->
    <NCName:rule>
        <sequence>
            <literal-ncname/>
        </sequence>
    </NCName:rule>


    <!--       -->
    <!-- QName -->
    <!--       -->
    <QName:rule>
        <sequence name="NS">
            <literal-ncname/>
            <literal value=":"/>
            <literal-ncname/>
        </sequence>
        <sequence name="NoNS">
            <literal-ncname/>
        </sequence>
    </QName:rule>

    <xsl:template match="*[namespace-uri()='http://futzle.com/2006/xslt-grammar/QName']">
        <xsl:param name="argument"/>
        <xsl:param name="alternation"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="$alternation = 'NS'">
                <!--                <xsl:value-of select="concat(substring-after(substring-before($argument, ';'), ':'),
                    ':',
                    substring-after(substring-after(substring-after($argument, ';'), ';'), ':'))"/>
-->
                <xsl:variable name="namespace-tag"
                    select="substring-after(substring-before($argument, ';'), ':')"/>
                <xsl:variable name="namespace-uri">
                    <xsl:call-template name="encode">
                        <xsl:with-param name="expr">
                            <xsl:call-template name="namespace-tag-to-uri">
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="namespace-tag" select="$namespace-tag"/>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="name"
                    select="substring-after(substring-after(substring-after($argument, ';'), ';'), ':')"/>
                <xsl:value-of select="concat('{', $namespace-uri, '}', $name)"/>
            </xsl:when>
            <xsl:when test="$alternation = 'NoNS'">
                <!--                <xsl:value-of
                    select="substring-after($argument, ':')"/>-->

                <!--                <xsl:variable name="namespace-uri">
                    <xsl:call-template name="namespace-tag-to-uri">
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="namespace-tag" select="''"/>
                    </xsl:call-template>
                </xsl:variable>
-->
                <xsl:value-of select="concat('{', '}', substring-after($argument, ':'))"/>

            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <!--         -->
    <!-- Pattern -->
    <!--         -->
    <Pattern:rule>
        <sequence>
            <nonterminal name="LocationPathPattern"/>
            <nonterminal name="Pattern-prime" unwrap="true"/>
        </sequence>
    </Pattern:rule>
    <Pattern-prime:rule>
        <sequence>
            <literal value="|"/>
            <nonterminal name="LocationPathPattern"/>
            <nonterminal name="Pattern-prime" unwrap="true"/>
        </sequence>
        <sequence/>
    </Pattern-prime:rule>





    <!--              -->
    <!-- IdKeyPattern -->
    <!--              -->
    <IdKeyPattern:rule>
        <sequence name="Id">
            <literal value="id" type="alphanumeric"/>
            <literal value="("/>
            <nonterminal name="Literal"/>
            <literal value=")"/>
        </sequence>
        <sequence name="Key">
            <literal value="key" type="alphanumeric"/>
            <literal value="("/>
            <nonterminal name="Literal"/>
            <literal value=","/>
            <nonterminal name="Literal"/>
            <literal value=")"/>
        </sequence>
    </IdKeyPattern:rule>






    <!-- support functions-->


    <xsl:template name="compare-binary">
        <xsl:param name="lhs"/>
        <xsl:param name="rhs"/>
        <xsl:param name="operator"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>


        <xsl:variable name="lhs-type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$lhs"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$lhs-type = 'nodeset'">
                <xsl:choose>
                    <xsl:when test="$lhs = 'NS:-'">
                        <xsl:call-template name="construct-boolean">
                            <xsl:with-param name="expr" select="0"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="compare-binary-repeat">
                            <xsl:with-param name="lhs"
                                select="concat(substring-after($lhs, ':'), ';')"/>
                            <xsl:with-param name="rhs" select="$rhs"/>
                            <xsl:with-param name="operator" select="$operator"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="compare-binary-lhs-atomic">
                    <xsl:with-param name="lhs">
                        <xsl:call-template name="cast-atomic">
                            <xsl:with-param name="expr" select="$lhs"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="rhs" select="$rhs"/>
                    <xsl:with-param name="operator" select="$operator"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="compare-binary-repeat">
        <xsl:param name="lhs"/>
        <xsl:param name="rhs"/>
        <xsl:param name="operator"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="contains($lhs, ';')">
                <xsl:variable name="result">
                    <xsl:call-template name="cast-boolean">
                        <xsl:with-param name="expr">
                            <xsl:call-template name="node-function">
                                <xsl:with-param name="path" select="substring-before($lhs, ';')"/>
                                <xsl:with-param name="rhs" select="$rhs"/>
                                <xsl:with-param name="operator" select="$operator"/>
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                                <xsl:with-param name="function"
                                    select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter/nodeset-compare-binary-lhs']"
                                />
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="number($result)">
                        <xsl:call-template name="construct-boolean">
                            <xsl:with-param name="expr" select="1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="compare-binary-repeat">
                            <xsl:with-param name="lhs" select="substring-after($lhs, ';')"/>
                            <xsl:with-param name="rhs" select="$rhs"/>
                            <xsl:with-param name="operator" select="$operator"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="construct-boolean">
                    <xsl:with-param name="expr" select="0"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <nodeset-compare-binary-lhs:function/>
    <xsl:template
        match="*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter/nodeset-compare-binary-lhs']">
        <xsl:param name="context-node"/>
        <xsl:param name="rhs"/>
        <xsl:param name="operator"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="compare-binary-lhs-atomic">
            <xsl:with-param name="lhs" select="$context-node"/>
            <xsl:with-param name="rhs" select="$rhs"/>
            <xsl:with-param name="operator" select="$operator"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="compare-binary-lhs-atomic">
        <xsl:param name="lhs"/>
        <xsl:param name="rhs"/>
        <xsl:param name="operator"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>


        <xsl:variable name="rhs-type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$rhs"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$rhs-type = 'nodeset'">
                <xsl:choose>
                    <xsl:when test="$rhs = 'NS:-'">
                        <xsl:call-template name="construct-boolean">
                            <xsl:with-param name="expr" select="0"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="compare-binary-lhs-atomic-repeat">
                            <xsl:with-param name="rhs"
                                select="concat(substring-after($rhs, ':'), ';')"/>
                            <xsl:with-param name="lhs" select="$lhs"/>
                            <xsl:with-param name="operator" select="$operator"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="compare-binary-both-atomic">
                    <xsl:with-param name="lhs" select="$lhs"/>
                    <xsl:with-param name="rhs">
                        <xsl:call-template name="cast-atomic">
                            <xsl:with-param name="expr" select="$rhs"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="operator" select="$operator"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="compare-binary-lhs-atomic-repeat">
        <xsl:param name="lhs"/>
        <xsl:param name="rhs"/>
        <xsl:param name="operator"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="contains($rhs, ';')">
                <xsl:variable name="result">
                    <xsl:call-template name="cast-boolean">
                        <xsl:with-param name="expr">
                            <xsl:call-template name="node-function">
                                <xsl:with-param name="path" select="substring-before($rhs, ';')"/>
                                <xsl:with-param name="lhs" select="$lhs"/>
                                <xsl:with-param name="operator" select="$operator"/>
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                                <xsl:with-param name="function"
                                    select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter/nodeset-compare-binary-rhs']"
                                />
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="number($result)">
                        <xsl:call-template name="construct-boolean">
                            <xsl:with-param name="expr" select="1"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="compare-binary-lhs-atomic-repeat">
                            <xsl:with-param name="rhs" select="substring-after($rhs, ';')"/>
                            <xsl:with-param name="lhs" select="$lhs"/>
                            <xsl:with-param name="operator" select="$operator"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="construct-boolean">
                    <xsl:with-param name="expr" select="0"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <nodeset-compare-binary-rhs:function/>
    <xsl:template
        match="*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter/nodeset-compare-binary-rhs']">
        <xsl:param name="context-node"/>
        <xsl:param name="lhs"/>
        <xsl:param name="operator"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="compare-binary-both-atomic">
            <xsl:with-param name="rhs" select="$context-node"/>
            <xsl:with-param name="lhs" select="$lhs"/>
            <xsl:with-param name="operator" select="$operator"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="compare-binary-both-atomic">
        <xsl:param name="lhs"/>
        <xsl:param name="rhs"/>
        <xsl:param name="operator"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="$operator = '='">
                <xsl:call-template name="construct-boolean">
                    <xsl:with-param name="expr" select="$lhs = $rhs"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$operator = '!='">
                <xsl:call-template name="construct-boolean">
                    <xsl:with-param name="expr" select="$lhs != $rhs"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$operator = '&lt;'">
                <xsl:call-template name="construct-boolean">
                    <xsl:with-param name="expr" select="$lhs &lt; $rhs"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$operator = '&lt;='">
                <xsl:call-template name="construct-boolean">
                    <xsl:with-param name="expr" select="$lhs &lt;= $rhs"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$operator = '&gt;'">
                <xsl:call-template name="construct-boolean">
                    <xsl:with-param name="expr" select="$lhs &gt; $rhs"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$operator = '&gt;='">
                <xsl:call-template name="construct-boolean">
                    <xsl:with-param name="expr" select="$lhs &gt;= $rhs"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="arithmetic-binary">
        <xsl:param name="lhs"/>
        <xsl:param name="rhs"/>
        <xsl:param name="operator"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:variable name="lhs-value">
            <xsl:call-template name="cast-atomic">
                <xsl:with-param name="expr" select="$lhs"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="rhs-value">
            <xsl:call-template name="cast-atomic">
                <xsl:with-param name="expr" select="$rhs"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$operator = '+'">
                <xsl:call-template name="construct-number">
                    <xsl:with-param name="expr" select="$lhs-value + $rhs-value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$operator = '-'">
                <xsl:call-template name="construct-number">
                    <xsl:with-param name="expr" select="$lhs-value - $rhs-value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$operator = '*'">
                <xsl:call-template name="construct-number">
                    <xsl:with-param name="expr" select="$lhs-value * $rhs-value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$operator = 'div'">
                <xsl:call-template name="construct-number">
                    <xsl:with-param name="expr" select="$lhs-value div $rhs-value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$operator = 'mod'">
                <xsl:call-template name="construct-number">
                    <xsl:with-param name="expr" select="$lhs-value mod $rhs-value"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="namespace-tag-to-uri">
        <xsl:param name="context"/>
        <xsl:param name="namespace-tag"/>
        <xsl:variable name="namespaces">
            <xsl:call-template name="hash-lookup">
                <xsl:with-param name="hash" select="$context"/>
                <xsl:with-param name="key" select="'namespaces'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$namespaces = '-'">
            <xsl:message terminate="yes">
                <xsl:text>No namespaces in context</xsl:text>
            </xsl:message>
        </xsl:if>
        <xsl:variable name="namespace-uri">
            <xsl:call-template name="hash-lookup">
                <xsl:with-param name="hash" select="$namespaces"/>
                <xsl:with-param name="key" select="$namespace-tag"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$namespace-uri = '-'">
            <xsl:message terminate="yes">
                <xsl:text>Namespace tag </xsl:text>
                <xsl:value-of select="$namespace-tag"/>
                <xsl:text> not in context</xsl:text>
            </xsl:message>
        </xsl:if>
        <xsl:value-of select="$namespace-uri"/>
    </xsl:template>

    <xsl:template name="location-path">
        <xsl:param name="running-value"/>
        <xsl:param name="continue-expr"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="$running-value = '-'">
                <xsl:value-of select="'NS:-'"/>
            </xsl:when>
            <xsl:when test="contains($running-value, ';')">
                <xsl:variable name="context-node" select="substring-before($running-value, ';')"/>
                <xsl:variable name="new-context">
                    <xsl:call-template name="hash-replace">
                        <xsl:with-param name="hash" select="$context"/>
                        <xsl:with-param name="key" select="'context-node'"/>
                        <xsl:with-param name="value" select="$context-node"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="result">
                    <xsl:call-template name="eval">
                        <xsl:with-param name="expr" select="$continue-expr"/>
                        <xsl:with-param name="context" select="$new-context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="remainder">
                    <xsl:call-template name="location-path">
                        <xsl:with-param name="running-value"
                            select="substring-after($running-value, ';')"/>
                        <xsl:with-param name="continue-expr" select="$continue-expr"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="union">
                    <xsl:with-param name="lhs" select="$result"/>
                    <xsl:with-param name="rhs" select="$remainder"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="new-context">
                    <xsl:call-template name="hash-replace">
                        <xsl:with-param name="hash" select="$context"/>
                        <xsl:with-param name="key" select="'context-node'"/>
                        <xsl:with-param name="value" select="$running-value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="eval">
                    <xsl:with-param name="expr" select="$continue-expr"/>
                    <xsl:with-param name="context" select="$new-context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="slash-slash-location-path">
        <xsl:param name="running-value"/>
        <xsl:param name="continue-expr"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="$running-value = '-'">
                <xsl:value-of select="'NS:-'"/>
            </xsl:when>
            <xsl:when test="contains($running-value, ';')">
                <xsl:variable name="context-node" select="substring-before($running-value, ';')"/>
                <xsl:variable name="new-context">
                    <xsl:call-template name="hash-replace">
                        <xsl:with-param name="hash" select="$context"/>
                        <xsl:with-param name="key" select="'context-node'"/>
                        <xsl:with-param name="value" select="$context-node"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="new-running-value">
                    <xsl:call-template name="location-path-step">
                        <xsl:with-param name="axis" select="'descendant-or-self'"/>
                        <xsl:with-param name="node-type" select="'default'"/>
                        <xsl:with-param name="namespace" select="'*'"/>
                        <xsl:with-param name="local-name" select="'*'"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="result">
                    <xsl:call-template name="location-path">
                        <xsl:with-param name="running-value"
                            select="substring-after($new-running-value, ':')"/>
                        <xsl:with-param name="continue-expr" select="$continue-expr"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="remainder">
                    <xsl:call-template name="slash-slash-location-path">
                        <xsl:with-param name="running-value"
                            select="substring-after($running-value, ';')"/>
                        <xsl:with-param name="continue-expr" select="$continue-expr"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="union">
                    <xsl:with-param name="lhs" select="$result"/>
                    <xsl:with-param name="rhs" select="$remainder"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="new-context">
                    <xsl:call-template name="hash-replace">
                        <xsl:with-param name="hash" select="$context"/>
                        <xsl:with-param name="key" select="'context-node'"/>
                        <xsl:with-param name="value" select="$running-value"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="new-running-value">
                    <xsl:call-template name="location-path-step">
                        <xsl:with-param name="axis" select="'descendant-or-self'"/>
                        <xsl:with-param name="node-type" select="'default'"/>
                        <xsl:with-param name="namespace" select="'*'"/>
                        <xsl:with-param name="local-name" select="'*'"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="location-path">
                    <xsl:with-param name="running-value"
                        select="substring-after($new-running-value, ':')"/>
                    <xsl:with-param name="continue-expr" select="$continue-expr"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="location-path-step">
        <xsl:param name="axis"/>
        <xsl:param name="node-type"/>
        <xsl:param name="namespace"/>
        <xsl:param name="local-name"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>


        <xsl:variable name="context-node">
            <xsl:call-template name="context-node">
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="node-function">
            <xsl:with-param name="path" select="$context-node"/>
            <xsl:with-param name="axis" select="$axis"/>
            <xsl:with-param name="node-type" select="$node-type"/>
            <xsl:with-param name="namespace" select="$namespace"/>
            <xsl:with-param name="local-name" select="$local-name"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
            <xsl:with-param name="function"
                select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter/nodeset-step']"
            />
        </xsl:call-template>
    </xsl:template>

    <nodeset-step:function/>
    <xsl:template
        match="*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter/nodeset-step']">
        <xsl:param name="context-node"/>
        <xsl:param name="axis"/>
        <xsl:param name="node-type"/>
        <xsl:param name="namespace"/>
        <xsl:param name="local-name"/>
        <xsl:param name="path"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="$axis = 'child'">
                <xsl:choose>
                    <xsl:when
                        test="$node-type = 'default' and $namespace = '*' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/child::*"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/child::*[namespace-uri() = $namespace]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $namespace = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/child::*[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/child::*[namespace-uri() = $namespace and local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'node'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/child::node()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'text'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/child::text()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'comment'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/child::comment()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'processing-instruction' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/child::processing-instruction()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'processing-instruction'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/child::processing-instruction()[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>
                            <xsl:text>Can't understand step </xsl:text>
                            <xsl:value-of select="$axis"/>
                            <xsl:text>::{</xsl:text>
                            <xsl:value-of select="$namespace"/>
                            <xsl:text>}</xsl:text>
                            <xsl:value-of select="$local-name"/>
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$axis = 'descendant'">
                <xsl:choose>
                    <xsl:when
                        test="$node-type = 'default' and $namespace = '*' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/descendant::*"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/descendant::*[namespace-uri() = $namespace]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $namespace = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/descendant::*[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/descendant::*[namespace-uri() = $namespace and local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'node'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/descendant::node()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'text'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/descendant::text()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'comment'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/descendant::comment()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'processing-instruction' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/descendant::processing-instruction()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'processing-instruction'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/descendant::processing-instruction()[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>
                            <xsl:text>Can't understand step </xsl:text>
                            <xsl:value-of select="$axis"/>
                            <xsl:text>::{</xsl:text>
                            <xsl:value-of select="$namespace"/>
                            <xsl:text>}</xsl:text>
                            <xsl:value-of select="$local-name"/>
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$axis = 'parent'">
                <xsl:choose>
                    <xsl:when
                        test="$node-type = 'default' and $namespace = '*' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/parent::*"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/parent::*[namespace-uri() = $namespace]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $namespace = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/parent::*[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/parent::*[namespace-uri() = $namespace and local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'node'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/parent::node()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when
                        test="$node-type = 'text' or $node-type = 'comment' or $node-type = 'processing-instruction'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="/.."/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>
                            <xsl:text>Can't understand step </xsl:text>
                            <xsl:value-of select="$axis"/>
                            <xsl:text>::{</xsl:text>
                            <xsl:value-of select="$namespace"/>
                            <xsl:text>}</xsl:text>
                            <xsl:value-of select="$local-name"/>
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$axis = 'ancestor'">
                <xsl:choose>
                    <xsl:when
                        test="$node-type = 'default' and $namespace = '*' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/ancestor::*"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/ancestor::*[namespace-uri() = $namespace]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $namespace = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/ancestor::*[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/ancestor::*[namespace-uri() = $namespace and local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'node'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/ancestor::node()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when
                        test="$node-type = 'text' or $node-type = 'comment' or $node-type = 'processing-instruction'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="/.."/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>
                            <xsl:text>Can't understand step </xsl:text>
                            <xsl:value-of select="$axis"/>
                            <xsl:text>::{</xsl:text>
                            <xsl:value-of select="$namespace"/>
                            <xsl:text>}</xsl:text>
                            <xsl:value-of select="$local-name"/>
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$axis = 'following-sibling'">
                <xsl:choose>
                    <xsl:when
                        test="$node-type = 'default' and $namespace = '*' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/following-sibling::*"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/following-sibling::*[namespace-uri() = $namespace]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $namespace = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/following-sibling::*[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/following-sibling::*[namespace-uri() = $namespace and local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'node'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/following-sibling::node()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'text'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/following-sibling::text()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'comment'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/following-sibling::comment()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'processing-instruction' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/following-sibling::processing-instruction()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'processing-instruction'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/following-sibling::processing-instruction()[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>
                            <xsl:text>Can't understand step </xsl:text>
                            <xsl:value-of select="$axis"/>
                            <xsl:text>::{</xsl:text>
                            <xsl:value-of select="$namespace"/>
                            <xsl:text>}</xsl:text>
                            <xsl:value-of select="$local-name"/>
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$axis = 'preceding-sibling'">
                <xsl:choose>
                    <xsl:when
                        test="$node-type = 'default' and $namespace = '*' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/preceding-sibling::*"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/preceding-sibling::*[namespace-uri() = $namespace]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $namespace = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/preceding-sibling::*[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/preceding-sibling::*[namespace-uri() = $namespace and local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'node'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/preceding-sibling::node()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'text'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/preceding-sibling::text()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'comment'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/preceding-sibling::comment()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'processing-instruction' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/preceding-sibling::processing-instruction()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'processing-instruction'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/preceding-sibling::processing-instruction()[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>
                            <xsl:text>Can't understand step </xsl:text>
                            <xsl:value-of select="$axis"/>
                            <xsl:text>::{</xsl:text>
                            <xsl:value-of select="$namespace"/>
                            <xsl:text>}</xsl:text>
                            <xsl:value-of select="$local-name"/>
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$axis = 'following'">
                <xsl:choose>
                    <xsl:when
                        test="$node-type = 'default' and $namespace = '*' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/following::*"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/following::*[namespace-uri() = $namespace]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $namespace = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/following::*[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/following::*[namespace-uri() = $namespace and local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'node'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/following::node()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'text'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/following::text()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'comment'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/following::comment()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'processing-instruction' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/following::processing-instruction()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'processing-instruction'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/following::processing-instruction()[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>
                            <xsl:text>Can't understand step </xsl:text>
                            <xsl:value-of select="$axis"/>
                            <xsl:text>::{</xsl:text>
                            <xsl:value-of select="$namespace"/>
                            <xsl:text>}</xsl:text>
                            <xsl:value-of select="$local-name"/>
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$axis = 'preceding'">
                <xsl:choose>
                    <xsl:when
                        test="$node-type = 'default' and $namespace = '*' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/preceding::*"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/preceding::*[namespace-uri() = $namespace]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $namespace = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/preceding::*[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/preceding::*[namespace-uri() = $namespace and local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'node'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/preceding::node()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'text'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/preceding::text()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'comment'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/preceding::comment()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'processing-instruction' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/preceding::processing-instruction()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'processing-instruction'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/preceding::processing-instruction()[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>
                            <xsl:text>Can't understand step </xsl:text>
                            <xsl:value-of select="$axis"/>
                            <xsl:text>::{</xsl:text>
                            <xsl:value-of select="$namespace"/>
                            <xsl:text>}</xsl:text>
                            <xsl:value-of select="$local-name"/>
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$axis = 'attribute'">
                <xsl:choose>
                    <xsl:when
                        test="$node-type = 'default' and $namespace = '*' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/attribute::*"/>
                            <xsl:with-param name="node-type" select="'attribute'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/attribute::*[namespace-uri() = $namespace]"/>
                            <xsl:with-param name="node-type" select="'attribute'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $namespace = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/attribute::*[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'attribute'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/attribute::*[namespace-uri() = $namespace and local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'attribute'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'node'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/attribute::node()"/>
                            <xsl:with-param name="node-type" select="'attribute'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when
                        test="$node-type = 'text' or $node-type = 'comment' or $node-type = 'processing-instruction'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="/.."/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$axis = 'namespace'">
                <xsl:choose>
                    <xsl:when
                        test="$node-type = 'default' and $namespace = '' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/namespace::*"/>
                            <xsl:with-param name="node-type" select="'namespace'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $namespace = ''">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/namespace::*[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'namespace'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'node'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/namespace::node()"/>
                            <xsl:with-param name="node-type" select="'namespace'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when
                        test="$node-type = 'text' or $node-type = 'comment' or $node-type = 'processing-instruction'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="/.."/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$axis = 'self'">
                <xsl:choose>
                    <xsl:when
                        test="$node-type = 'default' and $namespace = '*' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/self::*"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/self::*[namespace-uri() = $namespace]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $namespace = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/self::*[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/self::*[namespace-uri() = $namespace and local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'node'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/self::node()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'text'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/self::text()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'comment'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset" select="$context-node/self::comment()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'processing-instruction' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/self::processing-instruction()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'processing-instruction'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/self::processing-instruction()[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>
                            <xsl:text>Can't understand step </xsl:text>
                            <xsl:value-of select="$axis"/>
                            <xsl:text>::{</xsl:text>
                            <xsl:value-of select="$namespace"/>
                            <xsl:text>}</xsl:text>
                            <xsl:value-of select="$local-name"/>
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$axis = 'descendant-or-self'">
                <xsl:choose>
                    <xsl:when
                        test="$node-type = 'default' and $namespace = '*' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/descendant-or-self::*"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/descendant-or-self::*[namespace-uri() = $namespace]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $namespace = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/descendant-or-self::*[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/descendant-or-self::*[namespace-uri() = $namespace and local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'node'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/descendant-or-self::node()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'text'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/descendant-or-self::text()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'comment'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/descendant-or-self::comment()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'processing-instruction' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/descendant-or-self::processing-instruction()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'processing-instruction'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/descendant-or-self::processing-instruction()[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>
                            <xsl:text>Can't understand step </xsl:text>
                            <xsl:value-of select="$axis"/>
                            <xsl:text>::{</xsl:text>
                            <xsl:value-of select="$namespace"/>
                            <xsl:text>}</xsl:text>
                            <xsl:value-of select="$local-name"/>
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$axis = 'ancestor-or-self'">
                <xsl:choose>
                    <xsl:when
                        test="$node-type = 'default' and $namespace = '*' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/ancestor-or-self::*"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/ancestor-or-self::*[namespace-uri() = $namespace]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default' and $namespace = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/ancestor-or-self::*[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'default'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/ancestor-or-self::*[namespace-uri() = $namespace and local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'node'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/ancestor-or-self::node()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'text'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/ancestor-or-self::text()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'comment'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/ancestor-or-self::comment()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'processing-instruction' and $local-name = '*'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/ancestor-or-self::processing-instruction()"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$node-type = 'processing-instruction'">
                        <xsl:call-template name="construct-nodeset">
                            <xsl:with-param name="nodeset"
                                select="$context-node/ancestor-or-self::processing-instruction()[local-name() = $local-name]"/>
                            <xsl:with-param name="node-type" select="'node'"/>
                            <xsl:with-param name="root" select="substring-before($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>
                            <xsl:text>Can't understand step </xsl:text>
                            <xsl:value-of select="$axis"/>
                            <xsl:text>::{</xsl:text>
                            <xsl:value-of select="$namespace"/>
                            <xsl:text>}</xsl:text>
                            <xsl:value-of select="$local-name"/>
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>

        </xsl:choose>

    </xsl:template>

    <xsl:template name="filter">
        <xsl:param name="running-value"/>
        <xsl:param name="filter-expr"/>
        <xsl:param name="axis"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:variable name="node-count">
            <xsl:call-template name="nodeset-size">
                <xsl:with-param name="expr" select="$running-value"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$node-count = 0">
                <xsl:value-of select="'NS:-'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="result">
                    <xsl:call-template name="filter-repeat">
                        <xsl:with-param name="context-nodes"
                            select="concat(substring-after($running-value, ':'), ';')"/>
                        <xsl:with-param name="filter-expr" select="$filter-expr"/>
                        <xsl:with-param name="axis" select="$axis"/>
                        <xsl:with-param name="position" select="1"/>
                        <xsl:with-param name="size" select="$node-count"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$result = ''">
                        <xsl:value-of select="'NS:-'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('NS:', substring($result, 2))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="filter-repeat">
        <xsl:param name="context-nodes"/>
        <xsl:param name="axis"/>
        <xsl:param name="filter-expr"/>
        <xsl:param name="position"/>
        <xsl:param name="size"/>
        <xsl:param name="running-value" select="''"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="string-length($context-nodes) = 0">
                <xsl:value-of select="$running-value"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="include">
                    <xsl:call-template name="filter-test">
                        <xsl:with-param name="context-node"
                            select="substring-before($context-nodes, ';')"/>
                        <xsl:with-param name="axis" select="$axis"/>
                        <xsl:with-param name="filter-expr" select="$filter-expr"/>
                        <xsl:with-param name="position">
                            <xsl:choose>
                                <xsl:when
                                    test="contains('ancestor-or-self,preceding-sibling,parent', $axis)">
                                    <xsl:value-of select="$size + 1 - $position"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$position"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                        <xsl:with-param name="size" select="$size"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="filter-repeat">
                    <xsl:with-param name="context-nodes"
                        select="substring-after($context-nodes, ';')"/>
                    <xsl:with-param name="axis" select="$axis"/>
                    <xsl:with-param name="filter-expr" select="$filter-expr"/>
                    <xsl:with-param name="position" select="$position + 1"/>
                    <xsl:with-param name="size" select="$size"/>
                    <xsl:with-param name="running-value">
                        <xsl:choose>
                            <xsl:when test="$include != 0">
                                <xsl:value-of
                                    select="concat($running-value, ';', substring-before($context-nodes, ';'))"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$running-value"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="filter-test">
        <xsl:param name="context-node"/>
        <xsl:param name="axis"/>
        <xsl:param name="filter-expr"/>
        <xsl:param name="position"/>
        <xsl:param name="size"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:variable name="filter-result">
            <xsl:call-template name="eval">
                <xsl:with-param name="expr" select="$filter-expr"/>
                <xsl:with-param name="context">
                    <xsl:call-template name="hash-replace">
                        <xsl:with-param name="hash">
                            <xsl:call-template name="hash-replace">
                                <xsl:with-param name="hash">
                                    <xsl:call-template name="hash-replace">
                                        <xsl:with-param name="hash" select="$context"/>
                                        <xsl:with-param name="key" select="'context-node'"/>
                                        <xsl:with-param name="value" select="$context-node"/>
                                    </xsl:call-template>
                                </xsl:with-param>
                                <xsl:with-param name="key" select="'context-position'"/>
                                <xsl:with-param name="value" select="$position"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="key" select="'context-size'"/>
                        <xsl:with-param name="value" select="$size"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="filter-result-type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$filter-result"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$filter-result-type = 'number'">
                <xsl:variable name="filter-result-number">
                    <xsl:call-template name="cast-number">
                        <xsl:with-param name="expr" select="$filter-result"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="number($filter-result-number = $position)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="filter-result-atomic">
                    <xsl:call-template name="cast-atomic">
                        <xsl:with-param name="expr" select="$filter-result"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$filter-result-atomic"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>






</xsl:stylesheet>
