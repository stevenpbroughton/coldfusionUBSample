<cftry>
<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Daily Report - Booked Orders (All)</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<script>
  var toggle = function() {
  var mydiv = document.getElementById('newpost');
  if (mydiv.style.display === 'block' || mydiv.style.display === '')
    mydiv.style.display = 'none';
  else
    mydiv.style.display = 'block'
  }
</script>
<script>
  var toggle2 = function() {
  var mydiv = document.getElementById('newpost2');
  if (mydiv.style.display === 'block' || mydiv.style.display === '')
    mydiv.style.display = 'none';
  else
    mydiv.style.display = 'block'
  }
</script>
<script>
  var toggle3 = function() {
  var mydiv = document.getElementById('newpost3');
  if (mydiv.style.display === 'block' || mydiv.style.display === '')
    mydiv.style.display = 'none';
  else
    mydiv.style.display = 'block'
  }
</script>
<link rel="stylesheet" href="ReportCSS.css">
</head>
<body onload="toggle();toggle2();toggle3();"  align="center" class="PageText">
<h2  align="center"><strong>Booked Orders All</strong></h2>
<p align="center">
<a href="/index.cfm">Report Menu</a> |
<a href="/Daily-Reports_Booked-Orders_All3.cfm">Booked Orders All</a> |
<a href="/Daily-Reports_Booked-Orders_Large3.cfm">Booked Orders Large</a> |
<a href="/Daily-Reports_Booked-Orders_Mom-and-Pop2.cfm">Booked Orders Mom-and-Pop</a> |
<a href="/Daily-Reports_Booked-Orders_Rep3.cfm">Booked Orders Rep</a> |
<a href="/Daily-Reports_Booked-Orders_Retail3.cfm">Booked Orders Retail</a> |
<a href="/Daily-Reports-Daily_Shipment_log.cfm">Daily Shipment Log</a>
</p>
<p  align="center"> <strong>**NOTE: In order for all the data to be valid the StartDate MUST be no earlier than 01/01/2016!</strong></p>
<cfquery name="getDateLastRun" datasource="RetailWebOrdersDB">
	SELECT * 
	FROM tblLastRun
</cfquery>
<cfquery name="getSalesPeople" datasource="RetailWebOrdersDB">
	SELECT DISTINCT tblAllBookedOrders.salesperson, dbo_SALSALESPERSON.Name
	FROM tblAllBookedOrders
	Left Join dbo_SALSALESPERSON ON tblAllBookedOrders.salesperson = dbo_SALSALESPERSON.salesperson
</cfquery>
<!--- set variables --->
<cfset theDay = #DateFormat(getDateLastRun.LastRun, "dd")#>
<cfset theMonth = #DateFormat(getDateLastRun.LastRun, "mm")#>
<cfset theYear = #DateFormat(getDateLastRun.LastRun, "yyyy")#>
<cfset startDate = #DateFormat(createdate(theYear,theMonth,1),"mm/dd/yyyy")# > <!---  first of current month --->
<cfset startDateLastYear = #DateFormat(createdate(theYear-1,theMonth,1),"mm/dd/yyyy")# >
<cfset today = #DateFormat(createdate(theYear,theMonth,theDay),"mm/dd/yyyy")# > <!---  first of current month --->
<cfset todayLastYear = #DateFormat(createdate(theYear-1,theMonth,theDay),"mm/dd/yyyy")# >
<cfset startDate2YearsAgo = #DateFormat(createdate(theYear-2,theMonth,1),"mm/dd/yyyy")# > 
<cfset today2YearsAgo = #DateFormat(createdate(theYear-2,theMonth,theDay),"mm/dd/yyyy")# >
<cfparam name="form.submit" default="">
<!--- Set initial selected and blocked-out dates. --->
<cfparam name="Form.startdate" default="#dateformat(startDate, 'mm/dd/yyyy')#"> 
<cfparam name="Form.enddate" default="#dateformat(today, 'mm/dd/yyyy')#"> 
<cfparam name="Form.txtSalesperson" default=""> 
<cfparam name="Form.Customer" default="">
<cfparam name="Form.txtCustomerClass" default="">

<cfset customerclass = #Form.txtCustomerClass#>

<cfform name="myForm" action="" method="post" >

