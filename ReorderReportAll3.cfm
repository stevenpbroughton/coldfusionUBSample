<cftry>
<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Reorder Report (All)</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link rel="stylesheet" href="ReportCSS.css">
</head>
<body onload="toggle();toggle2();toggle3();"  align="center" class="PageText">
<h2 align="center"><strong>Reorder Report (All)</strong></h2>
<p align="center">
<a href="/index.cfm">Report Menu</a> | <a href="/reorderreportall3.cfm">Reorder Report (All)</a> | <a href="/reorderreportlarge3.cfm">Reorder Report (large)</a> | <a href="/reorderreportwholesale3.cfm">Reorder Report (Wholesale)</a> | <a href="/reorderreportretail3.cfm">Reorder Report (Retail)</a>
</p>
<p align="center"> <strong>**NOTE: In order for all the data to be valid the StartDate MUST be no earlier than 01/01/2016!</strong></p>
<cfset theDay = #DateFormat(now(), "dd")#>
<cfset theMonth = #DateFormat(now(), "mm")#>
<cfset theYear = #DateFormat(now(), "yyyy")#>
<cfset startDate = #DateFormat(createdate(theYear,1,1),"mm/dd/yyyy")# > <!---  first of current month --->
<cfset startDateLastYear = #DateFormat(createdate(theYear-1,1,1),"mm/dd/yyyy")# >
<cfset today = #DateFormat(createdate(theYear,theMonth,theDay),"mm/dd/yyyy")# > <!---  first of current month --->
<cfset todayLastYear = #DateFormat(createdate(theYear-1,theMonth,theDay),"mm/dd/yyyy")# >
<cfset startDate2YearsAgo = #DateFormat(createdate(theYear-2,1,1),"mm/dd/yyyy")# > 
<cfset today2YearsAgo = #DateFormat(createdate(theYear-2,theMonth,theDay),"mm/dd/yyyy")# >
<cfparam name="form.submit" default="">
<cfparam name="Form.startdate" default="#dateformat(startDate, 'mm/dd/yyyy')#"> 
<cfparam name="Form.enddate" default="#dateformat(today, 'mm/dd/yyyy')#"> 
<cfparam name="Form.txtStockCode" default="">
<cfparam name="Form.txtProductLine" default="Advent">
<cfform name="myForm" action="" method="post" >
	<cfquery name="getDateLastRun" datasource="WhoOrderedWhatReportDB">
		SELECT * 
		FROM tblLastRun
	</cfquery>
	<cfquery name="WhoOrderedWhat" datasource="WhoOrderedWhatReportDB">
	SELECT *
	FROM tblWhoAllOrderedWhat
	WHERE OrderDate >= #createodbcdate(Form.startdate)# And OrderDate <= #createodbcdate(Form.endDate)# AND CustomerClass <> '40' <cfif isdefined("Form.submit")><cfif Form.txtStockCode neq ""> AND stockcode = '<cfoutput>#Form.txtStockCode#</cfoutput>'</cfif><cfif Form.txtProductLine neq "*"><cfif Form.txtProductLine eq ""> AND productline IS NULL <cfelse> AND productline = '<cfoutput>#Form.txtProductLine#</cfoutput>'</cfif></cfif></cfif> AND MORDERQTY >= 1
	ORDER BY  OrderDate ASC, Stockcode ASC, Customer, Salesorder, SalesOrderLine
	</cfquery>
	<cfquery name="WhoOrderedWhatStockCodeDropdown" datasource="WhoOrderedWhatReportDB">
	SELECT distinct dbo_Products_QuickShopTest.Stockcode, dbo_Products_QuickShopTest.Description, dbo_Products_QuickShopTest.LongDesc, dbo_Products_QuickShopTest.ProductLine
	FROM dbo_Products_QuickShopTest
	WHERE 1=1 <!--- <cfif isdefined("Form.submit")><cfif Form.txtStockCode neq ""> AND stockcode = <cfoutput>#Form.txtStockCode#</cfoutput></cfif><cfif Form.txtProductLine neq "*"><cfif Form.txtProductLine eq ""> AND productline IS NULL <cfelse> AND productline = '<cfoutput>#Form.txtProductLine#</cfoutput>'</cfif></cfif></cfif> --->
	</cfquery>
	<cfquery name="WhoOrderedWhatProductLineDropdown" datasource="WhoOrderedWhatReportDB">
	SELECT Distinct ProductLine
	From tblWhoAllOrderedWhat
	WHERE OrderDate >= #createodbcdate(Form.startdate)# And OrderDate <= #createodbcdate(Form.endDate)# <!---<cfif isdefined("Form.submit")><cfif Form.txtStockCode neq ""> AND stockcode = '<cfoutput>#Form.txtStockCode#</cfoutput>'</cfif><cfif Form.txtProductLine neq "*"><cfif Form.txtProductLine eq ""> AND productline IS NULL <cfelse> AND productline = '<cfoutput>#Form.txtProductLine#</cfoutput>'</cfif></cfif></cfif> --->
	</cfquery>
	
	
	<!--- list of customer-Stockcode combinations with unique sales order --->
	<cfquery name="WhoOrderedWhatThisDay" dbtype="query">
	SELECT distinct CUSTOMER, Stockcode, SalesOrder, count(SalesOrder) As NumLinesInOrder, Sum(MOrderQty) As SumOfLineQty
	FROM WhoOrderedWhat
	WHERE OrderDate >= #createodbcdate(Form.startdate)# And OrderDate <= #createodbcdate(Form.endDate)# AND CustomerClass <> '40' <cfif isdefined("Form.submit")><cfif Form.txtStockCode neq ""> AND stockcode = '<cfoutput>#Form.txtStockCode#</cfoutput>'</cfif><cfif Form.txtProductLine neq "*"><cfif Form.txtProductLine eq ""> AND productline IS NULL <cfelse> AND productline = '<cfoutput>#Form.txtProductLine#</cfoutput>'</cfif></cfif></cfif>
	Group By Customer, Stockcode, SalesOrder
	Order By CUstomer, Stockcode, SalesOrder
	</cfquery>
	<!--- <cfdump var="#WhoOrderedWhatThisDay#"> --->	
	<!--- number of sales order with unique customer-Stockcode combo --->
	<cfquery name="WhoOrderedWhatCustStockNumSO" dbtype="query"> 	
	SELECT distinct Customer, Stockcode, Count(SalesOrder) As AmountOfSalesOrders, Sum(NumLinesInOrder) As TotalNumLinesThisCustomerThisProduct, Sum(SumOfLineQty) As TotalQuantityOrderedThisCustomerThisProduct
	FROM WhoOrderedWhatThisDay
	Group By StockCode, Customer
	</cfquery>
	<!--- <cfdump var="#WhoOrderedWhatCustomerItemReorderedOnDifferentDate#"> --->	
	
	<!--- only unique sales orders where at least 2 were ordered --->
	<cfquery name="RepeatOrders" dbtype="query"> 
	SELECT distinct Customer, Stockcode, AmountOfSalesOrders, TotalNumLinesThisCustomerThisProduct, TotalQuantityOrderedThisCustomerThisProduct
	FROM WhoOrderedWhatCustStockNumSO
	<!--- WHERE AmountOfSalesOrders > 1 --->
	Order By Stockcode, Customer
	</cfquery>	
	
	<!---   display each repeat order (with all details of sales order)	 --->	
	<cfquery name="RepeatOrdersDetail" dbtype="query"> <!--- repeat orders with everything  --->
	Select RepeatOrders.Customer, RepeatOrders.StockCode, RepeatOrders.TotalNumLinesThisCustomerThisProduct, MORDERQTY, NAME, ORDERDATE, PRODUCTLINE, SALESORDER, SALESORDERLINE, Salesperson, MStockDes
	From WhoOrderedWhat, RepeatOrders
	Where (WhoOrderedWhat.customer = (RepeatOrders.customer) AND WhoOrderedWhat.stockcode = (RepeatOrders.stockcode)) 
	Order By StockCode, Customer, SalesOrder
	</cfquery>
	
	
	<!--- get all distinct stock codes that are found in the repeat order detail --->
	<cfquery name="distinctStockCode"  dbtype="query">
	SELECT distinct WhoOrderedWhatStockCodeDropdown.Stockcode, WhoOrderedWhatStockCodeDropdown.Description, WhoOrderedWhatStockCodeDropdown.LongDesc, WhoOrderedWhatStockCodeDropdown.ProductLine
	FROM WhoOrderedWhatStockCodeDropdown, RepeatOrdersDetail
	WHERE CAST(WhoOrderedWhatStockCodeDropdown.Stockcode as VARCHAR) in(RepeatOrdersDetail.Stockcode)
	</cfquery>
	
