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
  <xsl:template match="/AliExpressOrder">
    <PurchaseOrder>
      <!-- Set SourceOrderId and OrderSource -->
      <OrderID>
        <xsl:value-of select="user:getguid()"/>
        <!--<xsl:value-of select="AliOrderID"/>-->
      </OrderID>
      <OrderDate>
        <xsl:value-of select="Timestamp"/>
      </OrderDate>
      <OrderSource>AliExpress</OrderSource>
      <!-- Hardcoded for AliExpress -->
      <SourceOrderId>
        <xsl:value-of select="AliOrderID"/>
      </SourceOrderId>

      <!-- Map Buyer Details -->
      <Buyer>
        <Name>
          <xsl:value-of select="BuyerDetails/BuyerName"/>
        </Name>
        <Address>
          <xsl:value-of select="BuyerDetails/BuyerAddress"/>
        </Address>
        <Email>
          <xsl:text>N/A</xsl:text>
          <!-- AliExpress schema does not include email -->
        </Email>
        <Phone>
          <xsl:value-of select="BuyerDetails/ContactPhone"/>
        </Phone>
      </Buyer>

      <!-- Map Items -->
      <Items>
        <xsl:for-each select="ProductList/ProductItem">
          <Item>
            <ProductID>
              <xsl:value-of select="ItemID"/>
            </ProductID>
            <ShortDescription>
              <xsl:value-of select="ProductName"/>
            </ShortDescription>
            <Quantity>
              <xsl:value-of select="Quantity"/>
            </Quantity>
            <UnitPrice>
              <xsl:value-of select="UnitCost"/>
            </UnitPrice>
            <TotalPrice>
              <xsl:value-of select="UnitCost * Quantity"/>
            </TotalPrice>
          </Item>
        </xsl:for-each>
      </Items>

      <!-- Map Shipping -->
      <Shipping>
        <ShippingMethod>Standard</ShippingMethod>
        <!-- Hardcoded, AliExpress typically uses standard shipping -->
        <ShippingAddress>
          <xsl:value-of select="BuyerDetails/BuyerAddress"/>
        </ShippingAddress>
        <ExpectedDeliveryDate>
          <xsl:value-of select="user:getdate(3)"/>
        </ExpectedDeliveryDate>
      </Shipping>

      <!-- Map Payment -->
      <Payment>
        <PaymentMethod>
          <xsl:value-of select="FinalPayment/PaymentMethod"/>
        </PaymentMethod>
        <TotalAmount>
          <xsl:value-of select="FinalPayment/AmountDue"/>
        </TotalAmount>
        <Terms>
          <xsl:text>Net 10</xsl:text>
          <!-- Default payment terms for AliExpress -->
        </Terms>
      </Payment>
    </PurchaseOrder>
  </xsl:template>
</xsl:stylesheet>