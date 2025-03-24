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
    <!-- Root template -->
    <xsl:template match="/AmazonOrder">
        <PurchaseOrder>
            <!-- Map SourceOrderId and OrderSource -->
            <OrderID>
                <!--<xsl:value-of select="PurchaseOrderID" />-->
                <xsl:value-of select="user:getguid()"/>
            </OrderID>
            <OrderDate>
                <xsl:value-of select="OrderDate" />
            </OrderDate>
            <OrderSource>Amazon</OrderSource> <!-- Hardcoded as this is specific to Amazon -->
            <SourceOrderId>
                <xsl:value-of select="PurchaseOrderID" />
            </SourceOrderId>
            
            <!-- Map Buyer Details -->
            <Buyer>
                <Name>
                    <xsl:value-of select="Customer/CustomerName" />
                </Name>
                <Address>
                    <xsl:value-of select="Customer/CustomerAddress" />
                </Address>
                <Email>
                    <xsl:value-of select="Customer/CustomerEmail" />
                </Email>
                <Phone>
                    <xsl:value-of select="Customer/CustomerPhone" />
                </Phone>
            </Buyer>
            
            <!-- Map Items -->
            <Items>
                <xsl:for-each select="ItemList/OrderItem">
                    <Item>
                        <ProductID>
                            <xsl:value-of select="SKU" />
                        </ProductID>
                        <ShortDescription>
                            <xsl:value-of select="Title" />
                        </ShortDescription>
                        <Quantity>
                            <xsl:value-of select="QuantityOrdered" />
                        </Quantity>
                        <UnitPrice>
                            <xsl:value-of select="ItemPrice" />
                        </UnitPrice>
                        <TotalPrice>
                            <xsl:value-of select="ItemPrice * QuantityOrdered" />
                        </TotalPrice>
                    </Item>
                </xsl:for-each>
            </Items>
            
            <!-- Shipping Information -->
            <Shipping>
                <ShippingMethod>
                    <xsl:value-of select="FulfillmentChannel" />
                </ShippingMethod>
                <ShippingAddress>
                    <xsl:value-of select="Customer/CustomerAddress" />
                </ShippingAddress>
                <ExpectedDeliveryDate>
                    <xsl:value-of select="user:getdate(2)"/>
                </ExpectedDeliveryDate>
            </Shipping>
            
            <!-- Payment Details -->
            <Payment>
                <PaymentMethod>
                    <xsl:value-of select="OrderPayment/PaymentMethod" />
                </PaymentMethod>
                <TotalAmount>
                    <xsl:value-of select="OrderPayment/OrderTotal" />
                </TotalAmount>
                <Terms>
                    <xsl:text>Net 30</xsl:text> <!-- Default payment terms -->
                </Terms>
            </Payment>
        </PurchaseOrder>
    </xsl:template>
</xsl:stylesheet>