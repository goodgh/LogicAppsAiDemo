<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:user="urn:my-scripts">
  <msxsl:script language="C#" implements-prefix="user">
    <![CDATA[
  public string getguid(){
     return Guid.NewGuid().ToString();
  }
  public string getdate(int days){
     return DateTime.UtcNow.AddDays(days).ToString("yyyy-MM-dd");
  }
  ]]>
  </msxsl:script>
  <xsl:template match="/eBayOrder">
    <PurchaseOrder>
      <!-- Map SourceOrderId and OrderSource -->
      <OrderID>
        <xsl:value-of select="user:getguid()"/>
        <!--<xsl:value-of select="eBayOrderID"/>-->
      </OrderID>
      <OrderDate>
        <xsl:value-of select="OrderPlacedDate"/>
      </OrderDate>
      <OrderSource>eBay</OrderSource>
      <!-- Hardcoded for eBay -->
      <SourceOrderId>
        <xsl:value-of select="eBayOrderID"/>
      </SourceOrderId>

      <!-- Map Buyer Details -->
      <Buyer>
        <Name>
          <xsl:value-of select="Buyer/FullName"/>
        </Name>
        <Address>
          <xsl:value-of select="Buyer/ShippingAddress"/>
        </Address>
        <Email>
          <xsl:value-of select="Buyer/ContactEmail"/>
        </Email>
        <Phone>
          <xsl:text>N/A</xsl:text>
          <!-- eBay schema lacks phone; default value provided -->
        </Phone>
      </Buyer>

      <!-- Map Items -->
      <Items>
        <xsl:for-each select="Products/Product">
          <Item>
            <ProductID>
              <xsl:value-of select="ProductCode"/>
            </ProductID>
            <ShortDescription>
              <xsl:value-of select="Description"/>
            </ShortDescription>
            <Quantity>
              <xsl:value-of select="Qty"/>
            </Quantity>
            <UnitPrice>
              <xsl:value-of select="PricePerUnit"/>
            </UnitPrice>
            <TotalPrice>
              <xsl:value-of select="PricePerUnit * Qty"/>
            </TotalPrice>
          </Item>
        </xsl:for-each>
      </Items>

      <!-- Shipping Information -->
      <Shipping>
        <ShippingMethod>
          <xsl:value-of select="OrderStatus"/>
        </ShippingMethod>
        <ShippingAddress>
          <xsl:value-of select="Buyer/ShippingAddress"/>
        </ShippingAddress>
        <ExpectedDeliveryDate>
          <xsl:value-of select="user:getdate(1)"/>
        </ExpectedDeliveryDate>
      </Shipping>

      <!-- Payment -->
      <Payment>
        <PaymentMethod>
          <xsl:value-of select="PaymentDetails/PaymentType"/>
        </PaymentMethod>
        <TotalAmount>
          <xsl:value-of select="PaymentDetails/TotalPayable"/>
        </TotalAmount>
        <Terms>
          <xsl:text>Net 15</xsl:text>
          <!-- Default payment terms for eBay -->
        </Terms>
      </Payment>
    </PurchaseOrder>
  </xsl:template>
</xsl:stylesheet>