<table width="527" align="center"  cellpadding="3" cellspacing="0">
    <tr>
		<td valign="left">Start Date:</td>
		<td valign="left"><cfinput type="dateField" name="startDate" id="startDate" size="10" width="10" value="#Form.startdate#"></td>
		<td valign="left">End Date:</td>
		<td valign="left"><cfinput type="dateField" name="endDate" id="endDate" size="10"  width="10" value="#Form.enddate#"></td>
	</tr>
	<tr>
		<td valign="left">Salesperson:</td>		
		<td>
		<CFSELECT NAME="txtSalesperson" MESSAGE="Select an Salesperson Name" SIZE="1" multiple="no">
		<OPTION value="" selected="true">Select All</option>
		<cfloop query="#getSalespeople#">
			<OPTION value="<cfoutput>#getSalespeople.salesperson#</cfoutput>"<cfif txtSalesperson eq #getSalespeople.salesperson#>selected</cfif>><cfoutput>#getSalespeople.salesperson#</cfoutput> - <cfoutput>#getSalespeople.Name#</cfoutput></option>
		</cfloop>
		</CFSELECT>
		</td>
		<td>Customer: &nbsp;</td>
		<td><input type="text" name="customer" value="<cfoutput>#form.customer#</cfoutput>">&nbsp;</td>
		<!---<cfinput type="text"  name="txtSalesperson" id="txtSalesperson" size="5"  width="10" value="#Form.txtSalesperson#">--->
	</tr>
	<tr>
		<td valign="left">Customer Class:</td>
		<td>
		<CFSELECT NAME="txtCustomerClass" MESSAGE="Select an Customer Class" SIZE="1" multiple="no">
		<OPTION value="" <cfif customerclass eq "">selected</cfif>>Select All</option>
		<OPTION value="10" <cfif customerclass eq "10">selected</cfif>>10 - Mom and Pop - 25 doors or less</option>
		<OPTION value="11"<cfif customerclass eq "11">selected</cfif>>11 - Catalog</option>
		<OPTION value="12"<cfif customerclass eq "12">selected</cfif>>12 - Web</option>
		<OPTION value="13"<cfif customerclass eq "13">selected</cfif>>13 - International</option>
		<OPTION value="14"<cfif customerclass eq "14">selected</cfif>>14 - Custom Manufacturing</option>
		<OPTION value="15"<cfif customerclass eq "15">selected</cfif>>15 - Rep Group</option>
		<OPTION value="16"<cfif customerclass eq "16">selected</cfif>>16 - Franchise</option>
		<OPTION value="17"<cfif customerclass eq "17">selected</cfif>>17 - International Distributor</option>
		<OPTION value="18"<cfif customerclass eq "18">selected</cfif>>18 - Fundraiser</option>
		<OPTION value="20"<cfif customerclass eq "20">selected</cfif>>20 - International</option>
		<OPTION value="30"<cfif customerclass eq "30">selected</cfif>>30 - Liquidation</option>
		<OPTION value="40"<cfif customerclass eq "40">selected</cfif>>40 - Rep Samples and Showrooms</option>
		<OPTION value="50"<cfif customerclass eq "50">selected</cfif>>50 - Wholesale Website Only Account</option>
		<OPTION value="60"<cfif customerclass eq "60">selected</cfif>>60 - Shopify - NL Retail</option>
		<OPTION value="61"<cfif customerclass eq "61">selected</cfif>>61 - NLC Gift Shop</option>
		<OPTION value="70"<cfif customerclass eq "70">selected</cfif>>70 - Large Accounts</option>
		<OPTION value="80"<cfif customerclass eq "80">selected</cfif>>80 - Contract Manufacuring</option>
		<OPTION value="90"<cfif customerclass eq "90">selected</cfif>>90 - Off price</option>
		<OPTION value="L1"<cfif customerclass eq "L1">selected</cfif>>L1 - Gift or Department - Large</option>
		<OPTION value="L2"<cfif customerclass eq "L2">selected</cfif>>L2 - Pharmacy - Large</option>
		<!--- <cfloop query="#getSalespeople#">
			<OPTION value="<cfoutput>#getSalespeople.salesperson#</cfoutput>"<cfif txtSalesperson eq #getSalespeople.salesperson#>selected</cfif>><cfoutput>#getSalespeople.salesperson#</cfoutput> - <cfoutput>#getSalespeople.Name#</cfoutput></option>
		</cfloop> --->
		</CFSELECT>
		</td>
	</tr>
	<tr>
		<td align="right" colspan="2"><input name="submit" type="submit" value="Run Report"></td><br>
		<td align="center" colspan="2"><input type="submit" name="toExcelbtn" value="Download as Excel File"></td>		
	</tr>
</table>
</cfform>
<p align="center">This Report Updated : <cfoutput>#dateTimeFormat(getDateLastRun.LastRun,"mm-dd-yyyy hh:nn tt")#</cfoutput></p>
<cfif isdefined("Form.submit")>
	<cfif #DateFormat(Form.startdate,"mm/dd")# eq "02/29">
		<cfset form.startdate = DateAdd("d", -1, form.startdate)>
	</cfif>	
	<cfif #DateFormat(Form.enddate,"mm/dd")# eq "02/29">
		<cfset form.enddate = DateAdd("d", -1, form.enddate)>
	</cfif>	  
	<cfset theDay = #DateFormat(Form.enddate,"dd")# >
    <cfset theMonth = #DateFormat(Form.enddate,"mm")# >
	<cfset theYear = #DateFormat(Form.enddate,"yyyy")# >
	<cfset startDate = #DateFormat(Form.startdate,"mm/dd/yyyy")# > <!---  first of chosen month --->
	<cfset today = #DateFormat(Form.endDate,"mm/dd/yyyy")# >
	<cfset startDateLastYear = #DateFormat(createdate(Year(startDate)-1,Month(startDate),Day(startDate)),"mm/dd/yyyy")# >
	<cfset todayLastYear = #DateFormat(createdate(theYear-1,theMonth,theDay),"mm/dd/yyyy")# >
	<cfset startDate2YearsAgo = #DateFormat(createdate(Year(startDate)-2,Month(startDate),Day(startDate)),"mm/dd/yyyy")# > 
	<cfset today2YearsAgo = #DateFormat(createdate(theYear-2,theMonth,theDay),"mm/dd/yyyy")# >
	<cfset salesperson = #Form.txtSalesperson#>
	<cfset customer = #Form.customer#>
	<cfset customerclass = #Form.txtCustomerClass#>
	
