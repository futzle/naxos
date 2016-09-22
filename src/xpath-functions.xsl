<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:function-last="http://futzle.com/2006/xslt-function//last/0"
    xmlns:function-position="http://futzle.com/2006/xslt-function//position/0"
    xmlns:function-count="http://futzle.com/2006/xslt-function//count/1"
    xmlns:function-id="http://futzle.com/2006/xslt-function//id/1"
    xmlns:function-local-name-0="http://futzle.com/2006/xslt-function//local-name/0"
    xmlns:function-local-name-1="http://futzle.com/2006/xslt-function//local-name/1"
    xmlns:function-namespace-uri-0="http://futzle.com/2006/xslt-function//namespace-uri/0"
    xmlns:function-namespace-uri-1="http://futzle.com/2006/xslt-function//namespace-uri/1"
    xmlns:function-name-0="http://futzle.com/2006/xslt-function//name/0"
    xmlns:function-name-1="http://futzle.com/2006/xslt-function//name/1"
    xmlns:function-string-0="http://futzle.com/2006/xslt-function//string/0"
    xmlns:function-string-1="http://futzle.com/2006/xslt-function//string/1"
    xmlns:function-concat="http://futzle.com/2006/xslt-function//concat"
    xmlns:function-starts-with="http://futzle.com/2006/xslt-function//starts-with/2"
    xmlns:function-contains="http://futzle.com/2006/xslt-function//contains/2"
    xmlns:function-substring-before="http://futzle.com/2006/xslt-function//substring-before/2"
    xmlns:function-substring-after="http://futzle.com/2006/xslt-function//substring-after/2"
    xmlns:function-substring-2="http://futzle.com/2006/xslt-function//substring/2"
    xmlns:function-substring-3="http://futzle.com/2006/xslt-function//substring/3"
    xmlns:function-string-length-0="http://futzle.com/2006/xslt-function//string-length/0"
    xmlns:function-string-length-1="http://futzle.com/2006/xslt-function//string-length/1"
    xmlns:function-normalize-space-0="http://futzle.com/2006/xslt-function//normalize-space/0"
    xmlns:function-normalize-space-1="http://futzle.com/2006/xslt-function//normalize-space/1"
    xmlns:function-translate="http://futzle.com/2006/xslt-function//translate/3"
    xmlns:function-boolean="http://futzle.com/2006/xslt-function//boolean/1"
    xmlns:function-not="http://futzle.com/2006/xslt-function//not/1"
    xmlns:function-true="http://futzle.com/2006/xslt-function//true/0"
    xmlns:function-false="http://futzle.com/2006/xslt-function//false/0"
    xmlns:function-lang="http://futzle.com/2006/xslt-function//lang/1"
    xmlns:function-number-0="http://futzle.com/2006/xslt-function//number/0"
    xmlns:function-number-1="http://futzle.com/2006/xslt-function//number/1"
    xmlns:function-sum="http://futzle.com/2006/xslt-function//sum/1"
    xmlns:function-floor="http://futzle.com/2006/xslt-function//floor/1"
    xmlns:function-ceiling="http://futzle.com/2006/xslt-function//ceiling/1"
    xmlns:function-round="http://futzle.com/2006/xslt-function//round/1"
    xmlns:nodeset-id="http://futzle.com/2006/xslt-interpreter//nodeset-id"
    xmlns:nodeset-local-name="http://futzle.com/2006/xslt-interpreter//nodeset-local-name"
    xmlns:nodeset-namespace-uri="http://futzle.com/2006/xslt-interpreter//nodeset-namespace-uri"
    xmlns:nodeset-name="http://futzle.com/2006/xslt-interpreter//nodeset-name"
    xmlns:nodeset-lang="http://futzle.com/2006/xslt-interpreter//nodeset-lang"
    exclude-result-prefixes="function-last function-position function-count function-id function-local-name-0 function-local-name-1 function-namespace-uri-0 function-namespace-uri-1 function-name-0 function-name-1 function-string-0 function-string-1 function-concat function-starts-with function-contains function-substring-before function-substring-after function-substring-2 function-substring-3 function-string-length-0 function-string-length-1 function-normalize-space-0 function-normalize-space-1 function-translate function-boolean function-not function-true function-false function-lang function-number-0 function-number-1 function-sum function-floor function-ceiling function-round
                             nodeset-id nodeset-local-name nodeset-namespace-uri nodeset-name nodeset-lang">

    <xsl:import href="encoding.xsl"/>
    <xsl:import href="lib-datatype.xsl"/>
    <xsl:import href="lib-interpret.xsl"/>

    <function-last:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//last/0']">
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="construct-number">
            <xsl:with-param name="expr">
                <xsl:call-template name="hash-lookup">
                    <xsl:with-param name="hash" select="$context"/>
                    <xsl:with-param name="key" select="'context-size'"/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <function-position:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//position/0']">
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="construct-number">
            <xsl:with-param name="expr">
                <xsl:call-template name="hash-lookup">
                    <xsl:with-param name="hash" select="$context"/>
                    <xsl:with-param name="key" select="'context-position'"/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <function-count:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//count/1']">
        <xsl:param name="arg1"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:variable name="arg1-type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$arg1"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="$arg1-type != 'nodeset'">
            <xsl:message terminate="yes">
                <xsl:message>count() requires a nodeset</xsl:message>
            </xsl:message>
        </xsl:if>

        <xsl:choose>
            <xsl:when test="$arg1 = 'NS:-'">
                <xsl:call-template name="construct-number">
                    <xsl:with-param name="expr">
                        <xsl:value-of select="0"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="nodeset-count-repeat">
                    <xsl:with-param name="remainder" select="$arg1"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="nodeset-count-repeat">
        <xsl:param name="running-count" select="1"/>
        <xsl:param name="remainder"/>

        <xsl:choose>
            <xsl:when test="contains($remainder, ';')">
                <xsl:call-template name="nodeset-count-repeat">
                    <xsl:with-param name="running-count" select="$running-count + 1"/>
                    <xsl:with-param name="remainder" select="substring-after($remainder, ';')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="construct-number">
                    <xsl:with-param name="expr">
                        <xsl:value-of select="$running-count"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <function-id:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//id/1']">
        <xsl:param name="arg1"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:variable name="arg1-type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$arg1"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$arg1-type = 'nodeset'">
                <xsl:choose>
                    <xsl:when test="$arg1 = 'NS:-'">
                        <xsl:value-of select="'NS:-'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="nodeset-id-repeat">
                            <xsl:with-param name="running-value" select="'NS:-'"/>
                            <xsl:with-param name="arguments"
                                select="concat(substring-after($arg1, ':'), ';')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="arg1-string">
                    <xsl:call-template name="cast-string">
                        <xsl:with-param name="expr" select="$arg1"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:call-template name="node-function">
                    <xsl:with-param name="path">
                        <xsl:call-template name="context-node">
                            <xsl:with-param name="context" select="$context"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="function"
                        select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter//nodeset-id']"/>
                    <xsl:with-param name="argument" select="$arg1-string"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="nodeset-id-repeat">
        <xsl:param name="arguments"/>
        <xsl:param name="running-value"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="contains($arguments, ';')">
                <xsl:variable name="arg1-string">
                    <xsl:call-template name="cast-string">
                        <xsl:with-param name="expr" select="concat('NS:', substring-before($arguments, ';'))"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="result">
                    <xsl:call-template name="node-function">
                        <xsl:with-param name="path">
                            <xsl:call-template name="context-node">
                                <xsl:with-param name="context" select="$context"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="function"
                            select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter//nodeset-id']"/>
                        <xsl:with-param name="argument" select="$arg1-string"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="nodeset-id-repeat">
                    <xsl:with-param name="running-value">
                        <xsl:call-template name="union">
                            <xsl:with-param name="lhs" select="$running-value"/>
                            <xsl:with-param name="rhs" select="$result"/>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="arguments" select="substring-after($arguments, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$running-value"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <nodeset-id:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter//nodeset-id']">
        <xsl:param name="context-node"/>
        <xsl:param name="argument"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:apply-templates select="$context-node" mode="nodeset-id">
            <xsl:with-param name="argument" select="$argument"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*|text()|comment()|processing-instruction()|@*|/" mode="nodeset-id">
        <xsl:param name="argument"/>
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
        <xsl:call-template name="construct-nodeset">
            <xsl:with-param name="root" select="concat(substring-before($context-node, ':'), ':')"/>
            <xsl:with-param name="nodeset" select="id($argument)"/>
            <xsl:with-param name="node"/>
        </xsl:call-template>

    </xsl:template>

    <function-local-name-0:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//local-name/0']">
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="node-function">
            <xsl:with-param name="path">
                <xsl:call-template name="context-node">
                    <xsl:with-param name="context" select="$context"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="function"
                select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter//nodeset-local-name']"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <function-local-name-1:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//local-name/1']">
        <xsl:param name="arg1"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:variable name="arg1-type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$arg1"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="$arg1-type != 'nodeset'">
            <xsl:message terminate="yes">
                <xsl:message>local-name() requires a nodeset</xsl:message>
            </xsl:message>
        </xsl:if>

        <xsl:call-template name="node-function">
            <xsl:with-param name="path">
                <xsl:choose>
                    <xsl:when test="contains($arg1, ';')">
                        <xsl:value-of select="substring-before(substring-after($arg1, ':'), ';')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after($arg1, ':')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="function"
                select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter//nodeset-local-name']"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <nodeset-local-name:function/>
    <xsl:template
        match="*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter//nodeset-local-name']">
        <xsl:param name="context-node"/>
        <xsl:call-template name="construct-string">
            <xsl:with-param name="expr" select="local-name($context-node)"/>
        </xsl:call-template>
    </xsl:template>

    <function-namespace-uri-0:function/>
    <xsl:template
        match="*[namespace-uri() =
        'http://futzle.com/2006/xslt-function//namespace-uri/0']">
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="node-function">
            <xsl:with-param name="path">
                <xsl:call-template name="context-node">
                    <xsl:with-param name="context" select="$context"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="function"
                select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter//nodeset-namespace-uri']"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <function-namespace-uri-1:function/>
    <xsl:template
        match="*[namespace-uri() =
        'http://futzle.com/2006/xslt-function//namespace-uri/1']">
        <xsl:param name="arg1"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:variable name="arg1-type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$arg1"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="$arg1-type != 'nodeset'">
            <xsl:message terminate="yes">
                <xsl:message>namespace-uri() requires a nodeset</xsl:message>
            </xsl:message>
        </xsl:if>

        <xsl:call-template name="node-function">
            <xsl:with-param name="path">
                <xsl:choose>
                    <xsl:when test="contains($arg1, ';')">
                        <xsl:value-of select="substring-before(substring-after($arg1, ':'), ';')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after($arg1, ':')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="function"
                select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter//nodeset-namespace-uri']"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <nodeset-namespace-uri:function/>
    <xsl:template
        match="*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter//nodeset-namespace-uri']">
        <xsl:param name="context-node"/>
        <xsl:call-template name="construct-string">
            <xsl:with-param name="expr" select="namespace-uri($context-node)"/>
        </xsl:call-template>
    </xsl:template>


    <function-name-0:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//name/0']">
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="node-function">
            <xsl:with-param name="path">
                <xsl:call-template name="context-node">
                    <xsl:with-param name="context" select="$context"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="function"
                select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter//nodeset-name']"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <function-name-1:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//name/1']">
        <xsl:param name="arg1"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:variable name="arg1-type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$arg1"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="$arg1-type != 'nodeset'">
            <xsl:message terminate="yes">
                <xsl:message>name() requires a nodeset</xsl:message>
            </xsl:message>
        </xsl:if>

        <xsl:call-template name="node-function">
            <xsl:with-param name="path">
                <xsl:choose>
                    <xsl:when test="contains($arg1, ';')">
                        <xsl:value-of select="substring-before(substring-after($arg1, ':'), ';')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after($arg1, ':')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="function"
                select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter//nodeset-name']"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <nodeset-name:function/>
    <xsl:template
        match="*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter//nodeset-name']">
        <xsl:param name="context-node"/>
        <xsl:call-template name="construct-string">
            <xsl:with-param name="expr" select="name($context-node)"/>
        </xsl:call-template>
    </xsl:template>

    <function-string-0:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//string/0']">
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="context-node">
            <xsl:call-template name="context-node">
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:param name="arg1-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="concat('NS:', $context-node)"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-string">
            <xsl:with-param name="expr" select="string($arg1-string)"/>
        </xsl:call-template>
    </xsl:template>

    <function-string-1:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//string/1']">
        <xsl:param name="arg1"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="$arg1"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-string">
            <xsl:with-param name="expr" select="string($arg1-string)"/>
        </xsl:call-template>
    </xsl:template>

    <function-concat:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//concat']">
        <xsl:param name="arguments"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:if
            test="not(contains($arguments, ';')) or not(contains(substring-after($arguments,
            ';'), ';'))">
            <xsl:message terminate="yes">
                <xsl:text>concat() must have at least two arguments</xsl:text>
            </xsl:message>
        </xsl:if>

        <xsl:call-template name="concat-repeat">
            <xsl:with-param name="running-value" select="''"/>
            <xsl:with-param name="arguments" select="$arguments"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>

    </xsl:template>

    <xsl:template name="concat-repeat">
        <xsl:param name="running-value"/>
        <xsl:param name="arguments"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="string-length($arguments) = 0">
                <xsl:call-template name="construct-string">
                    <xsl:with-param name="expr" select="$running-value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="result">
                    <xsl:call-template name="cast-string">
                        <xsl:with-param name="expr">
                            <xsl:call-template name="eval">
                                <xsl:with-param name="expr"
                                    select="substring-before($arguments,
                                    ';')"/>
                                <xsl:with-param name="context" select="$context"/>
                                <xsl:with-param name="document" select="$document"/>
                                <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="concat-repeat">
                    <xsl:with-param name="running-value" select="concat($running-value, $result)"/>
                    <xsl:with-param name="arguments" select="substring-after($arguments, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <function-starts-with:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//starts-with/2']">
        <xsl:param name="arg1"/>
        <xsl:param name="arg2"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="$arg1"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>
        <xsl:param name="arg2-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="$arg2"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-boolean">
            <xsl:with-param name="expr" select="starts-with($arg1-string, $arg2-string)"/>
        </xsl:call-template>
    </xsl:template>

    <function-contains:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//contains/2']">
        <xsl:param name="arg1"/>
        <xsl:param name="arg2"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="$arg1"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>
        <xsl:param name="arg2-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="$arg2"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-boolean">
            <xsl:with-param name="expr" select="contains($arg1-string, $arg2-string)"/>
        </xsl:call-template>
    </xsl:template>

    <function-substring-before:function/>
    <xsl:template
        match="*[namespace-uri() =
        'http://futzle.com/2006/xslt-function//substring-before/2']">
        <xsl:param name="arg1"/>
        <xsl:param name="arg2"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="$arg1"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>
        <xsl:param name="arg2-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="$arg2"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-string">
            <xsl:with-param name="expr" select="substring-before($arg1-string, $arg2-string)"/>
        </xsl:call-template>
    </xsl:template>

    <function-substring-after:function/>
    <xsl:template
        match="*[namespace-uri() =
        'http://futzle.com/2006/xslt-function//substring-after/2']">
        <xsl:param name="arg1"/>
        <xsl:param name="arg2"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="$arg1"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>
        <xsl:param name="arg2-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="$arg2"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-string">
            <xsl:with-param name="expr" select="substring-after($arg1-string, $arg2-string)"/>
        </xsl:call-template>
    </xsl:template>

    <function-substring-2:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//substring/2']">
        <xsl:param name="arg1"/>
        <xsl:param name="arg2"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="$arg1"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>
        <xsl:param name="arg2-number">
            <xsl:call-template name="cast-number">
                <xsl:with-param name="expr" select="$arg2"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-string">
            <xsl:with-param name="expr" select="substring($arg1-string, $arg2-number)"/>
        </xsl:call-template>
    </xsl:template>

    <function-substring-3:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//substring/3']">
        <xsl:param name="arg1"/>
        <xsl:param name="arg2"/>
        <xsl:param name="arg3"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="$arg1"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>
        <xsl:param name="arg2-number">
            <xsl:call-template name="cast-number">
                <xsl:with-param name="expr" select="$arg2"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>
        <xsl:param name="arg3-number">
            <xsl:call-template name="cast-number">
                <xsl:with-param name="expr" select="$arg3"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-string">
            <xsl:with-param name="expr" select="substring($arg1-string, $arg2-number, $arg3-number)"
            />
        </xsl:call-template>
    </xsl:template>

    <function-string-length-0:function/>
    <xsl:template
        match="*[namespace-uri() =
        'http://futzle.com/2006/xslt-function//string-length/0']">
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="context-node">
            <xsl:call-template name="context-node">
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:param name="arg1-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="concat('NS:', $context-node)"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-string">
            <xsl:with-param name="expr" select="string-length($arg1-string)"/>
        </xsl:call-template>
    </xsl:template>

    <function-string-length-1:function/>
    <xsl:template
        match="*[namespace-uri() =
        'http://futzle.com/2006/xslt-function//string-length/1']">
        <xsl:param name="arg1"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="$arg1"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-string">
            <xsl:with-param name="expr" select="string-length($arg1-string)"/>
        </xsl:call-template>
    </xsl:template>

    <function-normalize-space-0:function/>
    <xsl:template
        match="*[namespace-uri() =
        'http://futzle.com/2006/xslt-function//normalize-space/0']">
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="context-node">
            <xsl:call-template name="context-node">
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:param name="arg1-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="concat('NS:', $context-node)"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-string">
            <xsl:with-param name="expr" select="normalize-space($arg1-string)"/>
        </xsl:call-template>
    </xsl:template>

    <function-normalize-space-1:function/>
    <xsl:template
        match="*[namespace-uri() =
        'http://futzle.com/2006/xslt-function//normalize-space/1']">
        <xsl:param name="arg1"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="$arg1"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-string">
            <xsl:with-param name="expr" select="normalize-space($arg1-string)"/>
        </xsl:call-template>
    </xsl:template>

    <function-translate:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//translate/3']">
        <xsl:param name="arg1"/>
        <xsl:param name="arg2"/>
        <xsl:param name="arg3"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:variable name="arg1-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="$arg1"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="arg2-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="$arg2"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="arg3-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="$arg3"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="construct-string">
            <xsl:with-param name="expr" select="translate($arg1-string, $arg2-string, $arg3-string)"
            />
        </xsl:call-template>
    </xsl:template>

    <function-boolean:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//boolean/1']">
        <xsl:param name="arg1"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-boolean">
            <xsl:call-template name="cast-boolean">
                <xsl:with-param name="expr" select="$arg1"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-boolean">
            <xsl:with-param name="expr" select="boolean($arg1-boolean)"/>
        </xsl:call-template>
    </xsl:template>

    <function-not:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//not/1']">
        <xsl:param name="arg1"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-boolean">
            <xsl:call-template name="cast-boolean">
                <xsl:with-param name="expr" select="$arg1"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-boolean">
            <xsl:with-param name="expr" select="not($arg1-boolean)"/>
        </xsl:call-template>
    </xsl:template>

    <function-true:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//true/0']">
        <xsl:call-template name="construct-boolean">
            <xsl:with-param name="expr" select="true()"/>
        </xsl:call-template>
    </xsl:template>

    <function-false:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//false/0']">
        <xsl:call-template name="construct-boolean">
            <xsl:with-param name="expr" select="false()"/>
        </xsl:call-template>
    </xsl:template>

    <function-lang:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//lang/1']">
        <xsl:param name="arg1"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-string">
            <xsl:call-template name="cast-string">
                <xsl:with-param name="expr" select="$arg1"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="node-function">
            <xsl:with-param name="path">
                <xsl:call-template name="context-node">
                    <xsl:with-param name="context" select="$context"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="function"
                select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter//nodeset-lang']"/>
            <xsl:with-param name="argument" select="$arg1-string"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <nodeset-lang:function/>
    <xsl:template
        match="*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter//nodeset-lang']">
        <xsl:param name="context-node"/>
        <xsl:param name="argument"/>
        <xsl:apply-templates select="$context-node" mode="nodeset-lang">
            <xsl:with-param name="argument" select="$argument"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*|text()|processing-instruction()|comment()|attribute::*"
        mode="nodeset-lang">
        <xsl:param name="argument"/>
        <xsl:call-template name="construct-boolean">
            <xsl:with-param name="expr" select="lang($argument)"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="/" mode="nodeset-lang">
        <xsl:call-template name="construct-boolean">
            <xsl:with-param name="expr" select="0"/>
        </xsl:call-template>
    </xsl:template>

    <function-number-0:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//number/0']">
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="context-node">
            <xsl:call-template name="context-node">
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:param name="arg1-number">
            <xsl:call-template name="cast-number">
                <xsl:with-param name="expr" select="concat('NS:', $context-node)"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-number">
            <xsl:with-param name="expr" select="number($arg1-number)"/>
        </xsl:call-template>
    </xsl:template>

    <function-number-1:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//number/1']">
        <xsl:param name="arg1"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-number">
            <xsl:call-template name="cast-number">
                <xsl:with-param name="expr" select="$arg1"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-number">
            <xsl:with-param name="expr" select="number($arg1-number)"/>
        </xsl:call-template>
    </xsl:template>

    <function-sum:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//sum/1']">
        <xsl:param name="arg1"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$arg1"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="nodeset-sum-repeat">
            <xsl:with-param name="running-value" select="0"/>
            <xsl:with-param name="arguments" select="concat(substring-after($arg1, ':'), ';')"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="nodeset-sum-repeat">
        <xsl:param name="running-value"/>
        <xsl:param name="arguments"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:choose>
            <xsl:when test="string-length($arguments) = 0">
                <xsl:call-template name="construct-number">
                    <xsl:with-param name="expr" select="$running-value"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="result">
                    <xsl:call-template name="cast-number">
                        <xsl:with-param name="expr"
                            select="concat('NS:', substring-before($arguments, ';'))"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="nodeset-sum-repeat">
                    <xsl:with-param name="running-value" select="$running-value + $result"/>
                    <xsl:with-param name="arguments" select="substring-after($arguments, ';')"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <function-floor:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//floor/1']">
        <xsl:param name="arg1"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-number">
            <xsl:call-template name="cast-number">
                <xsl:with-param name="expr" select="$arg1"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-number">
            <xsl:with-param name="expr" select="floor($arg1-number)"/>
        </xsl:call-template>
    </xsl:template>

    <function-ceiling:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//ceiling/1']">
        <xsl:param name="arg1"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-number">
            <xsl:call-template name="cast-number">
                <xsl:with-param name="expr" select="$arg1"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-number">
            <xsl:with-param name="expr" select="ceiling($arg1-number)"/>
        </xsl:call-template>
    </xsl:template>

    <function-round:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//round/1']">
        <xsl:param name="arg1"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-number">
            <xsl:call-template name="cast-number">
                <xsl:with-param name="expr" select="$arg1"/>
                <xsl:with-param name="context" select="$context"/>
                <xsl:with-param name="document" select="$document"/>
                <xsl:with-param name="stylesheet" select="$stylesheet"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:call-template name="construct-number">
            <xsl:with-param name="expr" select="round($arg1-number)"/>
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>
