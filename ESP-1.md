# ESP Document 1

This is a sample solution of normalizing the **Customer Orders View** in ESP Document 1.

## Customer Orders View

### ONF - List All Attributes

After performing 0NF, a single tabel (entity) was generated: **Order**.

**Order:** (CustomerNumber, FirstName, LastName, Address, City, Province, PostalCode, Phone, Date, <b class="pk">OrderNumber</b>, <b class="gp">{</b> ItemNumber, Description, Quantity, CurrentPrice, SellingPrice, Amount <b class="gp">}</b>, Subtotal, GST, Total)

### 1NF - Identifying Repeating Groups

After performing 1st normal form , a new table was generated:
**Order Detail.**

**Order:** (<b class= "pk"> OrderNumber </b>, <u class= "fk">CustomerNumber</u>, FirstName, LastName, Address, City, Province, PostalCode, Phone, Date, Subtotal, GST, Total)

**Order Detail:** (<b class="pk"><u class="fk"> OrderNumber  ItemNumber </u></b>), Description, Quantity, CurrentPrice, SellingPrice, Amount)

### 2NF

After performing second normal form, another new table was generated: **Item**.

**OrderDetail** (<b class="pk"><u class="fk"> OrderNumber ItemNumber</u> </b>, Quantity, SellingPrice, Amount) 

**Item** (<b class = "pk"> ItemNumber </b>, Description, CurrentPrice)

### 3NF

After performing 3NF, another new table was generated: **Customer**.

**Order:** (<b class= "pk"> OrderNumber </b>, <u class="fk">CustomerNumber</u>, Date, Subtotal, GST, Total)

**Customer:** (<b class= "pk"> CustomerNumber </b>, FirstName, LastName, Address, City, Province, PostalCode, Phone)

### Tables after 3<sup>rd</sup> Normal Form

These are the tables/entities after normalizing the Customer Details View

**Order:** (<b class= "pk"> OrderNumber </b>, <u class="fk">CustomerNumber</u>, Date, Subtotal, GST, Total)

**OrderDetail** (<b class="pk"><u class="fk"> OrderNumber  ItemNumber </u></b>, Quantity, SellingPrice, Amount)

**Item** (<b class = "pk"> ItemNumber </b>, Description, CurrentPrice) 

**Customer:** (<b class= "pk"> CustomerNumber </b>, FirstName, LastName, Address, City, Province, PostalCode, Phone)



----
<style type="text/css"> 
.pk { 
    font-weight: bold; 
    display: inline-block; 
    border: solid thin blue; 
    padding: 0 1px; 
} 
.fk { 
    color: green; 
    font-style: italic; 
    text-decoration: wavy underline green; 
} 
.gp { 
    color: darkorange; 
    font-size: 1.2em; 
    font-weight: bold; 
}
</style>