</cfif>
<cfset MonthlyTotalThisYear = 0>
<cfset MonthlyTotalLastYear = 0>
<cfset MonthlyTotal2YearsAgo = 0>
<div id="buttonsAndInfo" align="center">
<p align="center"><strong><font size="+1">Click Below to View Each Individual Order Included</font></strong></p>
<p>
<input id="button1" type="button" value="show/hide - <cfoutput>#startDate# to #today#</cfoutput>" onclick="document.getElementById('button1').focus(); toggle();">
<input id="button2" type="button" value="show/hide - <cfoutput>#startDateLastYear# to #todayLastYear#</cfoutput>" onclick="toggle2();">
<input id="button3" type="button" value="show/hide - <cfoutput>#startDate2YearsAgo# to #today2YearsAgo#</cfoutput>" onclick="toggle3();">
</p>
<!--- outputs the table for booked all  --->
<div id="newpost" align="center">
<p align="center"><strong>Booked Orders All from <cfoutput>#startdate# to #today#</cfoutput></strong></p>

<!--- QUERIES (MP QUERIES) --->
<cfquery name="tblAllBookedOrders" datasource="RetailWebOrdersDB">
SELECT *
FROM tblAllBookedOrders
WHERE OrderDate >= <cfoutput>#createodbcdate(startDate)#</cfoutput> And OrderDate <= <cfoutput>#createodbcdate(today)#</cfoutput> <cfif isdefined("Form.submit")><cfif salesperson neq ""> AND salesperson = '<cfoutput>#salesperson#</cfoutput>'</cfif><cfif Form.customer neq ""> AND customer = '<cfoutput>#Form.customer#</cfoutput>'</cfif><cfif Form.txtCustomerClass neq ""> AND CustomerClass = '<cfoutput>#Form.txtCustomerClass#</cfoutput>'</cfif></cfif>
ORDER BY OrderDate ASC
</cfquery>

<cfquery name="tblAllBookedOrdersTotals" datasource="RetailWebOrdersDB">
SELECT YEAR(OrderDate) AS thisYear, Month(OrderDate) As thisMonth, Day(OrderDate) As thisDay, Sum(price) As TotalDailyPrice, Count(OrderDate) AS numOrders
FROM tblAllBookedOrders
WHERE OrderDate >= <cfoutput>#createdate(Year(startdate),Month(startdate),Day(startdate))#</cfoutput> AND OrderDate <= <cfoutput>#createdate(Year(today),Month(today),day(today))#</cfoutput> <cfif isdefined("Form.submit")><cfif salesperson neq ""> AND salesperson = '<cfoutput>#salesperson#</cfoutput>'</cfif><cfif Form.customer neq ""> AND customer = '<cfoutput>#Form.customer#</cfoutput>'</cfif><cfif Form.txtCustomerClass neq ""> AND CustomerClass = '<cfoutput>#Form.txtCustomerClass#</cfoutput>'</cfif></cfif>
Group By OrderDate
Order By OrderDate ASC
</cfquery>

<table id="BookedOrdersAllTable" border="1"  align="center"  cellpadding="3" cellspacing="0">
	<tr>
		<td>Customer</td>
		<td>Date Added</td>
		<td>Customer Class</td>
		<td>Last Order Date</td>
		<td>Name</td>
		<td>Number of Orders</td>
		<td>Order Date</td>
		<td>Price</td>
		<td>Cost</td>
		<td>SalesOrder</td>
		<td>Salesperson</td>
		<td>Ship Postal Code</td>
		<td>Street Address</td>
		<td>City</td>
		<td>State</td>
	</tr>
<cfset thisYearIndex = 1>
<cfset thisYearTotal = 0>
<cfset thisYearTotalCost = 0>
<cfset thisYearCount = 0>
<cfset thisYearNumOrders = 0>
<cfloop query="#tblAllBookedOrders#">
	
	<tr>
		<td><cfoutput>#tblAllBookedOrders.customer#</cfoutput> &nbsp;</td>
		<td><cfoutput>#DateFormat(tblAllBookedOrders.datecustadded)#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrders.CustomerClass#</cfoutput> &nbsp;</td>
		<td><cfoutput>#DateFormat(tblAllBookedOrders.lastorderdate)#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrders.name#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrders.numorders#</cfoutput> &nbsp;</td>
		<td><cfoutput>#DateFormat(tblAllBookedOrders.orderdate)#</cfoutput> &nbsp;</td>
		<td><cfoutput>#DollarFormat(tblAllBookedOrders.price)#</cfoutput> &nbsp;</td>
		<td><cfoutput>#DollarFormat(tblAllBookedOrders.totalcost)#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrders.salesorder#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrders.salesperson#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrders.shippostalcode#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrders.shiptoaddr1#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrders.shiptoaddr3#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrders.state#</cfoutput> &nbsp;</td>	
	</tr>
	<cfset thisYearNumOrders = #thisYearNumOrders# + #tblAllBookedOrders.numorders#>
	<cfset thisYearTotal = #thisYearTotal# + #tblAllBookedOrders.Price#>
	<cfif tblAllBookedOrders.totalcost neq "">
		<cfset thisYearTotalCost = #thisYearTotalCost# + #tblAllBookedOrders.totalcost#>
	</cfif>	
	<cfset thisYearIndex = #thisYearIndex# + 1>
