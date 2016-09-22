<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:function-document-1="http://futzle.com/2006/xslt-function//document/1"
    xmlns:function-document-2="http://futzle.com/2006/xslt-function//document/2" xmlns:function-key="http://futzle.com/2006/xslt-function//key/2"
    xmlns:function-format-number-2="http://futzle.com/2006/xslt-function//format-number/2" xmlns:function-format-number-3="http://futzle.com/2006/xslt-function//format-number/3"
    xmlns:function-current="http://futzle.com/2006/xslt-function//current/0" xmlns:function-unparsed-entity-uri="http://futzle.com/2006/xslt-function//unparsed-entity-uri/1"
    xmlns:function-generate-id-0="http://futzle.com/2006/xslt-function//generate-id/0" xmlns:function-generate-id-1="http://futzle.com/2006/xslt-function//generate-id/1"
    xmlns:function-system-property="http://futzle.com/2006/xslt-function//system-property/1" xmlns:function-element-available="http://futzle.com/2006/xslt-function//element-available/1"
    xmlns:function-function-available="http://futzle.com/2006/xslt-function//function-available/1" xmlns:nodeset-generate-id="http://futzle.com/2006/xslt-interpreter//nodeset-generate-id"
    exclude-result-prefixes="function-document-1 function-document-2 function-key function-format-number-2 function-format-number-3 function-current function-unparsed-entity-uri function-generate-id-0 function-generate-id-1 function-system-property function-element-available function-function-available nodeset-generate-id">

    <xsl:import href="lib-datatype.xsl"/>

    <function-document-1:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//document/1']">
        <xsl:param name="arg1"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$arg1"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:choose>
            <xsl:when test="$arg1-type = 'nodeset'">
                <xsl:choose>
                    <xsl:when test="$arg1 = 'NS:-'">
                        <xsl:value-of select="'NS:-'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="function-document-multiple">
                            <xsl:with-param name="arguments" select="concat(substring-after($arg1, ':'), ';')"/>
                            <xsl:with-param name="base" select="'.'"/>
                            <xsl:with-param name="document" select="$document"></xsl:with-param>
                            <xsl:with-param name="stylesheet" select="$stylesheet"></xsl:with-param>
                            <xsl:with-param name="context" select="$context"></xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="arg1-string">
                    <xsl:call-template name="cast-string">
                        <xsl:with-param name="expr" select="$arg1"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:text>NS:</xsl:text>
                <xsl:call-template name="function-document-single">
                    <xsl:with-param name="base">
                        <xsl:call-template name="hash-lookup">
                            <xsl:with-param name="hash" select="$context"/>
                            <xsl:with-param name="key" select="'current-template-document'"/>
                        </xsl:call-template>
                        <xsl:text>:</xsl:text>
                    </xsl:with-param>
                    <xsl:with-param name="href" select="$arg1-string"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <function-document-2:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//document/2']">
        <xsl:param name="arg1"/>
        <xsl:param name="arg2"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:param name="arg1-type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$arg1"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:param name="arg2-type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$arg2"/>
            </xsl:call-template>
        </xsl:param>

        <xsl:if test="$arg2-type != 'nodeset'">
            <xsl:message terminate="yes">document() argument 2 requires a nodeset</xsl:message>
        </xsl:if>

        <xsl:if test="$arg2 = 'NS:-'">
            <xsl:message terminate="yes">document() base is empty nodeset</xsl:message>
        </xsl:if>

        <xsl:variable name="base" select="concat(substring-before(substring-after($arg2, ':'), ':'), ':')"/>

        <xsl:choose>
            <xsl:when test="$arg1-type = 'nodeset'">
                <xsl:choose>
                    <xsl:when test="$arg1 = 'NS:-'">
                        <xsl:value-of select="'NS:-'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="function-document-multiple">
                            <xsl:with-param name="arguments" select="concat(substring-after($arg1, ':'), ';')"/>
                            <xsl:with-param name="base" select="$base"/>
                            <xsl:with-param name="document" select="$document"></xsl:with-param>
                            <xsl:with-param name="stylesheet" select="$stylesheet"></xsl:with-param>
                            <xsl:with-param name="context" select="$context"></xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="arg1-string">
                    <xsl:call-template name="cast-string">
                        <xsl:with-param name="expr" select="$arg1"/>
                        <xsl:with-param name="context" select="$context"/>
                        <xsl:with-param name="document" select="$document"/>
                        <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:text>NS:</xsl:text>
                <xsl:call-template name="function-document-single">
                    <xsl:with-param name="base" select="$base"/>
                    <xsl:with-param name="href" select="$arg1-string"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="function-document-multiple">
        <xsl:param name="arguments"></xsl:param>
        <xsl:param name="base"></xsl:param>
        <xsl:param name="document"></xsl:param>
        <xsl:param name="stylesheet"></xsl:param>
        <xsl:param name="context"></xsl:param>
        
        <xsl:choose>
            <xsl:when test="contains($arguments, ';')">
                <xsl:variable name="first" select="substring-before($arguments, ';')"></xsl:variable>
                
                <xsl:call-template name="union">
                    <xsl:with-param name="lhs">
                        <xsl:text>NS:</xsl:text>
                        <xsl:call-template name="function-document-single">
                            <xsl:with-param name="base">
                                <xsl:choose>
                                    <xsl:when test="$base = '.'">
                                        <xsl:value-of select="$first"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$base"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:with-param>
                            <xsl:with-param name="href">
                                <xsl:call-template name="cast-string">
                                    <xsl:with-param name="expr">
                                        <xsl:value-of select="concat('NS:', $first)"/>
                                    </xsl:with-param>
                                    <xsl:with-param name="context" select="$context"></xsl:with-param>
                                    <xsl:with-param name="document" select="$document"></xsl:with-param>
                                    <xsl:with-param name="stylesheet" select="$stylesheet"></xsl:with-param>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="rhs">
                        <xsl:call-template name="function-document-multiple">
                            <xsl:with-param name="arguments" select="substring-after($arguments, ';')"></xsl:with-param>
                            <xsl:with-param name="base" select="$base"></xsl:with-param>
                            <xsl:with-param name="document" select="$document"></xsl:with-param>
                            <xsl:with-param name="stylesheet" select="$stylesheet"></xsl:with-param>
                            <xsl:with-param name="context" select="$context"></xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'NS:-'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="function-document-single">
        <xsl:param name="href"/>
        <xsl:param name="base"/>

        <xsl:value-of select="substring($base, 1, 1)"/>
        <xsl:call-template name="resolve-href">
            <xsl:with-param name="base" select="substring-before(substring($base, 2), ':')"/>
            <xsl:with-param name="href" select="$href"/>
        </xsl:call-template>
        <xsl:text>:</xsl:text>
    </xsl:template>

    <function-key:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//key/2']"/>

    <function-format-number-2:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//format-number/2']"/>
    <function-format-number-3:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//format-number/3']"/>

    <function-current:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//current/0']">
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:text>NS:</xsl:text>
        <xsl:call-template name="hash-lookup">
            <xsl:with-param name="hash" select="$context"/>
            <xsl:with-param name="key" select="'current-node'"/>
        </xsl:call-template>

    </xsl:template>

    <function-unparsed-entity-uri:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//unparsed-entity-uri/1']"/>

    <function-generate-id-0:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//generate-id/0']">
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:call-template name="node-function">
            <xsl:with-param name="path">
                <xsl:call-template name="context-node">
                    <xsl:with-param name="context" select="$context"/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="function" select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter//nodeset-generate-id']"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <function-generate-id-1:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//generate-id/1']">
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
                <xsl:message>generate-id() requires a nodeset</xsl:message>
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
            <xsl:with-param name="function" select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter//nodeset-generate-id']"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="document" select="$document"/>
            <xsl:with-param name="stylesheet" select="$stylesheet"/>
        </xsl:call-template>
    </xsl:template>

    <nodeset-generate-id:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter//nodeset-generate-id']">
        <xsl:param name="context-node"/>
        <xsl:call-template name="construct-string">
            <xsl:with-param name="expr" select="generate-id($context-node)"/>
        </xsl:call-template>
    </xsl:template>

    <function-system-property:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//system-property/1']">
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

        <xsl:choose>
            <xsl:when test="contains($arg1-string, ':')">
                <xsl:variable name="arg1-namespace">
                    <xsl:call-template name="hash-lookup">
                        <xsl:with-param name="hash">
                            <xsl:call-template name="hash-lookup">
                                <xsl:with-param name="hash" select="$context"/>
                                <xsl:with-param name="key" select="'namespaces'"/>
                            </xsl:call-template>
                        </xsl:with-param>
                        <xsl:with-param name="key" select="substring-before($arg1-string, ':')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="arg1-local-name" select="substring-after($arg1-string, ':')"/>
                <xsl:choose>
                    <xsl:when test="$arg1-namespace = 'http://www.w3.org/1999/XSL/Transform'
                        and $arg1-local-name = 'version'">
                        <xsl:text>S:1.0</xsl:text>
                    </xsl:when>
                    <xsl:when test="$arg1-namespace = 'http://www.w3.org/1999/XSL/Transform'
                                and $arg1-local-name = 'vendor'">
                        <xsl:text>S:Naxos 0.1 (running on </xsl:text>
                        <xsl:value-of select="system-property('xsl:vendor')"/>
                        <xsl:text>)</xsl:text>
                    </xsl:when>
                    <xsl:when test="$arg1-namespace = 'http://www.w3.org/1999/XSL/Transform'
                        and $arg1-local-name = 'vendor-url'">
                        <xsl:text>S:http://www.futzle.com/naxos/</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>S:</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>S:</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <function-element-available:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//element-available/1']"/>

    <function-function-available:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-function//function-available/1']"/>

</xsl:stylesheet>
