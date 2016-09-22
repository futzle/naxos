<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    
    <xsl:template match="deck">
        <deck>
            <xsl:apply-templates select="*">
                <xsl:sort data-type="number"
                 order="descending" select="position() mod 2"/>
                <xsl:sort data-type="number"
                 order="ascending" select="position()"/>
            </xsl:apply-templates>
        </deck>
    </xsl:template>
    
    <xsl:template match="card">
        <card>
            <xsl:value-of select="."/>
        </card>
    </xsl:template>
</xsl:stylesheet>