</cfloop>
<!--- add totals row --->
	<tr>
		<td><strong>Totals:</strong></td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td><strong><cfoutput>#thisYearNumOrders#</cfoutput></strong> &nbsp;</td>
		<td>&nbsp; </td>
		<td><strong><cfoutput>#DollarFormat(thisYearTotal)#</cfoutput></strong> &nbsp;</td>
		<td><strong><cfoutput>#DollarFormat(thisYearTotalCost)#</cfoutput></strong> &nbsp;</td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>		
	</tr>
	<tr>
		<td>
			<input type="button" value="show/hide - <cfoutput>#startDate# to #today#</cfoutput>" onclick="document.getElementById('button1').focus(); toggle();">
		</td>
	</tr>
</table>
</div>
<!--- end outputing the table for booked all  --->


<!--- outputs the table for booked all  --->
<div id="newpost2"  align="center">
<!--- LAST YEAR  --->
<p  align="center"><strong>Booked Orders All from <cfoutput>#startdateLastYear# to #todayLastYear#</cfoutput></strong></p>
<!--- QUERIES (MP QUERIES) --->
<cfquery name="tblAllBookedOrdersLastYear" datasource="RetailWebOrdersDB">
SELECT *
FROM tblAllBookedOrders
WHERE OrderDate >= <cfoutput>#createodbcdate(startdateLastYear)#</cfoutput> And OrderDate <= <cfoutput>#createodbcdate(todayLastYear)#</cfoutput> <cfif isdefined("Form.submit")><cfif salesperson neq ""> AND salesperson = '#salesperson#'</cfif><cfif Form.customer neq ""> AND customer = '<cfoutput>#Form.customer#</cfoutput>'</cfif><cfif Form.txtCustomerClass neq ""> AND CustomerClass = '<cfoutput>#Form.txtCustomerClass#</cfoutput>'</cfif></cfif>
ORDER BY OrderDate ASC
</cfquery>
<cfquery name="tblAllBookedOrdersTotalsLastYear" datasource="RetailWebOrdersDB">
SELECT YEAR(OrderDate) AS thisYear, Month(OrderDate) As thisMonth, Day(OrderDate) As thisDay, Sum(price) As TotalDailyPrice, Count(*) AS numOrders
FROM tblAllBookedOrders
WHERE OrderDate >= <cfoutput>#createdate(Year(startdateLastYear),Month(startdateLastYear),Day(startdateLastYear))#</cfoutput> AND OrderDate <= <cfoutput>#createdate(Year(todayLastYear),Month(todayLastYear),day(todayLastYear))#</cfoutput> <cfif isdefined("Form.submit")><cfif salesperson neq ""> AND salesperson = '<cfoutput>#salesperson#</cfoutput>'</cfif><cfif Form.customer neq ""> AND customer = '<cfoutput>#Form.customer#</cfoutput>'</cfif><cfif Form.txtCustomerClass neq ""> AND CustomerClass = '<cfoutput>#Form.txtCustomerClass#</cfoutput>'</cfif></cfif>
Group By OrderDate
Order By OrderDate ASC
</cfquery>

<table id="BookedOrdersAllTable" border="1" align="center"  cellpadding="3" cellspacing="0">
	<tr>
		<td>Customer</td>
		<td>Date Added</td>
		<td>Customer Class</td>
		<td>Last Order Date</td>
		<td>Name</td>
		<td>Number of Orders</td>
		<td>Order Date</td>
		<td>Price</td>
		<td>Cost</td>
		<td>SalesOrder</td>
		<td>Salesperson</td>
		<td>Ship Postal Code</td>
		<td>Street Address</td>
		<td>City</td>
		<td>State</td>
	</tr>
<cfset lastYearIndex = 1>
<cfset lastYearTotal = 0>
<cfset lastYearTotalCost = 0>
<cfset lastYearCount = 0>
<cfset lastYearNumOrders = 0>
<cfloop query="#tblAllBookedOrdersLastYear#">

	<tr>
		<td><cfoutput>#tblAllBookedOrdersLastYear.customer#</cfoutput> &nbsp;</td>
		<td><cfoutput>#DateFormat(tblAllBookedOrdersLastYear.datecustadded)#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrdersLastYear.CustomerClass#</cfoutput></td>
		<td><cfoutput>#DateFormat(tblAllBookedOrdersLastYear.lastorderdate)#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrdersLastYear.name#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrdersLastYear.numorders#</cfoutput> &nbsp;</td>
		<td><cfoutput>#DateFormat(tblAllBookedOrdersLastYear.orderdate)#</cfoutput> &nbsp;</td>
		<td><cfoutput>#DollarFormat(tblAllBookedOrdersLastYear.price)#</cfoutput> &nbsp;</td>
		<td><cfoutput>#DollarFormat(tblAllBookedOrdersLastYear.totalcost)#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrdersLastYear.salesorder#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrdersLastYear.salesperson#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrdersLastYear.shippostalcode#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrdersLastYear.shiptoaddr1#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrdersLastYear.shiptoaddr3#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrdersLastYear.state#</cfoutput> &nbsp;</td>	
	</tr>
	<cfset lastYearNumOrders = #lastYearNumOrders# + #tblAllBookedOrdersLastYear.numorders#>
	<cfset lastYearTotal = #lastYearTotal# + #tblAllBookedOrdersLastYear.Price#>
	<cfif tblAllBookedOrdersLastYear.totalcost neq "">
		<cfset lastYearTotalCost = #lastYearTotalCost# + #tblAllBookedOrdersLastYear.totalcost#>
	</cfif>
	<cfset lastYearIndex = #lastYearIndex# + 1>