<table width="527" align="center"  cellpadding="3" cellspacing="0">
    <tr>
		<td valign="left">Start Date:</td>
		<td valign="left"><cfinput type="dateField" name="startDate" id="startDate" size="10" width="10" value="#Form.startdate#"></td>
		<td valign="left">End Date:</td>
		<td valign="left"><cfinput type="dateField" name="endDate" id="endDate" size="10"  width="10" value="#Form.enddate#"></td>
	</tr>
	<tr>
		<td valign="left">Product Line:</td>
		<td>	
			<CFSELECT NAME="txtProductLine" MESSAGE="Select a Product Line" SIZE="1" multiple="no">
			<OPTION value="*" selected="true">Select All</option>
			<cfloop query="#WhoOrderedWhatProductLineDropdown#">
				<OPTION value="<cfoutput>#WhoOrderedWhatProductLineDropdown.ProductLine#</cfoutput>"<cfif txtProductLine eq #WhoOrderedWhatProductLineDropdown.productline#>selected</cfif>><cfoutput>#WhoOrderedWhatProductLineDropdown.productline#</cfoutput></option>
			</cfloop>
			</CFSELECT>	
		</td>
		<td valign="left">Stock Code:</td>
		<td>	
			<CFSELECT NAME="txtStockCode" MESSAGE="Select a StockCode" SIZE="1" multiple="no">
			<OPTION value="" selected="true">Select All</option>
			<cfloop query="#WhoOrderedWhatStockCodeDropdown#">
				<OPTION value="<cfoutput>#WhoOrderedWhatStockCodeDropdown.stockCode#</cfoutput>"<cfif txtStockCode eq #WhoOrderedWhatStockCodeDropdown.stockcode#>selected</cfif>><cfoutput>#WhoOrderedWhatStockCodeDropdown.stockcode# - #WhoOrderedWhatStockCodeDropdown.Description# - #WhoOrderedWhatStockCodeDropdown.LongDesc#</cfoutput></option>
			</cfloop>
			</CFSELECT>	
		</td>		
	</tr>
	<tr>
		<td>
			<input name="submit" type="submit" value="Run Report">
		</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td><input type="submit" name="toExcelbtn" value="Download as Excel File"></td>		
		<br>		
	</tr>
