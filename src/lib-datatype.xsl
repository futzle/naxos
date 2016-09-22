<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:nodeset-cast-string="http://futzle.com/2006/xslt-interpreter/nodeset-cast-string"
    xmlns:nodeset-cast-number="http://futzle.com/2006/xslt-interpreter/nodeset-cast-number"
    xmlns:nodeset-node-type="http://futzle.com/2006/xslt-interpreter/nodeset-node-type"
    exclude-result-prefixes="nodeset-cast-string nodeset-cast-number nodeset-node-type">

    <xsl:import href="encoding.xsl"/>
    <xsl:import href="naxos-serialize.xsl"/>

    <xsl:template name="value-type">
        <xsl:param name="expr"/>

        <xsl:choose>
            <xsl:when test="starts-with($expr, 'N:')">
                <xsl:text>number</xsl:text>
            </xsl:when>
            <xsl:when test="starts-with($expr, 'S:')">
                <xsl:text>string</xsl:text>
            </xsl:when>
            <xsl:when test="starts-with($expr, 'B:')">
                <xsl:text>boolean</xsl:text>
            </xsl:when>
            <xsl:when test="starts-with($expr, 'NS:')">
                <xsl:text>nodeset</xsl:text>
            </xsl:when>
            <xsl:when test="starts-with($expr, 'R:')">
                <xsl:text>result-tree-fragment</xsl:text>
            </xsl:when>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="cast-atomic">
        <xsl:param name="expr"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:variable name="type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$expr"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$type = 'number'">
                <xsl:value-of select="number(substring-after($expr, ':'))"/>
            </xsl:when>
            <xsl:when test="$type = 'string'">
                <xsl:value-of select="substring-after($expr, ':')"/>
            </xsl:when>
            <xsl:when test="$type = 'boolean'">
                <xsl:value-of select="number(substring-after($expr, ':'))"/>
            </xsl:when>
            <xsl:when test="$type = 'result-tree-fragment'">
                <xsl:call-template name="serialize-result-tree-fragment-text">
                    <xsl:with-param name="tree" select="substring-after($expr, ':')"></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$type = 'nodeset'">
                <xsl:choose>
                    <xsl:when test="$expr = 'NS:-'">
                        <xsl:value-of select="''"/>
                    </xsl:when>
                    <xsl:when test="contains($expr, ';')">
                        <xsl:call-template name="node-function">
                            <xsl:with-param name="path"
                                select="substring-before(substring-after($expr, ':'), ';')"/>
                            <xsl:with-param name="function"
                                select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter/nodeset-cast-string']"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="node-function">
                            <xsl:with-param name="path" select="substring-after($expr, ':')"/>
                            <xsl:with-param name="function"
                                select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter/nodeset-cast-string']"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="cast-boolean">
        <xsl:param name="expr"/>

        <xsl:variable name="type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$expr"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$type = 'number'">
                <xsl:value-of select="number(substring-after($expr, ':'))"/>
            </xsl:when>
            <xsl:when test="$type = 'string'">
                <xsl:value-of select="number(substring-after($expr, ':'))"/>
            </xsl:when>
            <xsl:when test="$type = 'boolean'">
                <xsl:value-of select="number(substring-after($expr, ':'))"/>
            </xsl:when>
            <xsl:when test="$type = 'result-tree-fragment'">
                <xsl:value-of select="$expr != 'R:;'"/>
            </xsl:when>
            <xsl:when test="$type = 'nodeset'">
                <xsl:value-of select="$expr != 'NS:-'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="construct-boolean">
        <xsl:param name="expr"/>
        <xsl:value-of select="concat('B:', number(boolean($expr)))"/>
    </xsl:template>

    <xsl:template name="cast-number">
        <xsl:param name="expr"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:variable name="type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$expr"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$type = 'number'">
                <xsl:value-of select="number(substring-after($expr, ':'))"/>
            </xsl:when>
            <xsl:when test="$type = 'string'">
                <xsl:value-of select="number(substring-after($expr, ':'))"/>
            </xsl:when>
            <xsl:when test="$type = 'boolean'">
                <xsl:value-of select="number(substring-after($expr, ':'))"/>
            </xsl:when>
            <xsl:when test="$type = 'result-tree-fragment'">
                <xsl:call-template name="serialize-result-tree-fragment-text">
                    <xsl:with-param name="tree" select="substring-after($expr, ':')"></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$type = 'nodeset'">
                <xsl:choose>
                    <xsl:when test="$expr = 'NS:-'">
                        <xsl:value-of select="0"/>
                    </xsl:when>
                    <xsl:when test="contains($expr, ';')">
                        <xsl:call-template name="node-function">
                            <xsl:with-param name="path"
                                select="substring-before(substring-after($expr, ':'), ';')"/>
                            <xsl:with-param name="function"
                                select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter/nodeset-cast-number']"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="node-function">
                            <xsl:with-param name="path" select="substring-after($expr, ':')"/>
                            <xsl:with-param name="function"
                                select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter/nodeset-cast-number']"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="construct-number">
        <xsl:param name="expr"/>
        <xsl:value-of select="concat('N:', number($expr))"/>
    </xsl:template>

    <xsl:template name="cast-string">
        <xsl:param name="expr"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>

        <xsl:variable name="type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$expr"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$type = 'number'">
                <xsl:value-of select="substring-after($expr, ':')"/>
            </xsl:when>
            <xsl:when test="$type = 'string'">
                <xsl:value-of select="substring-after($expr, ':')"/>
            </xsl:when>
            <xsl:when test="$type = 'result-tree-fragment'">
                <xsl:call-template name="serialize-result-tree-fragment-text">
                    <xsl:with-param name="tree" select="substring-after($expr, ':')"></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$type = 'boolean'">
                <xsl:choose>
                    <xsl:when test="number(substring-after($expr, ':')) = 0">
                        <xsl:value-of select="'S:false'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'S:true'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$type = 'nodeset'">
                <xsl:choose>
                    <xsl:when test="$expr = 'NS:-'">
                        <xsl:value-of select="''"/>
                    </xsl:when>
                    <xsl:when test="contains($expr, ';')">
                        <xsl:call-template name="node-function">
                            <xsl:with-param name="path"
                                select="substring-before(substring-after($expr, ':'), ';')"/>
                            <xsl:with-param name="function"
                                select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter/nodeset-cast-string']"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="node-function">
                            <xsl:with-param name="path" select="substring-after($expr, ':')"/>
                            <xsl:with-param name="function"
                                select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter/nodeset-cast-string']"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="construct-string">
        <xsl:param name="expr"/>
        <xsl:value-of select="concat('S:', $expr)"/>
    </xsl:template>

    <nodeset-cast-string:function/>
    <xsl:template
        match="*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter/nodeset-cast-string']">
        <xsl:param name="context-node"/>
        <xsl:value-of select="string($context-node)"/>
    </xsl:template>

    <nodeset-cast-number:function/>
    <xsl:template
        match="*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter/nodeset-cast-number']">
        <xsl:param name="context-node"/>
        <xsl:value-of select="number($context-node)"/>
    </xsl:template>

    <xsl:template name="construct-nodeset">
        <xsl:param name="root"/>
        <xsl:param name="node-type"/>
        <xsl:param name="nodeset" select="/.."/>

        <xsl:choose>
            <xsl:when test="count($nodeset) = 0">
                <xsl:value-of select="'NS:-'"/>
            </xsl:when>
            <xsl:when test="count($nodeset) = 1">
                <xsl:variable name="node-path">
                    <xsl:call-template name="construct-node-path">
                        <xsl:with-param name="node" select="$nodeset[1]"/>
                        <xsl:with-param name="node-type" select="$node-type"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat('NS:', $root, ':', $node-path)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="last-position">
                    <xsl:choose>
                        <xsl:when test="$node-type = 'attribute'">
                            <xsl:for-each select="$nodeset">
                                <xsl:sort select="namespace-uri()"/>
                                <xsl:sort select="local-name()"/>
                                <xsl:if test="position() = last()">
                                    <xsl:value-of select="generate-id()"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="$node-type = 'namespace'">
                            <xsl:for-each select="$nodeset">
                                <xsl:sort select="local-name()"/>
                                <xsl:if test="position() = last()">
                                    <xsl:value-of select="generate-id()"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="generate-id($nodeset[last()])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="node-path">
                    <xsl:call-template name="construct-node-path">
                        <xsl:with-param name="node"
                            select="$nodeset[generate-id() = $last-position]"/>
                        <xsl:with-param name="node-type" select="$node-type"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="remainder">
                    <xsl:call-template name="construct-nodeset">
                        <xsl:with-param name="root" select="$root"/>
                        <xsl:with-param name="nodeset"
                            select="$nodeset[generate-id() != $last-position]"/>
                        <xsl:with-param name="node-type" select="$node-type"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($remainder, ';', $root, ':', $node-path)"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="construct-node-path">
        <xsl:param name="node"/>
        <xsl:param name="node-type"/>

        <xsl:choose>
            <xsl:when test="count($node/..) = 0">
                <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:when test="$node-type = 'attribute' and local-name($node) = name($node)">
                <xsl:variable name="step" select="concat('@', local-name($node))"/>
                <xsl:variable name="prefix">
                    <xsl:call-template name="construct-node-path">
                        <xsl:with-param name="node" select="$node/.."/>
                        <xsl:with-param name="node-type" select="'node'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($prefix, '/', $step)"/>
            </xsl:when>
            <xsl:when test="$node-type = 'attribute'">
                <xsl:variable name="namespace-uri-encoded">
                    <xsl:call-template name="encode">
                        <xsl:with-param name="expr" select="namespace-uri($node)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="step"
                    select="concat('@{', $namespace-uri-encoded, '}', local-name($node))"/>
                <xsl:variable name="prefix">
                    <xsl:call-template name="construct-node-path">
                        <xsl:with-param name="node" select="$node/.."/>
                        <xsl:with-param name="node-type" select="'node'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($prefix, '/', $step)"/>
            </xsl:when>
            <xsl:when test="$node-type = 'namespace'">
                <xsl:variable name="step" select="concat('!', local-name($node))"/>
                <xsl:variable name="prefix">
                    <xsl:call-template name="construct-node-path">
                        <xsl:with-param name="node" select="$node/.."/>
                        <xsl:with-param name="node-type" select="'node'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat($prefix, '/', $step)"/>
            </xsl:when>
            <xsl:when test="$node-type = 'node'">
                <xsl:variable name="step" select="count($node/preceding-sibling::node()) + 1"/>
                <xsl:variable name="prefix">
                    <xsl:call-template name="construct-node-path">
                        <xsl:with-param name="node" select="$node/.."/>
                        <xsl:with-param name="node-type" select="'node'"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="string-length($prefix) &gt; 0">
                        <xsl:value-of select="concat($prefix, '/', $step)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$step"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="context-node">
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>


        <xsl:variable name="context-node">
            <xsl:call-template name="hash-lookup">
                <xsl:with-param name="hash" select="$context"/>
                <xsl:with-param name="key" select="'context-node'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:value-of select="$context-node"/>
    </xsl:template>

    <xsl:template name="document-root">
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>


        <xsl:variable name="context-node">
            <xsl:call-template name="hash-lookup">
                <xsl:with-param name="hash" select="$context"/>
                <xsl:with-param name="key" select="'context-node'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:value-of select="concat(substring-before($context-node, ':'), ':')"/>
    </xsl:template>

    <xsl:template name="nodeset-size">
        <xsl:param name="expr"/>
        <xsl:choose>
            <xsl:when test="$expr = 'NS:-'">
                <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="nodeset-size-repeat">
                    <xsl:with-param name="expr" select="substring-after($expr, ':')"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="nodeset-size-repeat">
        <xsl:param name="expr"/>
        <xsl:param name="count" select="1"/>

        <xsl:choose>
            <xsl:when test="contains($expr, ';')">
                <xsl:call-template name="nodeset-size-repeat">
                    <xsl:with-param name="expr" select="substring-after($expr, ';')"/>
                    <xsl:with-param name="count" select="$count + 1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$count"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="node-parent">
        <xsl:param name="node"></xsl:param>
        
        <xsl:choose>
            <xsl:when test="$node = '-'">
                <xsl:value-of select="'-'"/>
            </xsl:when>
            <xsl:when test="substring-after($node, ':') = ''">
                <xsl:value-of select="'-'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="node-parent-in-document">
                    <xsl:call-template name="node-parent-in-document">
                        <xsl:with-param name="node" select="substring-after($node, ':')"></xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat(substring-before($node, ':'), ':', $node-parent-in-document)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="node-parent-in-document">
        <xsl:param name="running-value" select="''"></xsl:param>
        <xsl:param name="node"></xsl:param>
        
        <xsl:choose>
            <xsl:when test="contains($node, '/')">
                <xsl:choose>
                    <xsl:when test="string-length($running-value) &gt; 0">
                        <xsl:call-template name="node-parent-in-document">
                            <xsl:with-param name="running-value" select="concat($running-value, '/', substring-before($node, '/'))"></xsl:with-param>
                            <xsl:with-param name="node" select="substring-after($node, '/')"></xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="node-parent-in-document">
                            <xsl:with-param name="running-value" select="substring-before($node, '/')"></xsl:with-param>
                            <xsl:with-param name="node" select="substring-after($node, '/')"></xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$running-value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="compare-node-order">
        <xsl:param name="lhs"/>
        <xsl:param name="rhs"/>

        <xsl:choose>
            <xsl:when test="starts-with($lhs, '-') and starts-with($rhs, '+')">
                <xsl:value-of select="'lhs'"/>
            </xsl:when>
            <xsl:when test="starts-with($lhs, '+') and starts-with($rhs, '-')">
                <xsl:value-of select="'rhs'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="result">
                    <xsl:call-template name="strcmp">
                        <xsl:with-param name="lhs"
                            select="substring(substring-before($lhs, ':'), 2)"/>
                        <xsl:with-param name="rhs"
                            select="substring(substring-before($rhs, ':'), 2)"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$result = 'same'">
                        <xsl:call-template name="compare-node-order-same-document">
                            <xsl:with-param name="lhs" select="substring-after($lhs, ':')"/>
                            <xsl:with-param name="rhs" select="substring-after($rhs, ':')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$result"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="compare-node-order-same-document">
        <xsl:param name="lhs"/>
        <xsl:param name="rhs"/>

        <xsl:choose>
            <xsl:when test="string-length($lhs) = 0 and string-length($rhs) = 0">
                <xsl:value-of select="'same'"/>
            </xsl:when>
            <xsl:when test="string-length($lhs) = 0">
                <xsl:value-of select="'lhs'"/>
            </xsl:when>
            <xsl:when test="string-length($rhs) = 0">
                <xsl:value-of select="'rhs'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="lhs-first">
                    <xsl:choose>
                        <xsl:when test="contains($lhs, '/')">
                            <xsl:value-of select="substring-before($lhs, '/')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$lhs"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="rhs-first">
                    <xsl:choose>
                        <xsl:when test="contains($rhs, '/')">
                            <xsl:value-of select="substring-before($rhs, '/')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$rhs"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when
                        test="starts-with($lhs-first, '!') and not(starts-with($rhs-first, '!'))">
                        <xsl:value-of select="'lhs'"/>
                    </xsl:when>
                    <xsl:when
                        test="starts-with($rhs-first, '!') and not(starts-with($lhs-first, '!'))">
                        <xsl:value-of select="'rhs'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($rhs-first, '!') and starts-with($lhs-first, '!')">
                        <xsl:call-template name="strcmp">
                            <xsl:with-param name="lhs" select="substring($lhs-first, 2)"/>
                            <xsl:with-param name="rhs" select="substring($rhs-first, 2)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when
                        test="starts-with($lhs-first, '@') and not(starts-with($rhs-first, '@'))">
                        <xsl:value-of select="'lhs'"/>
                    </xsl:when>
                    <xsl:when
                        test="starts-with($rhs-first, '@') and not(starts-with($lhs-first, '@'))">
                        <xsl:value-of select="'rhs'"/>
                    </xsl:when>
                    <xsl:when test="starts-with($rhs-first, '@') and starts-with($lhs-first, '@')">
                        <xsl:call-template name="strcmp">
                            <xsl:with-param name="lhs" select="substring($lhs-first, 2)"/>
                            <xsl:with-param name="rhs" select="substring($rhs-first, 2)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="$lhs-first &lt; $rhs-first">
                        <xsl:value-of select="'lhs'"/>
                    </xsl:when>
                    <xsl:when test="$lhs-first &gt; $rhs-first">
                        <xsl:value-of select="'rhs'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="compare-node-order-same-document">
                            <xsl:with-param name="lhs">
                                <xsl:choose>
                                    <xsl:when test="contains($lhs, '/')">
                                        <xsl:value-of select="substring-after($lhs, '/')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="''"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:with-param>
                            <xsl:with-param name="rhs">
                                <xsl:choose>
                                    <xsl:when test="contains($rhs, '/')">
                                        <xsl:value-of select="substring-after($rhs, '/')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="''"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="node-function">
        <xsl:param name="path"/>
        <xsl:param name="axis"/>
        <xsl:param name="node-type"/>
        <xsl:param name="namespace"/>
        <xsl:param name="local-name"/>
        <xsl:param name="argument"/>
        <xsl:param name="lhs"/>
        <xsl:param name="rhs"/>
        <xsl:param name="operator"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="function"/>

        <xsl:choose>
            <xsl:when test="$path = '-'">
                <xsl:apply-templates select="$function">
                    <xsl:with-param name="context-node" select="/.."/>
                    <xsl:with-param name="axis" select="$axis"/>
                    <xsl:with-param name="node-type" select="$node-type"/>
                    <xsl:with-param name="namespace" select="$namespace"/>
                    <xsl:with-param name="local-name" select="$local-name"/>
                    <xsl:with-param name="argument" select="$argument"/>
                    <xsl:with-param name="lhs" select="$lhs"/>
                    <xsl:with-param name="rhs" select="$rhs"/>
                    <xsl:with-param name="operator" select="$operator"/>
                    <xsl:with-param name="path" select="path"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$stylesheet"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="document-path">
                    <xsl:call-template name="decode">
                        <xsl:with-param name="expr"
                            select="substring-before(substring($path, 2), ':')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="starts-with($path, '+') and normalize-space($document-path)">
                        <xsl:call-template name="node-function-in-document">
                            <xsl:with-param name="context-node"
                                select="document($document-path, $document)"/>
                            <xsl:with-param name="axis" select="$axis"/>
                            <xsl:with-param name="node-type" select="$node-type"/>
                            <xsl:with-param name="namespace" select="$namespace"/>
                            <xsl:with-param name="local-name" select="$local-name"/>
                            <xsl:with-param name="argument" select="$argument"/>
                            <xsl:with-param name="lhs" select="$lhs"/>
                            <xsl:with-param name="rhs" select="$rhs"/>
                            <xsl:with-param name="operator" select="$operator"/>
                            <xsl:with-param name="original-path" select="$path"/>
                            <xsl:with-param name="path" select="substring-after($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            <xsl:with-param name="function" select="$function"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="starts-with($path, '+')">
                        <xsl:call-template name="node-function-in-document">
                            <xsl:with-param name="context-node" select="$document"/>
                            <xsl:with-param name="axis" select="$axis"/>
                            <xsl:with-param name="node-type" select="$node-type"/>
                            <xsl:with-param name="namespace" select="$namespace"/>
                            <xsl:with-param name="local-name" select="$local-name"/>
                            <xsl:with-param name="argument" select="$argument"/>
                            <xsl:with-param name="lhs" select="$lhs"/>
                            <xsl:with-param name="rhs" select="$rhs"/>
                            <xsl:with-param name="operator" select="$operator"/>
                            <xsl:with-param name="original-path" select="$path"/>
                            <xsl:with-param name="path" select="substring-after($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            <xsl:with-param name="function" select="$function"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="starts-with($path, '-') and normalize-space($document-path)">
                        <xsl:call-template name="node-function-in-document">
                            <xsl:with-param name="context-node"
                                select="document($document-path, $stylesheet)"/>
                            <xsl:with-param name="axis" select="$axis"/>
                            <xsl:with-param name="node-type" select="$node-type"/>
                            <xsl:with-param name="namespace" select="$namespace"/>
                            <xsl:with-param name="local-name" select="$local-name"/>
                            <xsl:with-param name="argument" select="$argument"/>
                            <xsl:with-param name="lhs" select="$lhs"/>
                            <xsl:with-param name="rhs" select="$rhs"/>
                            <xsl:with-param name="operator" select="$operator"/>
                            <xsl:with-param name="original-path" select="$path"/>
                            <xsl:with-param name="path" select="substring-after($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            <xsl:with-param name="function" select="$function"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="starts-with($path, '-')">
                        <xsl:call-template name="node-function-in-document">
                            <xsl:with-param name="context-node" select="$stylesheet"/>
                            <xsl:with-param name="axis" select="$axis"/>
                            <xsl:with-param name="node-type" select="$node-type"/>
                            <xsl:with-param name="namespace" select="$namespace"/>
                            <xsl:with-param name="local-name" select="$local-name"/>
                            <xsl:with-param name="argument" select="$argument"/>
                            <xsl:with-param name="lhs" select="$lhs"/>
                            <xsl:with-param name="rhs" select="$rhs"/>
                            <xsl:with-param name="operator" select="$operator"/>
                            <xsl:with-param name="original-path" select="$path"/>
                            <xsl:with-param name="path" select="substring-after($path, ':')"/>
                            <xsl:with-param name="context" select="$context"/>
                            <xsl:with-param name="document" select="$document"/>
                            <xsl:with-param name="stylesheet" select="$stylesheet"/>
                            <xsl:with-param name="function" select="$function"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="node-function-in-document">
        <xsl:param name="context-node"/>
        <xsl:param name="path"/>
        <xsl:param name="axis"/>
        <xsl:param name="node-type"/>
        <xsl:param name="namespace"/>
        <xsl:param name="local-name"/>
        <xsl:param name="argument"/>
        <xsl:param name="lhs"/>
        <xsl:param name="rhs"/>
        <xsl:param name="operator"/>
        <xsl:param name="original-path"/>
        <xsl:param name="context"/>
        <xsl:param name="document"/>
        <xsl:param name="stylesheet"/>
        <xsl:param name="function"/>

        <xsl:choose>
            <xsl:when test="string-length($path) = 0">
                <xsl:apply-templates select="$function">
                    <xsl:with-param name="context-node" select="$context-node"/>
                    <xsl:with-param name="axis" select="$axis"/>
                    <xsl:with-param name="node-type" select="$node-type"/>
                    <xsl:with-param name="namespace" select="$namespace"/>
                    <xsl:with-param name="local-name" select="$local-name"/>
                    <xsl:with-param name="argument" select="$argument"/>
                    <xsl:with-param name="lhs" select="$lhs"/>
                    <xsl:with-param name="rhs" select="$rhs"/>
                    <xsl:with-param name="operator" select="$operator"/>
                    <xsl:with-param name="path" select="$original-path"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:when test="starts-with($path, '!')">
                <xsl:variable name="step-localname" select="substring-after($path, '!')"/>
                <xsl:call-template name="node-function-in-document">
                    <xsl:with-param name="context-node"
                        select="$context-node/namespace::*[local-name() = $step-localname]"/>
                    <xsl:with-param name="path" select="''"/>
                    <xsl:with-param name="axis" select="$axis"/>
                    <xsl:with-param name="node-type" select="$node-type"/>
                    <xsl:with-param name="namespace" select="$namespace"/>
                    <xsl:with-param name="local-name" select="$local-name"/>
                    <xsl:with-param name="argument" select="$argument"/>
                    <xsl:with-param name="lhs" select="$lhs"/>
                    <xsl:with-param name="rhs" select="$rhs"/>
                    <xsl:with-param name="operator" select="$operator"/>
                    <xsl:with-param name="original-path" select="$path"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="function" select="$function"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with($path, '@{')">
                <!-- attribute, namespaced -->
                <xsl:variable name="step-namespace">
                    <xsl:call-template name="decode">
                        <xsl:with-param name="expr"
                            select="substring-before(substring-after($path, '{'), '}')"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="step-localname" select="substring-after($path, '}')"/>
                <xsl:call-template name="node-function-in-document">
                    <xsl:with-param name="context-node"
                        select="$context-node/attribute::*[namespace-uri() = $step-namespace and local-name() = $step-localname]"/>
                    <xsl:with-param name="path" select="''"/>
                    <xsl:with-param name="axis" select="$axis"/>
                    <xsl:with-param name="node-type" select="$node-type"/>
                    <xsl:with-param name="namespace" select="$namespace"/>
                    <xsl:with-param name="local-name" select="$local-name"/>
                    <xsl:with-param name="argument" select="$argument"/>
                    <xsl:with-param name="lhs" select="$lhs"/>
                    <xsl:with-param name="rhs" select="$rhs"/>
                    <xsl:with-param name="operator" select="$operator"/>
                    <xsl:with-param name="original-path" select="$path"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="function" select="$function"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with($path, '@')">
                <!-- attribute, no namespace -->
                <xsl:variable name="step-localname" select="substring-after($path, '@')"/>
                <xsl:call-template name="node-function-in-document">
                    <xsl:with-param name="context-node"
                        select="$context-node/attribute::*[local-name() = name() and local-name() = $step-localname]"/>
                    <xsl:with-param name="path" select="''"/>
                    <xsl:with-param name="axis" select="$axis"/>
                    <xsl:with-param name="node-type" select="$node-type"/>
                    <xsl:with-param name="namespace" select="$namespace"/>
                    <xsl:with-param name="local-name" select="$local-name"/>
                    <xsl:with-param name="argument" select="$argument"/>
                    <xsl:with-param name="lhs" select="$lhs"/>
                    <xsl:with-param name="rhs" select="$rhs"/>
                    <xsl:with-param name="operator" select="$operator"/>
                    <xsl:with-param name="original-path" select="$path"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="function" select="$function"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="position">
                    <xsl:choose>
                        <xsl:when test="contains($path, '/')">
                            <xsl:value-of select="substring-before($path, '/')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$path"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="node-function-in-document">
                    <xsl:with-param name="context-node"
                        select="$context-node/child::node()[count(preceding-sibling::node()) + 1 = $position]"/>
                    <xsl:with-param name="path">
                        <xsl:choose>
                            <xsl:when test="contains($path, '/')">
                                <xsl:value-of select="substring-after($path, '/')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="''"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                    <xsl:with-param name="axis" select="$axis"/>
                    <xsl:with-param name="node-type" select="$node-type"/>
                    <xsl:with-param name="namespace" select="$namespace"/>
                    <xsl:with-param name="local-name" select="$local-name"/>
                    <xsl:with-param name="argument" select="$argument"/>
                    <xsl:with-param name="lhs" select="$lhs"/>
                    <xsl:with-param name="rhs" select="$rhs"/>
                    <xsl:with-param name="operator" select="$operator"/>
                    <xsl:with-param name="original-path" select="$original-path"/>
                    <xsl:with-param name="context" select="$context"/>
                    <xsl:with-param name="document" select="$document"/>
                    <xsl:with-param name="stylesheet" select="$stylesheet"/>
                    <xsl:with-param name="function" select="$function"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="union">
        <xsl:param name="lhs"/>
        <xsl:param name="rhs"/>

        <xsl:variable name="lhs-type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$lhs"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$lhs-type != 'nodeset'">
            <xsl:message terminate="yes">LHS of union not node-set</xsl:message>
        </xsl:if>

        <xsl:variable name="rhs-type">
            <xsl:call-template name="value-type">
                <xsl:with-param name="expr" select="$rhs"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="$rhs-type != 'nodeset'">
            <xsl:message terminate="yes">RHS of union not node-set</xsl:message>
        </xsl:if>

        <xsl:choose>
            <xsl:when test="$lhs = 'NS:-'">
                <xsl:value-of select="$rhs"/>
            </xsl:when>
            <xsl:when test="$rhs = 'NS:-'">
                <xsl:value-of select="$lhs"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="result">
                    <xsl:call-template name="union-node">
                        <xsl:with-param name="lhs" select="substring-after($lhs, ':')"/>
                        <xsl:with-param name="rhs" select="substring-after($rhs, ':')"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="concat('NS:', $result)"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="union-node">
        <xsl:param name="lhs"/>
        <xsl:param name="rhs"/>
        <xsl:param name="running-value"/>

        <xsl:choose>
            <xsl:when test="string-length($lhs) = 0 and string-length($rhs) = 0">
                <xsl:value-of select="$running-value"/>
            </xsl:when>
            <xsl:when test="string-length($rhs) = 0">
                <xsl:value-of select="concat($running-value, ';', $lhs)"/>
            </xsl:when>
            <xsl:when test="string-length($lhs) = 0">
                <xsl:value-of select="concat($running-value, ';', $rhs)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="peel-from">
                    <xsl:variable name="lhs-first">
                        <xsl:choose>
                            <xsl:when test="contains($lhs, ';')">
                                <xsl:value-of select="substring-before($lhs, ';')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$lhs"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="rhs-first">
                        <xsl:choose>
                            <xsl:when test="contains($rhs, ';')">
                                <xsl:value-of select="substring-before($rhs, ';')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$rhs"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:call-template name="compare-node-order">
                        <xsl:with-param name="lhs" select="$lhs-first"/>
                        <xsl:with-param name="rhs" select="$rhs-first"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$peel-from = 'rhs'">
                        <xsl:choose>
                            <xsl:when test="contains($rhs, ';')">
                                <xsl:call-template name="union-node">
                                    <xsl:with-param name="lhs" select="$lhs"/>
                                    <xsl:with-param name="rhs" select="substring-after($rhs, ';')"/>
                                    <xsl:with-param name="running-value">
                                        <xsl:choose>
                                            <xsl:when test="$running-value">
                                                <xsl:value-of
                                                  select="concat($running-value, ';', substring-before($rhs, ';'))"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="substring-before($rhs, ';')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Last of RHS.  Take rest of LHS. -->
                                <xsl:choose>
                                    <xsl:when test="$running-value">
                                        <xsl:value-of
                                            select="concat($running-value, ';', $rhs, ';', $lhs)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat($rhs, ';', $lhs)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$peel-from = 'lhs'">
                        <xsl:choose>
                            <xsl:when test="contains($lhs, ';')">
                                <xsl:call-template name="union-node">
                                    <xsl:with-param name="lhs" select="substring-after($lhs, ';')"/>
                                    <xsl:with-param name="rhs" select="$rhs"/>
                                    <xsl:with-param name="running-value">
                                        <xsl:choose>
                                            <xsl:when test="$running-value">
                                                <xsl:value-of
                                                  select="concat($running-value, ';', substring-before($lhs, ';'))"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="substring-before($lhs, ';')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Last of LHS.  Take rest from RHS. -->
                                <xsl:choose>
                                    <xsl:when test="$running-value">
                                        <xsl:value-of
                                            select="concat($running-value, ';', $lhs, ';', $rhs)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat($lhs, ';', $rhs)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Same. -->
                        <xsl:choose>
                            <xsl:when test="contains($lhs, ';') and contains($rhs, ';')">
                                <xsl:call-template name="union-node">
                                    <xsl:with-param name="lhs" select="substring-after($lhs, ';')"/>
                                    <xsl:with-param name="rhs" select="substring-after($rhs, ';')"/>
                                    <xsl:with-param name="running-value">
                                        <xsl:choose>
                                            <xsl:when test="$running-value">
                                                <xsl:value-of
                                                  select="concat($running-value, ';', substring-before($lhs, ';'))"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="substring-before($lhs, ';')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="contains($lhs, ';')">
                                <xsl:call-template name="union-node">
                                    <xsl:with-param name="lhs" select="substring-after($lhs, ';')"/>
                                    <xsl:with-param name="rhs" select="''"/>
                                    <xsl:with-param name="running-value">
                                        <xsl:choose>
                                            <xsl:when test="$running-value">
                                                <xsl:value-of
                                                  select="concat($running-value, ';', $rhs)"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$rhs"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="contains($rhs, ';')">
                                <xsl:call-template name="union-node">
                                    <xsl:with-param name="lhs" select="''"/>
                                    <xsl:with-param name="rhs" select="substring-after($rhs, ';')"/>
                                    <xsl:with-param name="running-value">
                                        <xsl:choose>
                                            <xsl:when test="$running-value">
                                                <xsl:value-of
                                                  select="concat($running-value, ';', $lhs)"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$lhs"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="union-node">
                                    <xsl:with-param name="lhs" select="''"/>
                                    <xsl:with-param name="rhs" select="''"/>
                                    <xsl:with-param name="running-value">
                                        <xsl:choose>
                                            <xsl:when test="$running-value">
                                                <xsl:value-of
                                                  select="concat($running-value, ';', $lhs)"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$lhs"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>

                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="strcmp">
        <xsl:param name="lhs"/>
        <xsl:param name="rhs"/>

        <xsl:choose>
            <xsl:when test="not($lhs) and not($rhs)">
                <xsl:value-of select="'same'"/>
            </xsl:when>
            <xsl:when test="not($lhs)">
                <xsl:value-of select="'lhs'"/>
            </xsl:when>
            <xsl:when test="not($rhs)">
                <xsl:value-of select="'rhs'"/>
            </xsl:when>
            <xsl:when test="substring($lhs, 1, 1) = substring($rhs, 1, 1)">
                <xsl:call-template name="strcmp">
                    <xsl:with-param name="lhs" select="substring($lhs, 2)"/>
                    <xsl:with-param name="rhs" select="substring($rhs, 2)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="chrcmp">
                    <xsl:with-param name="lhs" select="substring($lhs, 1, 1)"/>
                    <xsl:with-param name="rhs" select="substring($rhs, 1, 1)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:variable name="collation"
        select="concat(' !@#${}[]()*^%-_=+\|;:,./?`~', &quot;&apos;&quot;, '&quot;', '&lt;', '&gt;', '&amp;',
        '0123456789',
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
        'abcdefghijklmnopqrstuvwxyz')"/>

    <xsl:template name="chrcmp">
        <xsl:param name="lhs"/>
        <xsl:param name="rhs"/>

        <xsl:variable name="lhs-ordinal" select="string-length(substring-before($collation, $lhs))"/>
        <xsl:variable name="rhs-ordinal" select="string-length(substring-before($collation, $rhs))"/>
        <xsl:choose>
            <xsl:when test="$lhs-ordinal &lt; $rhs-ordinal">
                <xsl:value-of select="'lhs'"/>
            </xsl:when>
            <xsl:when test="$lhs-ordinal &gt; $rhs-ordinal">
                <xsl:value-of select="'rhs'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'same'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="hash-lookup">
        <xsl:param name="hash"/>
        <xsl:param name="key"/>

        <xsl:variable name="key-encoded">
            <xsl:call-template name="encode">
                <xsl:with-param name="expr" select="$key"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="contains($hash, concat(';', $key-encoded, ':'))">
                <xsl:call-template name="decode">
                    <xsl:with-param name="expr"
                        select="substring-before(
                        substring-after($hash, concat(';', $key-encoded, ':')),
                        ';')"
                    />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'-'"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="hash-replace">
        <xsl:param name="hash"/>
        <xsl:param name="key"/>
        <xsl:param name="value"/>

        <xsl:variable name="key-encoded">
            <xsl:call-template name="encode">
                <xsl:with-param name="expr" select="$key"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="value-encoded">
            <xsl:call-template name="encode">
                <xsl:with-param name="expr" select="$value"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="contains($hash, concat(';', $key-encoded, ':'))">
                <xsl:value-of
                    select="concat(
                    substring-before($hash, concat(';', $key-encoded, ':')),
                    ';', $key-encoded, ':', $value-encoded, ';',
                    substring-after(substring-after($hash, concat(';', $key-encoded, ':')), ';'))"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($hash, $key-encoded, ':', $value-encoded, ';')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="namespaces-of-node">
        <xsl:param name="node"/>

        <xsl:variable name="namespaces">
            <xsl:for-each select="$node/namespace::*">
                <xsl:text>;</xsl:text>
                <xsl:value-of select="local-name(.)"/>
                <xsl:text>:</xsl:text>
                <xsl:call-template name="encode">
                    <xsl:with-param name="expr" select="string(.)"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:value-of select="concat(string($namespaces), ';')"/>
    </xsl:template>
    
    <xsl:template name="last-item">
        <xsl:param name="expr"/>
        <xsl:param name="separator" select="';'"></xsl:param>
        
        <xsl:choose>
            <xsl:when test="contains($expr, $separator)">
                <xsl:call-template name="last-item">
                    <xsl:with-param name="expr" select="substring-after($expr, $separator)"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$expr"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="node-type">
        <xsl:param name="document"></xsl:param>
        <xsl:param name="stylesheet"></xsl:param>
        <xsl:param name="node"></xsl:param>
        
        <xsl:call-template name="node-function">
            <xsl:with-param name="document" select="$document"></xsl:with-param>
            <xsl:with-param name="stylesheet" select="$stylesheet"></xsl:with-param>
            <xsl:with-param name="path" select="$node"></xsl:with-param>
            <xsl:with-param name="function" select="document('')/xsl:stylesheet/*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter/nodeset-node-type']"></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <nodeset-node-type:function/>
    <xsl:template match="*[namespace-uri() = 'http://futzle.com/2006/xslt-interpreter/nodeset-node-type']">
        <xsl:param name="context-node"></xsl:param>
        
        <xsl:choose>
            <xsl:when test="not($context-node/..)">
                <xsl:value-of select="'document'"/>
            </xsl:when>
            <xsl:when test="$context-node/self::text()">
                <xsl:value-of select="'text'"/>
            </xsl:when>
            <xsl:when test="$context-node/self::comment()">
                <xsl:value-of select="'comment'"/>
            </xsl:when>
            <xsl:when test="$context-node/self::*">
                <xsl:value-of select="'element'"/>
            </xsl:when>
            <xsl:when test="$context-node/self::processing-instruction()">
                <xsl:value-of select="'processing-instruction'"/>
            </xsl:when>
            <xsl:when test="$context-node = $context-node/../@*">
                <xsl:value-of select="'attribute'"/>
            </xsl:when>
            <xsl:when test="$context-node = $context-node/../namespace::*">
                <xsl:value-of select="'namespace'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">
                    <xsl:text>Cannot identify type of node </xsl:text>
                    <xsl:value-of select="generate-id($context-node)"/>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="merge-text-nodes">
        <xsl:param name="lhs"></xsl:param>
        <xsl:param name="rhs"></xsl:param>
        
        <xsl:choose>
            <xsl:when test="string-length($lhs) = 0">
                <xsl:value-of select="$rhs"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="lhs-last">
                    <xsl:call-template name="last-item">
                        <xsl:with-param name="expr" select="substring($lhs, 1, string-length($lhs)-1)"></xsl:with-param>
                        <xsl:with-param name="separator" select="';'"></xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="starts-with($lhs-last, 't:') and starts-with($rhs, 't:')">
                        <xsl:value-of select="concat(substring($lhs, 1, string-length($lhs) - 1), substring-after($rhs, 't:'))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($lhs, $rhs)"/>
                    </xsl:otherwise>
                </xsl:choose>                
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="resolve-href">
        <xsl:param name="base"></xsl:param>
        <xsl:param name="href"></xsl:param>
        
        <xsl:choose>
            <xsl:when test="$href = ''">
                <xsl:value-of select="$base"/>
            </xsl:when>
            <xsl:when test="contains($href, '://')">
                <xsl:value-of select="$href"/>
            </xsl:when>
            <xsl:when test="not(contains($base, '/'))">
                <xsl:value-of select="$href"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="basename">
                    <xsl:call-template name="last-item">
                        <xsl:with-param name="expr" select="$base"></xsl:with-param>
                        <xsl:with-param name="separator" select="'/'"></xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat(substring($base, 1, string-length($base) - string-length($basename)), $href)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