</cfloop>
	<tr>
		<td><strong>Totals:</strong></td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td><strong><cfoutput>#lastYearNumOrders#</cfoutput></strong> &nbsp;</td>
		<td>&nbsp; </td>
		<td><strong><cfoutput>#DollarFormat(lastYearTotal)#</cfoutput></strong> &nbsp;</td>
		<td><strong><cfoutput>#DollarFormat(lastYearTotalCost)#</cfoutput></strong> &nbsp;</td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>	
	</tr>
	<tr>
		<td><input type="button" value="show/hide - <cfoutput>#startDateLastYear# to #todayLastYear#</cfoutput>" onclick="document.getElementById('button2').focus(); toggle2();"></td>
	</tr>
</table>
</div>
<!--- End Last Year  --->

<!--- outputs the table for booked all  --->
<div id="newpost3" align="center">
<!--- 2 YEARS AGO --->
<p align="center"><strong>Booked Orders All from <cfoutput>#startdate2YearsAgo# to #today2YearsAgo#</cfoutput></strong></p>
<!--- QUERIES (MP QUERIES) --->
<cfquery name="tblAllBookedOrders2YearsAgo" datasource="RetailWebOrdersDB">
	SELECT *
	FROM tblAllBookedOrders
	WHERE OrderDate >= #createodbcdate(startdate2YearsAgo)# And OrderDate <= #createodbcdate(today2YearsAGo)# <cfif isdefined("Form.submit")><cfif salesperson neq ""> AND salesperson = '#salesperson#'</cfif><cfif Form.customer neq ""> AND customer = '<cfoutput>#Form.customer#</cfoutput>'</cfif><cfif Form.txtCustomerClass neq ""> AND CustomerClass = '<cfoutput>#Form.txtCustomerClass#</cfoutput>'</cfif></cfif>
	ORDER BY OrderDate ASC
</cfquery>
<cfquery name="tblAllBookedOrdersTotals2YearsAgo" datasource="RetailWebOrdersDB">
	SELECT YEAR(OrderDate) AS thisYear, Month(OrderDate) As thisMonth, Day(OrderDate) As thisDay, Sum(price) As TotalDailyPrice, Count(*) AS numOrders
	FROM tblAllBookedOrders
	WHERE OrderDate >= #createdate(Year(startdate2YearsAgo),Month(startdate2YearsAgo),Day(startdate2YearsAgo))# AND OrderDate <= #createdate(Year(today2YearsAgo),Month(today2YearsAgo),day(today2YearsAgo))# <cfif isdefined("Form.submit")><cfif salesperson neq ""> AND salesperson = '<cfoutput>#salesperson#</cfoutput>'</cfif><cfif Form.customer neq ""> AND customer = '<cfoutput>#Form.customer#</cfoutput>'</cfif><cfif Form.txtCustomerClass neq ""> AND CustomerClass = '<cfoutput>#Form.txtCustomerClass#</cfoutput>'</cfif></cfif>
	Group By OrderDate
	Order By OrderDate ASC
</cfquery>


<table id="BookedOrdersAllTable" border="1" align="center"  cellpadding="3" cellspacing="0">
	<tr>
		<td>Customer</td>
		<td>Date Added</td>
		<td>Customer Class</td>
		<td>Last Order Date</td>
		<td>Name</td>
		<td>Number of Orders</td>
		<td>Order Date</td>
		<td>Price</td>
		<td>Cost</td>
		<td>SalesOrder</td>
		<td>Salesperson</td>
		<td>Ship Postal Code</td>
		<td>Street Address</td>
		<td>City</td>
		<td>State</td>
	</tr>
