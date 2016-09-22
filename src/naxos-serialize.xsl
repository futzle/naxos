<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:import href="encoding.xsl"/>

    <xsl:template name="serialize-result-tree">
        <xsl:param name="tree"/>
        <xsl:param name="output"/>

        <xsl:choose>
            <xsl:when test="$output/@method = 'text'">
                <xsl:call-template name="serialize-result-tree-text">
                    <xsl:with-param name="tree" select="$tree"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="serialize-result-tree-xml">
                    <xsl:with-param name="tree" select="$tree"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="serialize-result-tree-text">
        <xsl:param name="tree"/>

        <xsl:call-template name="serialize-result-tree-fragment-text">
            <xsl:with-param name="tree" select="$tree"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="serialize-result-tree-fragment-text">
        <xsl:param name="tree"/>

        <xsl:choose>
            <xsl:when test="string-length($tree) &gt; 0">
                <xsl:variable name="first" select="substring-before($tree, ';')"/>
                <xsl:choose>
                    <xsl:when test="starts-with($first, 'e:')">
                        <xsl:variable name="children">
                            <xsl:call-template name="decode">
                                <xsl:with-param name="expr"
                                    select="substring-after(substring-after(substring-after(substring-after($first, ':'), ':'), ':'), ':')"
                                />
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:call-template name="serialize-result-tree-fragment-text">
                            <xsl:with-param name="tree" select="$children"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="starts-with($first, 't:')">
                        <xsl:call-template name="decode">
                            <xsl:with-param name="expr" select="substring-after($first, 't:')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>

                <xsl:call-template name="serialize-result-tree-fragment-text">
                    <xsl:with-param name="tree" select="substring-after($tree, ';')"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="serialize-result-tree-xml">
        <xsl:param name="tree"/>

        <xsl:call-template name="serialize-result-tree-fragment-xml">
            <xsl:with-param name="tree" select="$tree"/>
        </xsl:call-template>

    </xsl:template>

    <xsl:template name="serialize-result-tree-fragment-xml">
        <xsl:param name="tree"/>

        <xsl:choose>
            <xsl:when test="string-length($tree) &gt; 0">
                <xsl:variable name="first" select="substring-before($tree, ';')"/>
                <xsl:choose>
                    <xsl:when test="starts-with($first, 'e:')">
                        <xsl:variable name="local-name"
                            select="substring-before(substring-after(substring-after(substring-after($first, ':'), ':'), ':'), ':')"/>
                        <xsl:variable name="tag"
                            select="substring-before(substring-after($first, ':'), ':')"/>
                        <xsl:variable name="namespace-uri">
                            <xsl:call-template name="decode">
                                <xsl:with-param name="expr"
                                    select="substring-before(substring-after(substring-after($first, ':'), ':'), ':')"
                                />
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="qname">
                            <xsl:value-of select="$tag"/>
                            <xsl:if test="$tag">
                                <xsl:value-of select="':'"/>
                            </xsl:if>
                            <xsl:value-of select="$local-name"/>
                        </xsl:variable>
                        <xsl:variable name="children">
                            <xsl:call-template name="decode">
                                <xsl:with-param name="expr"
                                    select="substring-after(substring-after(substring-after(substring-after($first, ':'), ':'), ':'), ':')"
                                />
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:text>&lt;</xsl:text>
                        <xsl:value-of select="$qname"/>
                        <!--
                        <xsl:choose>
                            <xsl:when test="$tag">
                                <xsl:text> xmlns:</xsl:text>
                                <xsl:value-of select="$tag"/>
                                <xsl:text>="</xsl:text>
                                <xsl:call-template name="escape-xml">
                                    <xsl:with-param name="expr" select="$namespace-uri"/>
                                </xsl:call-template>
                                <xsl:text>"</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text> xmlns="</xsl:text>
                                <xsl:call-template name="escape-xml">
                                    <xsl:with-param name="expr" select="$namespace-uri"/>
                                </xsl:call-template>
                                <xsl:text>"</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                            -->
                        <xsl:call-template name="serialize-result-tree-fragment-xml-namespaces">
                            <xsl:with-param name="tree" select="$children"/>
                            <!--
                            <xsl:with-param name="element-namespace-tag" select="$tag"></xsl:with-param>
                                -->
                        </xsl:call-template>
                        <xsl:call-template name="serialize-result-tree-fragment-xml-attributes">
                            <xsl:with-param name="tree" select="$children"/>
                        </xsl:call-template>
                        <xsl:text>&gt;</xsl:text>
                        <xsl:call-template name="serialize-result-tree-fragment-xml">
                            <xsl:with-param name="tree" select="$children"/>
                        </xsl:call-template>
                        <xsl:text>&lt;/</xsl:text>
                        <xsl:value-of select="$qname"/>
                        <xsl:text>&gt;</xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with($first, 't:')">
                        <xsl:call-template name="escape-xml">
                            <xsl:with-param name="expr">
                                <xsl:call-template name="decode">
                                    <xsl:with-param name="expr"
                                        select="substring-after($first, 't:')"/>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="starts-with($first, 'c:')">
                        <xsl:text>&lt;!--</xsl:text>
                        <xsl:call-template name="escape-xml">
                            <xsl:with-param name="expr">
                                <xsl:call-template name="decode">
                                    <xsl:with-param name="expr"
                                        select="substring-after($first, 'c:')"/>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:text>--></xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with($first, 'p:')">
                        <xsl:text>&lt;?</xsl:text>
                        <xsl:value-of select="substring-before(substring-after($first, ':'), ':')"/>
                        <xsl:text> </xsl:text>
                        <xsl:call-template name="escape-xml">
                            <xsl:with-param name="expr">
                                <xsl:call-template name="decode">
                                    <xsl:with-param name="expr"
                                        select="substring-after(substring-after($first, ':'), ':')"
                                    />
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:text>?&gt;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>

                <xsl:call-template name="serialize-result-tree-fragment-xml">
                    <xsl:with-param name="tree" select="substring-after($tree, ';')"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="serialize-result-tree-fragment-xml-namespaces">
        <xsl:param name="tree"/>
        <xsl:param name="element-namespace-tag" select="'#deleteme'"/>

        <!-- http://www.w3.org/1999/XSL/Transform -->
        <xsl:choose>
            <xsl:when test="string-length($tree) &gt; 0">
                <xsl:variable name="first" select="substring-before($tree, ';')"/>
                <xsl:choose>
                    <xsl:when test="starts-with($first, 'ns:')">
                        <xsl:variable name="tag">
                            <xsl:call-template name="decode">
                                <xsl:with-param name="expr"
                                    select="substring-before(substring-after($first, ':'), ':')"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="uri">
                            <xsl:call-template name="decode">
                                <xsl:with-param name="expr"
                                    select="substring-after(substring-after($first, ':'), ':')"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:if
                            test="$tag != $element-namespace-tag and $uri != 'http://www.w3.org/1999/XSL/Transform' and $uri != 'http://www.w3.org/XML/1998/namespace'">
                            <xsl:text> xmlns</xsl:text>
                            <xsl:if test="$tag != ''">
                                <xsl:text>:</xsl:text>
                                <xsl:value-of select="$tag"/>
                            </xsl:if>
                            <xsl:text>="</xsl:text>
                            <xsl:call-template name="escape-xml">
                                <xsl:with-param name="expr" select="$uri"/>
                            </xsl:call-template>
                            <xsl:text>"</xsl:text>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>

                <xsl:call-template name="serialize-result-tree-fragment-xml-namespaces">
                    <xsl:with-param name="tree" select="substring-after($tree, ';')"/>
                    <xsl:with-param name="element-namespace-tag" select="$element-namespace-tag"></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>


    </xsl:template>

    <xsl:template name="serialize-result-tree-fragment-xml-attributes">
        <xsl:param name="tree"/>

        <xsl:choose>
            <xsl:when test="string-length($tree) &gt; 0">
                <xsl:variable name="first" select="substring-before($tree, ';')"/>
                <xsl:choose>
                    <xsl:when test="starts-with($first, 'a:')">
                        <xsl:variable name="qname">
                            <xsl:choose>
                                <xsl:when test="substring-before(substring-after($first, ':'), ':') = ''">
                                    <xsl:value-of select="substring-before(substring-after(substring-after($first, ':'), ':'), ':')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="substring-before(substring-after($first, ':'), ':')"/>
                                    <xsl:text>:</xsl:text>
                                    <xsl:value-of select="substring-before(substring-after(substring-after($first, ':'), ':'), ':')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="value">
                            <xsl:call-template name="decode">
                                <xsl:with-param name="expr"
                                    select="substring-after(substring-after(substring-after($first, ':'), ':'), ':')"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$qname"/>
                        <xsl:text>="</xsl:text>
                        <xsl:call-template name="escape-xml">
                            <xsl:with-param name="expr" select="$value"/>
                        </xsl:call-template>
                        <xsl:text>"</xsl:text>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>

                <xsl:call-template name="serialize-result-tree-fragment-xml-attributes">
                    <xsl:with-param name="tree" select="substring-after($tree, ';')"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