</table>
</cfform>
<cfif isdefined("Form.submit")>
	<cfif #DateFormat(Form.startdate,"mm/dd")# eq "02/29">
		<cfset form.startdate = DateAdd("d", -1, form.startdate)>
	</cfif>	
	<cfif #DateFormat(Form.enddate,"mm/dd")# eq "02/29">
		<cfset form.enddate = DateAdd("d", -1, form.enddate)>
	</cfif>
	<cfset theDay = #DateFormat(Form.enddate,"dd")# >
</cfif>
<cfif isdefined("Form.toExcelbtn")>
	<cfheader name="Content-Disposition" value="filename=ReorderReportWholesale-#today#.xls">
	<cfcontent type="application/msexcel">				
</cfif>
<p align="Center"><strong><font size="+2">Repeat Orders Summary</font></strong></p>
<p align="center">This Report Updated : <cfoutput>#dateTimeFormat(getDateLastRun.LastRun,"mm-dd-yyyy hh:nn tt")#</cfoutput></p>

<cfif distinctStockCode.recordcount gte 1><!--- if one of the selected stock codes has a repeat --->
	<cfloop query="#distinctStockCode#">
		<div  align="center">
		<table align="center" border="1px" bordercolor="#000000" >
				<tr><td><strong>Product Line</strong></td><td><strong>Stockcode</strong></td><td><strong>Customer #</strong></td><td><strong>Total Num Orders</strong></td><td><strong>Total Quantity</strong></td><td><strong>Quantities</strong></td></tr>
		<cfset FirstOrderQuantitysTotal = 0> <!--- used to get the total quantity this stock code excluding first orders --->
		
		<cfset totalNumRepeatOrdersAllCustomersThisStockcode = 0>
		<cfset totalNumRepeatOrdersAllCustomersThisStockcodeExcludingOriginalOrder = 0>
		<cfset totalRepeatQuantityAllCustomersThisStockcode = 0>
		
		<cfloop query="#RepeatOrders#">
			<cfif distinctStockCode.Stockcode eq RepeatOrders.Stockcode>
			
			<cfset totalNumRepeatOrdersAllCustomersThisStockcode = totalNumRepeatOrdersAllCustomersThisStockcode + RepeatOrders.AmountOfSalesOrders>
			<cfset totalNumRepeatOrdersAllCustomersThisStockcodeExcludingOriginalOrder = totalNumRepeatOrdersAllCustomersThisStockcodeExcludingOriginalOrder + (RepeatOrders.AmountOfSalesOrders - 1)>		
			<cfset totalRepeatQuantityAllCustomersThisStockcode = totalRepeatQuantityAllCustomersThisStockcode + TotalQuantityOrderedThisCustomerThisProduct>
							
				<tr><td><cfoutput>#distinctStockCode.ProductLine#</cfoutput></td><td><cfoutput>#distinctStockCode.Stockcode#</cfoutput> - <cfoutput>#distinctStockCode.Description#</cfoutput> - <cfoutput>#distinctStockCode.LongDesc#</cfoutput></td><td><cfoutput>#RepeatOrders.Customer#</cfoutput></td><td><cfoutput>#RepeatOrders.AmountOfSalesOrders#</cfoutput></td><td><cfoutput>#NumberFormat(RepeatOrders.TotalQuantityOrderedThisCustomerThisProduct)#</cfoutput></td>				
				<td>
				
				<cfif #RepeatOrders.AmountOfSalesOrders# gt 1>				
					<table >
					<tr>
					
					<cfset isFirstOrderQuantity = false>
					
								
					<cfset salesOrderHolder = 0>
					<cfset quantityHolder = 0>
					<cfset counter = 0>
					<cfloop query="#RepeatOrdersDetail#">	
						<cfif RepeatOrdersDetail.Stockcode eq distinctStockCode.Stockcode and RepeatOrdersDetail.Customer eq RepeatOrders.Customer>
								<cfset counter = counter + 1>
								
								<!--- Customer Name: <cfoutput>#RepeatOrdersDetail.Name#</cfoutput>,
								SalesOrder: <cfoutput>#RepeatOrdersDetail.Salesorder#</cfoutput>, --->
								<cfif counter eq 1> <!--- first line item this customer and stockcode --->
									<cfset quantityHolder = RepeatOrdersDetail.morderqty>
									<cfset salesOrderHolder = RepeatOrdersDetail.SalesOrder>
								</cfif>
								
								<cfif counter neq 1 and counter neq RepeatOrdersDetail.TotalNumLinesThisCustomerThisProduct>
									<cfif RepeatOrdersDetail.SalesOrder eq salesOrderHolder>
										<cfset quantityHolder = quantityHolder + RepeatOrdersDetail.morderqty>
									<cfelse>
										<td ><strong><cfoutput>#numberformat(quantityHolder)#</cfoutput></strong>&nbsp;</td>
										<cfif isFirstOrderQuantity eq false>
											<cfset isFirstOrderQuantity = true>
											<cfset FirstOrderQuantitysTotal = FirstOrderQuantitysTotal + quantityHolder>
										</cfif>
										<cfset quantityHolder = RepeatOrdersDetail.morderqty>
									</cfif>
									<cfset salesOrderHolder = RepeatOrdersDetail.SalesOrder>
								</cfif>
								
								<cfif counter eq RepeatOrdersDetail.TotalNumLinesThisCustomerThisProduct> <!--- last record this customer and stock code --->
									<cfif RepeatOrdersDetail.SalesOrder eq salesOrderHolder>
										<cfset quantityHolder = quantityHolder + RepeatOrdersDetail.morderqty>
										<td ><strong><cfoutput>#numberformat(quantityHolder)#</cfoutput></strong>&nbsp;</td>
										<cfif isFirstOrderQuantity eq false>
											<cfset isFirstOrderQuantity = true>
											<cfset FirstOrderQuantitysTotal = FirstOrderQuantitysTotal + quantityHolder>
										</cfif>
										<cfset quantityHolder = 0>
									<cfelse>
										<td ><strong><cfoutput>#numberformat(quantityHolder)#</cfoutput></strong>&nbsp;</td>
										<cfif isFirstOrderQuantity eq false>
											<cfset isFirstOrderQuantity = true>
											<cfset FirstOrderQuantitysTotal = FirstOrderQuantitysTotal + quantityHolder>
										</cfif>
										<cfset quantityHolder = 0>
										<td ><strong><cfoutput>#numberformat(RepeatOrdersDetail.morderqty)#</cfoutput></strong>&nbsp;</td>
										<cfif isFirstOrderQuantity eq false>
											<cfset isFirstOrderQuantity = true>
											<cfset FirstOrderQuantitysTotal = FirstOrderQuantitysTotal + RepeatOrdersDetail.morderqty>
										</cfif>
									</cfif>
									<cfset salesOrderHolder = RepeatOrdersDetail.SalesOrder>
									<cfset isFirstOrderQuantity = false>
								</cfif>
								<!--- <td style="width: 10px;">SO <cfoutput>#RepeatOrdersDetail.Salesorder#</cfoutput>&nbsp;</td>  --->
								<!--- ,Quantity this line: #NumberFormat(RepeatOrdersDetail.morderqty)#
								Order Date: <cfoutput>#DateFormat(RepeatOrdersDetail.OrderDate,"mm/dd/yyyy")#</cfoutput>
								 --->		
						
						</cfif>
					</cfloop>
					
					
					
					</tr>
					</table>
				<cfelse> <!--- these orders not repeated --->
					<table>
						<tr>
							<td><strong><cfoutput>#NumberFormat(RepeatOrders.TotalQuantityOrderedThisCustomerThisProduct)#</cfoutput></td></strong>
						</tr>
					</table>
				</cfif>	
			</td></tr></cfif>			
		</cfloop>
		
		
		<!--- summary row --->
		<tr>
			<td><strong>Totals</strong></td><td>&nbsp;</td><td>&nbsp;</td><td><strong><cfoutput>#totalNumRepeatOrdersAllCustomersThisStockcode#</cfoutput></strong></td><td><strong><cfoutput>#totalRepeatQuantityAllCustomersThisStockcode#</cfoutput></strong></td><td>&nbsp;</td>
		</tr>		
		</table>
		<!--- 
		<p align="center">Total Num Orders Repeated: <strong><cfoutput>#totalNumRepeatOrdersAllCustomersThisStockcode#</cfoutput></strong> &nbsp;
		Total Num Orders Repeated Excluding Original Order: <strong><cfoutput>#totalNumRepeatOrdersAllCustomersThisStockcodeExcludingOriginalOrder#</cfoutput></strong></p>
		<p align="center">Total Quantity Repeated: <strong><cfoutput>#totalRepeatQuantityAllCustomersThisStockcode#</cfoutput></strong> &nbsp;
		Total Quantity Repeated Excluding Original Order: <strong><cfoutput>#totalRepeatQuantityAllCustomersThisStockcode - FirstOrderQuantitysTotal#</cfoutput></strong></p>
		 --->
		</div><br />
	</cfloop>
<cfelse>
	<p align="center"><strong>There are not repeated item(s) orders for the selected item and date range</strong></p>
</cfif>

</body>
</html>
<cfcatch type="any"><cfdump var="#cfcatch#"></cfcatch>
</cftry>