<cfset Index2YearsAgo = 1>
<cfset Total2YearsAgo = 0>
<cfset TotalCost2YearsAgo = 0>
<cfset Count2YearsAgo = 0>
<cfset NumOrders2YearsAgo = 0>
<cfloop query="#tblAllBookedOrders2YearsAgo#">
	
	<tr>
		<td><cfoutput>#tblAllBookedOrders2YearsAgo.customer#</cfoutput> &nbsp;</td>
		<td><cfoutput>#DateFormat(tblAllBookedOrders2YearsAgo.datecustadded)#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrders2YearsAgo.CustomerClass#</cfoutput></td>
		<td><cfoutput>#DateFormat(tblAllBookedOrders2YearsAgo.lastorderdate)#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrders2YearsAgo.name#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrders2YearsAgo.numorders#</cfoutput> &nbsp;</td>
		<td><cfoutput>#DateFormat(tblAllBookedOrders2YearsAgo.orderdate)#</cfoutput> &nbsp;</td>
		<td><cfoutput>#DollarFormat(tblAllBookedOrders2YearsAgo.price)#</cfoutput> &nbsp;</td>
		<td><cfoutput>#DollarFormat(tblAllBookedOrders2YearsAgo.totalcost)#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrders2YearsAgo.salesorder#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrders2YearsAgo.salesperson#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrders2YearsAgo.shippostalcode#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrders2YearsAgo.shiptoaddr1#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrders2YearsAgo.shiptoaddr3#</cfoutput> &nbsp;</td>
		<td><cfoutput>#tblAllBookedOrders2YearsAgo.state#</cfoutput> &nbsp;</td>	
	</tr>
	<cfset NumOrders2YearsAgo = #NumOrders2YearsAgo# + #tblAllBookedOrders2YearsAgo.numorders#>
	<cfset Total2YearsAgo = #Total2YearsAgo# + #tblAllBookedOrders2YearsAgo.Price#>
	<cfif tblAllBookedOrders2YearsAgo.totalcost neq "">
		<cfset TotalCost2YearsAgo = #TotalCost2YearsAgo# + #tblAllBookedOrders2YearsAgo.totalcost#>
	</cfif>
	<cfset Index2YearsAgo = #Index2YearsAgo# + 1>	
</cfloop>
	<tr>
		<td><strong>Totals:</strong></td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td><strong><cfoutput>#NumOrders2YearsAgo#</cfoutput></strong> &nbsp;</td>
		<td>&nbsp; </td>
		<td><strong><cfoutput>#DollarFormat(Total2YearsAgo)#</cfoutput></strong> &nbsp;</td>
		<td><strong><cfoutput>#DollarFormat(TotalCost2YearsAgo)#</cfoutput></strong> &nbsp;</td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>
		<td>&nbsp; </td>	
	</tr>
	<tr>
		<td><input type="button" value="show/hide - <cfoutput>#startDate2YearsAgo# to #today2YearsAgo#</cfoutput>" onclick="document.getElementById('button3').focus(); toggle3();"></td>
	</tr>
</table>
</div>
</div>
<!--- end 2 Years Ago  --->
<p align="center"><strong><font size="+1">Booked Orders for <cfoutput>#today#</cfoutput></font></strong></p>
<cfset lastIndex = 1>
<cfset runningTotal = 0.0>
<cfset runningTotalLastYear = 0.0>
<cfset numWorkDays= 0>
<cfset runningTotal2YearsAgo = 0.0>
<cfset numWorkDaysToChart = 0>
<p align="center">
<cfchart chartheight="600" chartwidth="800" format="png" backgroundColor="white" xAxisTitle="Number Of Work Days" yAxisTitle="Running Total Price (in Dollars)" font="Arial" showXGridlines="yes" showYGridlines="yes" showborder="yes" showlegend="yes">  
	<cfset numWorkDaysToChart = #numWorkDaysToChart#>
	<cfchartseries type="line" seriesColor="black"  paintStyle="plain" seriesLabel="#year(startDate)#">
		<cfset runningTotal = 0.0>
		<cfset numWorkDays= 0>
		<cfloop query="#tblAllBookedOrdersTotals#">
			<cfchartdata item="#numWorkDays#" value="#runningTotal#">
			<cfset runningTotal = #runningTotal# + #tblAllBookedOrdersTotals.TotalDailyPrice#>
			<cfset numWorkDays= #numWorkDays# + 1>
			<cfset numWorkDaysToChart = #numWorkDays#>		
		</cfloop>
		<cfchartdata item="#numWorkDays#" value="#runningTotal#"><!--- this should be the point with final values --->	
	</cfchartseries>	
	<cfchartseries type="line" seriesColor="red"  paintStyle="plain" seriesLabel="#year(startDateLastYear)#">
		<cfset runningTotal = 0.0>
		<cfset numWorkDays= 0>
		<cfloop query="#tblAllBookedOrdersTotalsLastYear#">
			<cfchartdata item="#numWorkDays#" value="#runningTotal#">
			<cfset runningTotal = #runningTotal# + #tblAllBookedOrdersTotalsLastYear.TotalDailyPrice#>
			<cfset numWorkDays= #numWorkDays# + 1>		
		</cfloop>
		<cfchartdata item="#numWorkDays#" value="#runningTotal#"><!--- this should be the point with final values --->	
	</cfchartseries>	
	<cfchartseries type="line" seriesColor="blue"  paintStyle="plain" seriesLabel="#year(startDate2YearsAgo)#">
		<cfset runningTotal = 0.0>
		<cfset numWorkDays= 0>
		<cfloop query="#tblAllBookedOrdersTotals2YearsAgo#">
			<cfchartdata item="#numWorkDays#" value="#runningTotal#">
			<cfset runningTotal = #runningTotal# + #tblAllBookedOrdersTotals2YearsAgo.TotalDailyPrice#>
			<cfset numWorkDays= #numWorkDays# + 1>		
		</cfloop>
		<cfchartdata item="#numWorkDays#" value="#runningTotal#"><!--- this should be the point with final values --->	
	</cfchartseries>	
</cfchart>
</p>
<!--- END Chart Stuff --->

 <!---  downloads the table to excel on button click --->
<cfif isdefined("Form.toExcelbtn") and Form.toExcelbtn eq "Download as Excel File">
	<cfheader name="Content-Disposition" value="filename=dailyreportAll-#today#.xls">
	<cfcontent type="application/msexcel">				
</cfif>

<p align="center">This Report Updated : <cfoutput>#dateTimeFormat(getDateLastRun.LastRun,"mm-dd-yyyy hh:nn tt")#</cfoutput></p>

<table border="1" align="center">
	<tr>
		<td colspan="2"><strong><font size="+1"><cfoutput>#startDate# to #today#</cfoutput> Totals</font></strong></td>			
	</tr>
	<tr>
		<td><cfoutput>#theYear#</cfoutput></td>
		<td><strong>				
					<cfoutput>#DollarFormat(thisYearTotal)#</cfoutput>		
			</strong>
		</td>
	</tr>
	<tr>
		<td><cfoutput>#theYear-1#</cfoutput></td>
		<td><strong>
					<cfoutput>#DollarFormat(lastYearTotal)#</cfoutput>
			</strong>
		</td>
	</tr>
	<tr>	
		<td><cfoutput>#theYear-2#</cfoutput></td>
		<td><strong>
					<cfoutput>#DollarFormat(Total2YearsAgo)#</cfoutput>
			</strong>
		</td>
	</tr>	
</table>

<!---  display the table for this year --->
<p align="center">
<table id="tablesHolderTable" align="center"  cellspacing="5">
<tr> 
<td valign="top">
	<table border="1" align="center"  cellpadding="1" cellspacing="0">
		<tr>
			<td colspan="5"><strong><font size="+1"><cfoutput>#startDate# to #today#</cfoutput></font></strong></td>
		</tr>
		<tr> 
			<td><strong>Date</strong></td>
			<td><strong>Amount</strong></td>
			<td><strong>Num Orders</strong></td>
			<td><strong>Avg</strong></td>
			<td><strong><cfoutput>#year(startDate)#</cfoutput> Running Total</strong></td>
		</tr>		
		<cfset runningTotal = 0>
		<cfset totalNumOrders = 0>
		<cfset loopIndex = 1>	
		<cfloop query="#tblAllBookedOrdersTotals#">
		<cfset totalNumOrders = #totalNumOrders# + #numorders#>
		<tr>
			<td><cfoutput>#tblAllBookedOrdersTotals.thisMonth#/#tblAllBookedOrdersTotals.thisDay#/#tblAllBookedOrdersTotals.thisYear#</cfoutput></td>
			<td><cfoutput>#DollarFormat(tblAllBookedOrdersTotals.TotalDailyPrice)#</cfoutput></td>
			<td><cfoutput>#numorders#</cfoutput></td>
			<cfif numorders neq 0>
				<td><cfoutput>#dollarformat(tblAllBookedOrdersTotals.TotalDailyPrice / numorders)#</cfoutput></td>
			<cfelse>
				<td><cfoutput>#dollarformat(0)#</cfoutput></td>
			</cfif>
			<cfset runningTotal = #runningTotal# + #tblAllBookedOrdersTotals.TotalDailyPrice#>
			<td><cfoutput>#DollarFormat(runningTotal)#</cfoutput></td>
			<cfset loopIndex = #loopIndex# + 1>
		</tr>	
		</cfloop>	
		<!--- add row for the totals  --->
		<tr>
		<td><strong>Totals:</strong></td>
		<td><strong><cfoutput>#DollarFormat(runningTotal)#</cfoutput></strong></td>
		<td><strong><cfoutput>#totalNumOrders#</cfoutput></strong></td>
		<cfif totalNumOrders neq 0>
			<td><strong><cfoutput>#DollarFormat(runningTotal / totalNumOrders)#</cfoutput></strong></td>
		<cfelse>
			<td><strong><cfoutput>#DollarFormat(0)#</cfoutput></strong></td>
		</cfif>
		<td>&nbsp; </td>
		</tr>		
	</table>
</td>		
<!---  display the table for LAST YEAR  --->	
 <td valign="top">	
	<table border="1"  align="center"  cellpadding="1" cellspacing="0">
		<tr>
		<td colspan="5"><strong><font size="+1"><cfoutput>#startDateLastYear# to #todayLastYear#</cfoutput></font></strong></td>
		</tr>
		<tr> 
			<td><strong>Date</strong></td>
			<td><strong>Amount</strong></td>
			<td><strong>Num Orders</strong></td>
			<td><strong>Avg</strong></td>
			<td><strong><cfoutput>#year(startDateLastYear)#</cfoutput> Running Total</strong></td>
		</tr>	
		<cfset runningTotalLastYear = 0>
		<cfset totalNumOrdersLastYear = 0>
		<cfset loopIndexLastYear = 1>	
		<cfloop query="#tblAllBookedOrdersTotalsLastYear#">
		<cfset totalNumOrdersLastYear = #totalNumOrdersLastYear# + #tblAllBookedOrdersTotalsLastYear.numorders#>
		<tr>
			<td><cfoutput>#tblAllBookedOrdersTotalsLastYear.thisMonth#/#tblAllBookedOrdersTotalsLastYear.thisDay#/#tblAllBookedOrdersTotalsLastYear.thisYear#</cfoutput></td>
			<td><cfoutput>#DollarFormat(tblAllBookedOrdersTotalsLastYear.TotalDailyPrice)#</cfoutput></td>
			<td><cfoutput>#tblAllBookedOrdersTotalsLastYear.numorders#</cfoutput></td>
			<cfif tblAllBookedOrdersTotalsLastYear.numorders neq 0>
				<td><cfoutput>#dollarformat(tblAllBookedOrdersTotalsLastYear.TotalDailyPrice / tblAllBookedOrdersTotalsLastYear.numorders)#</cfoutput></td>
			<cfelse>
				<td><cfoutput>#dollarformat(0)#</cfoutput></td>
			</cfif>
			<cfset runningTotalLastYear = #runningTotalLastYear# + #tblAllBookedOrdersTotalsLastYear.TotalDailyPrice#>
			<td><cfoutput>#DollarFormat(runningTotalLastYear)#</cfoutput></td>
			<cfset loopIndexLastYear = #loopIndexLastYear# + 1>
		</tr>	
		</cfloop>		
		<!--- add row for the totals  --->
		<tr>
		<td><strong>Totals:</strong></td>
		<td><strong><cfoutput>#DollarFormat(runningTotalLastYear)#</cfoutput></strong></td>
		<td><strong><cfoutput>#totalNumOrdersLastYear#</cfoutput></strong></td>
		<cfif totalNumOrdersLastYear neq 0>
			<td><strong><cfoutput>#DollarFormat(runningTotalLastYear / totalNumOrdersLastYear)#</cfoutput></strong></td>
		<cfelse>
			<td><strong><cfoutput>#DollarFormat(0)#</cfoutput></strong></td>
		</cfif>
		<td>&nbsp; </td>
		</tr>		
	</table>
</td>
<!---  display the table for 2 YEARS AGO  --->
<td valign="top">			
	<table border="1" align="center" cellpadding="1" cellspacing="0">
		<tr>
		<td colspan="5"><strong><font size="+1"><cfoutput>#startDate2YearsAgo# to #today2YearsAgo#</cfoutput></font></strong></td>
		</tr>
		<tr> 
			<td><strong>Date</strong></td>
			<td><strong>Amount</strong></td>
			<td><strong>Num Orders</strong></td>
			<td><strong>Avg</strong></td>
			<td><strong><cfoutput>#year(startDate2YearsAgo)#</cfoutput> Running Total</strong></td>
		</tr>		
		<cfset runningTotal2YearsAgo = 0>
		<cfset totalNumOrders2YearsAgo = 0>
		<cfset loopIndex2YearsAgo = 1>	
		<cfloop query="#tblAllBookedOrdersTotals2YearsAgo#" >
		<cfset totalNumOrders2YearsAgo = #totalNumOrders2YearsAgo# + #tblAllBookedOrdersTotals2YearsAgo.numorders#>
		<tr>
			<td><cfoutput>#tblAllBookedOrdersTotals2YearsAgo.thisMonth#/#tblAllBookedOrdersTotals2YearsAgo.thisDay#/#tblAllBookedOrdersTotals2YearsAgo.thisYear#</cfoutput></td>
			<td><cfoutput>#DollarFormat(tblAllBookedOrdersTotals2YearsAgo.TotalDailyPrice)#</cfoutput></td>
			<td><cfoutput>#tblAllBookedOrdersTotals2YearsAgo.numorders#</cfoutput></td>
			<cfif tblAllBookedOrdersTotals2YearsAgo.numorders neq 0>
				<td><cfoutput>#dollarformat(tblAllBookedOrdersTotals2YearsAgo.TotalDailyPrice / tblAllBookedOrdersTotals2YearsAgo.numorders)#</cfoutput></td>
			<cfelse>
				<td><cfoutput>#dollarformat(0)#</cfoutput></td>
			</cfif>
			<cfset runningTotal2YearsAgo = #runningTotal2YearsAgo# + #tblAllBookedOrdersTotals2YearsAgo.TotalDailyPrice#>
			<td><cfoutput>#DollarFormat(runningTotal2YearsAgo)#</cfoutput></td>
			<cfset loopIndex2YearsAgo = #loopIndex2YearsAgo# + 1>
		</tr>	
		</cfloop>		
		<!--- add row for the totals  --->
		<tr>
		<td><strong>Totals:</strong></td>
		<td><strong><cfoutput>#DollarFormat(runningTotal2YearsAgo)#</cfoutput></strong></td>
		<td><strong><cfoutput>#totalNumOrders2YearsAgo#</cfoutput></strong></td>
		<cfif totalNumOrders2YearsAgo neq 0>
			<td><strong><cfoutput>#DollarFormat(runningTotal2YearsAgo / totalNumOrders2YearsAgo)#</cfoutput></strong></td>
		<cfelse>
			<td><strong><cfoutput>#DollarFormat(0)#</cfoutput></strong></td>
		</cfif>
		<td>&nbsp; </td>
		</tr>		
	</table>
</td>
</tr>
</table>		

</p>
</body>
</html>
<cfcatch type="any"><cfdump var="#cfcatch#"></cfcatch>
</cftry>




   