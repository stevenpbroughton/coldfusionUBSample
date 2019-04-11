<cftry>
<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Daily Report - Daily Shipment Log (All)</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link rel="stylesheet" href="ReportCSS.css">
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
</head>
<body onLoad="toggle();toggle2();toggle3();" align="center" class="PageText">
<br><h2 align="center"><strong>Daily Shipment Log (All)</strong></h2>
<p align="center">
<a href="/index.cfm">Report Menu</a> |
<a href="/Daily-Reports-Daily_Shipment_log.cfm">Daily Shipment Log (All)</a> |
<a href="/Daily-Reports-Daily_Shipment_Log_Large.cfm">Daily Shipment Log (Large)</a> |
<a href="/Daily-Reports-Daily_Shipment_Log_MP.cfm">Daily Shipment Log (Mom-and-Pop)</a> |
<a href="/Daily-Reports-Daily_Shipment_Log_Rep.cfm">Daily Shipment Log (Rep)</a> |
<a href="/Daily-Reports-Daily_Shipment_Log_Retail.cfm">Daily Shipment Log (Retail)</a>
</p>
<p align="center"> <strong>**NOTE: In order for all the data to be valid the StartDate MUST be no earlier than 01/01/2016!</strong></p>
<cfquery name="getDateLastRun" datasource="RetailWebOrdersDB">
	SELECT * 
	FROM tblLastRun
</cfquery>
<!--- old query
<cfquery name="getSalesPeople" datasource="RetailWebOrdersDB">
	SELECT DISTINCT tblTotalDailyInvoiceAmt.salesperson, dbo_SALSALESPERSON.Name
	FROM tblTotalDailyInvoiceAmt
	Left Join dbo_SALSALESPERSON ON tblTotalDailyInvoiceAmt.salesperson = dbo_SALSALESPERSON.salesperson
</cfquery>
 --->
 
<!--- same as above query but uses tblInvoiceAmtNoShip tbl  --->
<cfquery name="getSalesPeople" datasource="RetailWebOrdersDB">
	SELECT DISTINCT tblInvoiceAmtNoShip.salesperson, dbo_SALSALESPERSON.Name
	FROM tblInvoiceAmtNoShip
	Left Join dbo_SALSALESPERSON ON tblInvoiceAmtNoShip.salesperson = dbo_SALSALESPERSON.salesperson
</cfquery>



<!---set variables --->
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

		<td align="center" colspan="5"><input name="submit" type="submit" value="Run Report"></td><br>		
	</tr>
</table>
</cfform>
<p align="center">This Report Updated : <cfoutput>#dateTimeFormat(getDateLastRun.LastRun,"mm-dd-yyyy hh:nn tt")#</cfoutput> </p>
<cfif isdefined("Form.submit")>
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
	<cfset customerclass = #Form.txtCustomerClass#>
</cfif>

<!--- include buttons to show/hide individual shipments --->
<!--- include individual shipments in tables here (invoice amount no ship query) --->
<div id="buttonsAndInfo" align="center">
	<p align="center"><strong><font size="+1">Click Below to View Each Individual Order Included</font></strong></p>
	<input id="button1" type="button" value="show/hide - <cfoutput>#startDate# to #today#</cfoutput>" onclick="document.getElementById('button1').focus(); toggle();">
	<input id="button2" type="button" value="show/hide - <cfoutput>#startdateLastYear# to #todayLastYear#</cfoutput>" onclick="document.getElementById('button2').focus(); toggle2();">
	<input id="button3" type="button" value="show/hide - <cfoutput>#startdate2YearsAgo# to #today2YearsAgo#</cfoutput>" onclick="document.getElementById('button3').focus(); toggle3();">
	<!--- outputs the table for booked all  --->
	<div id="newpost" align="center">
		<p align="center"><strong>Shipped Invoices All from <cfoutput>#startdate# to #today#</cfoutput> <cfif salesperson neq ""><cfoutput> for salesperson #salesperson#</cfoutput></cfif></strong></p>
		<cfquery name="getAllShippedInvoices" datasource="RetailWebOrdersDB">
		Select *
		FROM tblInvoiceAmtNoShip
		WHERE Invoicedate >= <cfoutput>#createdate(Year(startdate),Month(startdate),Day(startdate))#</cfoutput> AND InvoiceDate <= <cfoutput>#createdate(Year(today),Month(today),day(today))#</cfoutput> <cfif isdefined("Form.submit")><cfif salesperson neq ""> AND salesperson = '<cfoutput>#salesperson#</cfoutput>'</cfif><cfif Form.customer neq ""> AND customer = '<cfoutput>#Form.customer#</cfoutput>'</cfif><cfif Form.txtCustomerClass neq ""> AND CustomerClass = '<cfoutput>#Form.txtCustomerClass#</cfoutput>'</cfif></cfif>
		</cfquery>
		<!--- <cfdump var="#getAllShippedInvoices#"> --->
		<table border="1"  align="center"  cellpadding="3" cellspacing="0">
			<tr>
				<td><strong>Invoice</strong></td>
				<td><strong>Customer Number</strong></td>
				<td><strong>Customer</strong></td>
				<td><strong>Customer Class</strong></td>
				<td><strong>Invoice Date</strong></td>
				<td><strong>$ Amount</strong></td>
				<td><strong>$ Cost</strong></td>
				<td><strong>Salesperson</strong></td>
			</tr>
			<cfset TotalOfAll = 0>
			<cfset TotalCostOfAll = 0>
			<cfloop query="#getAllShippedInvoices#">
			<cfset TotalOfAll = #TotalOfAll# + #getAllShippedInvoices.INVOICEAMTNOSHP#>
			<cfset TotalCostOfAll = #TotalCostOfAll# + #getAllShippedInvoices.invoicecostamt#>
			<tr>
				<td><cfoutput>#getAllShippedInvoices.invoice#</cfoutput></td>
				<td><cfoutput>#getAllShippedInvoices.customer#</cfoutput></td>
				<td><cfoutput>#getAllShippedInvoices.name#</cfoutput></td>
				<td><cfoutput>#getAllShippedInvoices.CustomerClass#</cfoutput></td>
				<td><cfoutput>#dateformat(getAllShippedInvoices.invoicedate,"mm/dd/yyyy")#</cfoutput></td>
				<td><cfoutput>#dollarformat(getAllShippedInvoices.INVOICEAMTNOSHP)#</cfoutput></td>
				<td><cfoutput>#dollarformat(getAllShippedInvoices.invoicecostamt)#</cfoutput></td>
				<td><cfoutput>#getAllShippedInvoices.salesperson#</cfoutput></td>
			</tr>
			</cfloop>
			<tr>
				<td><strong>Totals:</strong></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td><strong><cfoutput>#dollarformat(TotalOfAll)#</cfoutput></strong></td>
				<td><strong><cfoutput>#dollarformat(TotalCostOfAll)#</cfoutput></strong></td>
				<td>&nbsp;</td>
			</tr>
		</table>
	</div> <!--- end newpost div (this year invoices) --->
	
	
	<!--- outputs the table for booked all  --->
	<div id="newpost2" align="center">
		<p align="center"><strong>Shipped Invoices All from <cfoutput>#startdateLastYear# to #todayLastYear#</cfoutput> <cfif salesperson neq ""><cfoutput> for salesperson #salesperson#</cfoutput></cfif></strong></p>
		<cfquery name="getAllShippedInvoicesLastYear" datasource="RetailWebOrdersDB">
		Select *
		FROM tblInvoiceAmtNoShip
		WHERE Invoicedate >= <cfoutput>#createdate(Year(startdateLastYear),Month(startdateLastYear),Day(startdateLastYear))#</cfoutput> AND InvoiceDate <= <cfoutput>#createdate(Year(todayLastYear),Month(todayLastYear),day(todayLastYear))#</cfoutput> <cfif isdefined("Form.submit")><cfif salesperson neq ""> AND salesperson = '<cfoutput>#salesperson#</cfoutput>'</cfif><cfif Form.customer neq ""> AND customer = '<cfoutput>#Form.customer#</cfoutput>'</cfif><cfif Form.txtCustomerClass neq ""> AND CustomerClass = '<cfoutput>#Form.txtCustomerClass#</cfoutput>'</cfif></cfif>
		</cfquery>
		<!--- <cfdump var="#getAllShippedInvoicesLastYear#"> --->
		<table border="1"  align="center"  cellpadding="3" cellspacing="0">
			<tr>
				<td><strong>Invoice</strong></td>
				<td><strong>Customer Number</strong></td>
				<td><strong>Customer</strong></td>
				<td><strong>Customer Class</strong></td>
				<td><strong>Invoice Date</strong></td>
				<td><strong>$ Amount</strong></td>
				<td><strong>$ Cost</strong></td>
				<td><strong>Salesperson</strong></td>
			</tr>
			<cfset TotalOfAllLastYear = 0>
			<cfset TotalCostOfAllLastYear = 0>
			<cfloop query="#getAllShippedInvoicesLastYear#">
			<cfset TotalOfAllLastYear = #TotalOfAllLastYear# + #getAllShippedInvoicesLastYear.INVOICEAMTNOSHP#>
			<cfset TotalCostOfAllLastYear = #TotalCostOfAllLastYear# + #getAllShippedInvoicesLastYear.invoicecostamt#>
			<tr>
				<td><cfoutput>#getAllShippedInvoicesLastYear.invoice#</cfoutput></td>
				<td><cfoutput>#getAllShippedInvoicesLastYear.customer#</cfoutput></td>
				<td><cfoutput>#getAllShippedInvoicesLastYear.name#</cfoutput></td>
				<td><cfoutput>#getAllShippedInvoicesLastYear.CustomerClass#</cfoutput></td>
				<td><cfoutput>#dateformat(getAllShippedInvoicesLastYear.invoicedate,"mm/dd/yyyy")#</cfoutput></td>
				<td><cfoutput>#dollarformat(getAllShippedInvoicesLastYear.INVOICEAMTNOSHP)#</cfoutput></td>
				<td><cfoutput>#dollarformat(getAllShippedInvoicesLastYear.invoicecostamt)#</cfoutput></td>
				<td><cfoutput>#getAllShippedInvoicesLastYear.salesperson#</cfoutput></td>
			</tr>
			</cfloop>
			<tr>
				<td><strong>Totals:</strong></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td><strong><cfoutput>#dollarformat(TotalOfAllLastYear)#</cfoutput></strong></td>
				<td><strong><cfoutput>#dollarformat(TotalCostOfAllLastYear)#</cfoutput></strong></td>
				<td>&nbsp;</td>
			</tr>
			
		</table>
	</div> <!--- end newpost2 div (last year invoices)  --->
	
	
	<!--- outputs the table for booked all  --->
	<div id="newpost3" align="center">
		<p align="center"><strong>Shipped Invoices All from <cfoutput>#startdate2YearsAgo# to #today2YearsAgo#</cfoutput> <cfif salesperson neq ""><cfoutput> for salesperson #salesperson#</cfoutput></cfif></strong></p>
		<cfquery name="getAllShippedInvoices2YearsAgo" datasource="RetailWebOrdersDB">
		Select *
		FROM tblInvoiceAmtNoShip
		WHERE Invoicedate >= <cfoutput>#createdate(Year(startdate2YearsAgo),Month(startdate2YearsAgo),Day(startdate2YearsAgo))#</cfoutput> AND InvoiceDate <= <cfoutput>#createdate(Year(today2YearsAgo),Month(today2YearsAgo),day(today2YearsAgo))#</cfoutput> <cfif isdefined("Form.submit")><cfif salesperson neq ""> AND salesperson = '<cfoutput>#salesperson#</cfoutput>'</cfif><cfif Form.customer neq ""> AND customer = '<cfoutput>#Form.customer#</cfoutput>'</cfif><cfif Form.txtCustomerClass neq ""> AND CustomerClass = '<cfoutput>#Form.txtCustomerClass#</cfoutput>'</cfif></cfif>
		</cfquery>
		<!--- <cfdump var="#getAllShippedInvoices2YearsAgo#"> --->
		<table border="1"  align="center"  cellpadding="3" cellspacing="0">
			<tr>
				<td><strong>Invoice</strong></td>
				<td><strong>Customer Number</strong></td>
				<td><strong>Customer</strong></td>
				<td><strong>Customer Class</strong></td>
				<td><strong>Invoice Date</strong></td>
				<td><strong>$ Amount</strong></td>
				<td><strong>$ Cost</strong></td>
				<td><strong>Salesperson</strong></td>
			</tr>
			<cfset TotalOfAll2YearsAgo = 0>
			<cfset TotalCostOfAll2YearsAgo = 0>
			<cfloop query="#getAllShippedInvoices2YearsAgo#">
			<cfset TotalOfAll2YearsAgo = #TotalOfAll2YearsAgo# + #getAllShippedInvoices2YearsAgo.INVOICEAMTNOSHP#>
			<cfset TotalCostOfAll2YearsAgo = #TotalCostOfAll2YearsAgo# + #getAllShippedInvoices2YearsAgo.invoicecostamt#>
			<tr>
				<td><cfoutput>#getAllShippedInvoices2YearsAgo.invoice#</cfoutput></td>
				<td><cfoutput>#getAllShippedInvoices2YearsAgo.customer#</cfoutput></td>
				<td><cfoutput>#getAllShippedInvoices2YearsAgo.name#</cfoutput></td>
				<td><cfoutput>#getAllShippedInvoices2YearsAgo.CustomerClass#</cfoutput></td>
				<td><cfoutput>#dateformat(getAllShippedInvoices2YearsAgo.invoicedate,"mm/dd/yyyy")#</cfoutput></td>
				<td><cfoutput>#dollarformat(getAllShippedInvoices2YearsAgo.INVOICEAMTNOSHP)#</cfoutput></td>
				<td><cfoutput>#dollarformat(getAllShippedInvoices2YearsAgo.invoicecostamt)#</cfoutput></td>
				<td><cfoutput>#getAllShippedInvoices2YearsAgo.salesperson#</cfoutput></td>
			</tr>
			</cfloop>
			<tr>
				<td><strong>Totals:</strong></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td><strong><cfoutput>#dollarformat(TotalOfAll2YearsAgo)#</cfoutput></strong></td>
				<td><strong><cfoutput>#dollarformat(TotalCostOfAll2YearsAgo)#</cfoutput></strong></td>
				<td>&nbsp;</td>
			</tr>
		</table>
	</div> <!--- end newpost2 div (2 years ago invoices)  --->
</div>

<cfset MonthlyTotalThisYear = 0>
<cfset MonthlyTotalLastYear = 0>
<cfset MonthlyTotal2YearsAgo = 0>

<!--- QUERIES (MP QUERIES) --->
<!--- 
<cfquery name="getTotalDailyInvoiceAmtOld" datasource="RetailWebOrdersDB">
SELECT *
FROM tblTotalDailyInvoiceAmt
WHERE Invoicedate >= <cfoutput>#createdate(Year(startdate),Month(startdate),Day(startdate))#</cfoutput> AND InvoiceDate <= <cfoutput>#createdate(Year(today),Month(today),day(today))#</cfoutput> <cfif isdefined("Form.submit")><cfif salesperson neq ""> AND salesperson = '<cfoutput>#salesperson#</cfoutput>'</cfif><cfif Form.customer neq ""> AND customer = '<cfoutput>#Form.customer#</cfoutput>'</cfif></cfif>
</cfquery>
<cfdump var="#getTotalDailyInvoiceAmtOld#"> --->

<cfquery name="getTotalDailyInvoiceAmt" datasource="RetailWebOrdersDB">
SELECT tblInvoiceAmtNoShip.InvoiceDate, Count(tblInvoiceAmtNoShip.Invoice) AS TotalInvoice, Sum(tblInvoiceAmtNoShip.InvoiceAmtNoShp) AS TotalAmt, Sum(tblInvoiceAmtNoShip.InvoiceCostAmt) AS TotalCost <cfif isdefined("Form.submit")><cfif salesperson neq "">,tblInvoiceAmtNoShip.Salesperson</cfif><cfif Form.customer neq "">, tblInvoiceAmtNoShip.customer</cfif></cfif>
FROM tblInvoiceAmtNoShip
WHERE Invoicedate >= <cfoutput>#createdate(Year(startdate),Month(startdate),Day(startdate))#</cfoutput> AND InvoiceDate <= <cfoutput>#createdate(Year(today),Month(today),day(today))#</cfoutput> <cfif isdefined("Form.submit")><cfif salesperson neq ""> AND salesperson = '<cfoutput>#salesperson#</cfoutput>'</cfif><cfif Form.customer neq ""> AND customer = '<cfoutput>#Form.customer#</cfoutput>'</cfif><cfif Form.txtCustomerClass neq ""> AND CustomerClass = '<cfoutput>#Form.txtCustomerClass#</cfoutput>'</cfif></cfif>
GROUP BY tblInvoiceAmtNoShip.InvoiceDate <cfif isdefined("Form.submit")><cfif salesperson neq "">,tblInvoiceAmtNoShip.Salesperson</cfif><cfif Form.customer neq "">, tblInvoiceAmtNoShip.customer</cfif></cfif>
HAVING (((tblInvoiceAmtNoShip.InvoiceDate)>=#1/1/2014# And (tblInvoiceAmtNoShip.InvoiceDate)<>#2/29/2016#));
</cfquery>

<!--- 
<cfquery name="getTotalDailyInvoiceAmtLastYearOld" datasource="RetailWebOrdersDB">
SELECT *
FROM tblTotalDailyInvoiceAmt
WHERE Invoicedate >= <cfoutput>#createdate(Year(startdateLastYear),Month(startdateLastYear),Day(startdateLastYear))#</cfoutput> AND InvoiceDate <= <cfoutput>#createdate(Year(todayLastYear),Month(todayLastYear),day(todayLastYear))#</cfoutput> <cfif isdefined("Form.submit")><cfif salesperson neq ""> AND salesperson = '<cfoutput>#salesperson#</cfoutput>'</cfif><cfif Form.customer neq ""> AND customer = '<cfoutput>#Form.customer#</cfoutput>'</cfif></cfif>
</cfquery>
 --->
 
<cfquery name="getTotalDailyInvoiceAmtLastYear" datasource="RetailWebOrdersDB">
SELECT tblInvoiceAmtNoShip.InvoiceDate, Count(tblInvoiceAmtNoShip.Invoice) AS TotalInvoice, Sum(tblInvoiceAmtNoShip.InvoiceAmtNoShp) AS TotalAmt, Sum(tblInvoiceAmtNoShip.InvoiceCostAmt) AS TotalCost <cfif isdefined("Form.submit")><cfif salesperson neq "">,tblInvoiceAmtNoShip.Salesperson</cfif><cfif Form.customer neq "">, tblInvoiceAmtNoShip.customer</cfif></cfif>
FROM tblInvoiceAmtNoShip
WHERE Invoicedate >= <cfoutput>#createdate(Year(startdateLastYear),Month(startdateLastYear),Day(startdateLastYear))#</cfoutput> AND InvoiceDate <= <cfoutput>#createdate(Year(todayLastYear),Month(todayLastYear),day(todayLastYear))#</cfoutput> <cfif isdefined("Form.submit")><cfif salesperson neq ""> AND salesperson = '<cfoutput>#salesperson#</cfoutput>'</cfif><cfif Form.customer neq ""> AND customer = '<cfoutput>#Form.customer#</cfoutput>'</cfif><cfif Form.txtCustomerClass neq ""> AND CustomerClass = '<cfoutput>#Form.txtCustomerClass#</cfoutput>'</cfif></cfif>
GROUP BY tblInvoiceAmtNoShip.InvoiceDate <cfif isdefined("Form.submit")><cfif salesperson neq "">,tblInvoiceAmtNoShip.Salesperson</cfif><cfif Form.customer neq "">, tblInvoiceAmtNoShip.customer</cfif></cfif>
HAVING (((tblInvoiceAmtNoShip.InvoiceDate)>=#1/1/2014# And (tblInvoiceAmtNoShip.InvoiceDate)<>#2/29/2016#));
</cfquery>

<!--- 
<cfquery name="getTotalDailyInvoiceAmt2YearsAgoOld" datasource="RetailWebOrdersDB">
SELECT *
FROM tblTotalDailyInvoiceAmt
WHERE Invoicedate >= <cfoutput>#createdate(Year(startdate2YearsAgo),Month(startdate2YearsAgo),Day(startdate2YearsAgo))#</cfoutput> AND InvoiceDate <= <cfoutput>#createdate(Year(today2YearsAgo),Month(today2YearsAgo),day(today2YearsAgo))#</cfoutput> <cfif isdefined("Form.submit")><cfif salesperson neq ""> AND salesperson = '<cfoutput>#salesperson#</cfoutput>'</cfif><cfif Form.customer neq ""> AND customer = '<cfoutput>#Form.customer#</cfoutput>'</cfif></cfif>
</cfquery>
 --->
<cfquery name="getTotalDailyInvoiceAmt2YearsAgo" datasource="RetailWebOrdersDB">
SELECT tblInvoiceAmtNoShip.InvoiceDate, Count(tblInvoiceAmtNoShip.Invoice) AS TotalInvoice, Sum(tblInvoiceAmtNoShip.InvoiceAmtNoShp) AS TotalAmt, Sum(tblInvoiceAmtNoShip.InvoiceCostAmt) AS TotalCost <cfif isdefined("Form.submit")><cfif salesperson neq "">,tblInvoiceAmtNoShip.Salesperson</cfif><cfif Form.customer neq "">, tblInvoiceAmtNoShip.customer</cfif></cfif>
FROM tblInvoiceAmtNoShip
WHERE Invoicedate >= <cfoutput>#createdate(Year(startdate2YearsAgo),Month(startdate2YearsAgo),Day(startdate2YearsAgo))#</cfoutput> AND InvoiceDate <= <cfoutput>#createdate(Year(today2YearsAgo),Month(today2YearsAgo),day(today2YearsAgo))#</cfoutput> <cfif isdefined("Form.submit")><cfif salesperson neq ""> AND salesperson = '<cfoutput>#salesperson#</cfoutput>'</cfif><cfif Form.customer neq ""> AND customer = '<cfoutput>#Form.customer#</cfoutput>'</cfif><cfif Form.txtCustomerClass neq ""> AND CustomerClass = '<cfoutput>#Form.txtCustomerClass#</cfoutput>'</cfif></cfif>
GROUP BY tblInvoiceAmtNoShip.InvoiceDate <cfif isdefined("Form.submit")><cfif salesperson neq "">,tblInvoiceAmtNoShip.Salesperson</cfif><cfif Form.customer neq "">, tblInvoiceAmtNoShip.customer</cfif></cfif>
HAVING (((tblInvoiceAmtNoShip.InvoiceDate)>=#1/1/2014# And (tblInvoiceAmtNoShip.InvoiceDate)<>#2/29/2016#));
</cfquery>

<p align="center"><strong><font size="+2">Daily Shipment Log from <cfoutput>#startdate# to #today#</cfoutput></font></strong></p>
<!--- chart --->
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
		<cfloop query="#getTotalDailyInvoiceAmt#">
			<cfchartdata item="#numWorkDays#" value="#runningTotal#">
			<cfset runningTotal = #runningTotal# + #getTotalDailyInvoiceAmt.totalamt#>
			<cfset numWorkDays= #numWorkDays# + 1>
			<cfset numWorkDaysToChart = #numWorkDays#>		
		</cfloop>
		<cfchartdata item="#numWorkDays#" value="#runningTotal#"><!--- this should be the point with final values --->	
	</cfchartseries>	
	<cfchartseries type="line" seriesColor="red"  paintStyle="plain" seriesLabel="#year(startDateLastYear)#">
		<cfset runningTotal = 0.0>
		<cfset numWorkDays= 0>
		<cfloop query="#getTotalDailyInvoiceAmtLastYear#">
			<cfchartdata item="#numWorkDays#" value="#runningTotal#">
			<cfset runningTotal = #runningTotal# + #getTotalDailyInvoiceAmtLastYear.totalamt#>
			<cfset numWorkDays= #numWorkDays# + 1>
			<cfset numWorkDaysToChart = #numWorkDays#>		
		</cfloop>
		<cfchartdata item="#numWorkDays#" value="#runningTotal#"><!--- this should be the point with final values --->	
	</cfchartseries>	
	<cfchartseries type="line" seriesColor="orange"  paintStyle="plain" seriesLabel="#year(startDate2YearsAgo)#">
		<cfset runningTotal = 0.0>
		<cfset numWorkDays= 0>
		<cfloop query="#getTotalDailyInvoiceAmt2YearsAgo#">
			<cfchartdata item="#numWorkDays#" value="#runningTotal#">
			<cfset runningTotal = #runningTotal# + #getTotalDailyInvoiceAmt2YearsAgo.totalamt#>
			<cfset numWorkDays= #numWorkDays# + 1>
			<cfset numWorkDaysToChart = #numWorkDays#>		
		</cfloop>
		<cfchartdata item="#numWorkDays#" value="#runningTotal#"><!--- this should be the point with final values --->	
	</cfchartseries>
</cfchart>
</p>
<!--- END Chart Stuff --->
<!---  button to download data as excel file --->
<br>
<br>
<p align="center">
<form name="myForm" action="Daily-Reports-Daily_Shipment_log.cfm" method="post">
	<input type="submit" name="toExcelbtn" value="Download as Excel File">
</form>
</p>
 <!---  downloads the table to excel on button click --->
<cfif isdefined("Form.toExcelbtn")>
	<cfheader name="Content-Disposition" value="filename=dailyreportShipmentLog-#today#.xls">
	<cfcontent type="application/msexcel">				
</cfif>
<p align="center"><strong>Daily Shipment Log (All)</strong></p>
<p align="center">This Report Updated : <cfoutput>#dateTimeFormat(getDateLastRun.LastRun,"mm-dd-yyyy hh:nn tt")#</cfoutput> </p>
<p>
<table align="center">
	<tr>
		<td valign="top">
		<cfset TotalDailyInvoiceAmtArray=arraynew(2)>	
		<table id="BookedOrdersAllTable" border="1" align="top" cellpadding="3" cellspacing="0">
			<tr>
				<td colspan="7"><strong><cfoutput>#startdate# to #today#</cfoutput></strong></td>
			</tr>
			<tr>
				<td><strong>Date</strong></td>
				<td><strong>Num Ship</strong></td>
				<td><strong>Total $ Amount</strong></td>
				<td><strong>Avg $ per Ship.</strong></td>
				<td><strong>Total $ Cost</strong></td>
				<td><strong>Gross Margin $</strong></td>
				<td><strong>Gross Margin %</strong></td>		
			</tr>		
			<cfset thisYearIndex = 1>
			<cfset thisYearTotal = 0>
			<cfset numShipments = 0>
			<cfset totalCostTotal = 0>
			<cfset grossMarginValueTotal = 0>
			<cfset grossMarginTotalPercent = 0>
			<cfset totalAverageDollarAmount = 0>
			<cfset sumOfAvgDollarAmts = 0>
			<cfloop query="#getTotalDailyInvoiceAmt#">
				<cfset TotalDailyInvoiceAmtArray[thisYearIndex][1]=#getTotalDailyInvoiceAmt.invoicedate#> 
				<cfset TotalDailyInvoiceAmtArray[thisYearIndex][2]=#getTotalDailyInvoiceAmt.totalamt#> 
				<cfset TotalDailyInvoiceAmtArray[thisYearIndex][3]=#getTotalDailyInvoiceAmt.totalcost#> 
				<cfset TotalDailyInvoiceAmtArray[thisYearIndex][4]=#getTotalDailyInvoiceAmt.totalinvoice#> 
			<tr>
				<td><cfoutput>#DateFormat(getTotalDailyInvoiceAmt.invoicedate)#</cfoutput></td>
				<td><cfoutput>#getTotalDailyInvoiceAmt.totalinvoice#</cfoutput></td>
				<td><cfoutput>#DollarFormat(getTotalDailyInvoiceAmt.totalamt)#</cfoutput></td>
				<td><cfoutput>#DollarFormat(getTotalDailyInvoiceAmt.totalamt / getTotalDailyInvoiceAmt.totalinvoice)#</cfoutput></td>
				<td><cfoutput>#DollarFormat(getTotalDailyInvoiceAmt.totalcost)#</cfoutput></td>
				<td><cfoutput>#DollarFormat(getTotalDailyInvoiceAmt.totalamt - getTotalDailyInvoiceAmt.totalcost)#</cfoutput></td>
				<td><cfoutput>#numberformat((((getTotalDailyInvoiceAmt.totalamt - getTotalDailyInvoiceAmt.totalcost) / getTotalDailyInvoiceAmt.totalamt)*100),"99.99")#</cfoutput></td>
			</tr>		
				<cfset thisYearTotal = #thisYearTotal# + #getTotalDailyInvoiceAmt.totalamt#>
				<cfset numShipments = #numShipments# + #getTotalDailyInvoiceAmt.totalinvoice#>
				<cfset totalCostTotal = #totalCostTotal# + #getTotalDailyInvoiceAmt.totalcost#>	
				<cfset grossMarginValueTotal = #grossMarginValueTotal# + (#getTotalDailyInvoiceAmt.totalamt# - #getTotalDailyInvoiceAmt.totalcost#)>	
				<cfset grossMarginTotalPercent = #grossMarginValueTotal# / #thisYearTotal# * 100>
				<cfset totalAverageDollarAmount = val(#thisYearTotal# / #numShipments#)>
				<cfset thisYearIndex = #thisYearIndex# + 1>
			</cfloop>
		<!--- add totals row --->	
			<tr>
				<td><strong>Totals:</strong></td>
				<td><strong><cfoutput>#numShipments#</cfoutput></strong></td>
				<td><strong><cfoutput>#DollarFormat(thisYearTotal)#</cfoutput></strong></td>
				<td><strong><cfoutput>#DollarFormat(totalAverageDollarAmount)#</cfoutput></strong></td>
				<td><strong><cfoutput>#DollarFormat(totalCostTotal)#</cfoutput></strong></td>
				<td><strong><cfoutput>#DollarFormat(grossMarginValueTotal)#</cfoutput></strong></td>
				<td><strong><cfoutput>#numberformat((grossMarginTotalPercent),"99.99")#</cfoutput></strong></td>		
			</tr>	
		</table>	
	</td>
	<td valign="top">	
		<cfset TotalDailyInvoiceAmtArrayLastYear=arraynew(2)>
		<table id="BookedOrdersAllTable2" border="1" align="top" cellpadding="3" cellspacing="0">
			<tr>
				<td colspan="7"><strong><cfoutput>#startdateLastYear#</cfoutput> to <cfoutput>#todayLastYear#</cfoutput></strong></td></tr>
			<tr>
				<td><strong>Date</strong></td>
				<td><strong>Num Ship.</strong></td>
				<td><strong>Total $ Amount</strong></td>
				<td><strong>Avg $ per Ship.</strong></td>
				<td><strong>Total $ Cost</strong></td>
				<td><strong>Gross Margin $</strong></td>
				<td><strong>Gross Margin %</strong></td>	
			</tr>		
			<cfset lastYearIndex = 1>
			<cfset lastYearTotal = 0>
			<cfset numShipmentsLastYear = 0>
			<cfset totalCostTotalLastYear = 0>
			<cfset grossMarginValueTotalLastYear = 0>
			<cfset grossMarginTotalPercentLastYear = 0>
			<cfset totalAverageDollarAmountLastYear = 0>
			<cfloop query="#getTotalDailyInvoiceAmtLastYear#">
				<cfset TotalDailyInvoiceAmtArrayLastYear[lastYearIndex][1]=#getTotalDailyInvoiceAmtLastYear.invoicedate#> 
				<cfset TotalDailyInvoiceAmtArrayLastYear[lastYearIndex][2]=#getTotalDailyInvoiceAmtLastYear.totalamt#> 
				<cfset TotalDailyInvoiceAmtArrayLastYear[lastYearIndex][3]=#getTotalDailyInvoiceAmtLastYear.totalcost#> 
				<cfset TotalDailyInvoiceAmtArrayLastYear[lastYearIndex][4]=#getTotalDailyInvoiceAmtLastYear.totalinvoice#> 
			<tr>
				<td><cfoutput>#DateFormat(getTotalDailyInvoiceAmtLastYear.invoicedate)#</cfoutput></td>
				<td><cfoutput>#getTotalDailyInvoiceAmtLastYear.totalinvoice#</cfoutput></td>
				<td><cfoutput>#DollarFormat(getTotalDailyInvoiceAmtLastYear.totalamt)#</cfoutput></td>
				<td><cfoutput>#DollarFormat(getTotalDailyInvoiceAmtLastYear.totalamt / getTotalDailyInvoiceAmtLastYear.totalinvoice)#</cfoutput></td>
				<td><cfoutput>#DollarFormat(getTotalDailyInvoiceAmtLastYear.totalcost)#</cfoutput></td>
				<td><cfoutput>#DollarFormat(getTotalDailyInvoiceAmtLastYear.totalamt - getTotalDailyInvoiceAmtLastYear.totalcost)#</cfoutput></td>
				<td><cfoutput>#numberformat((((getTotalDailyInvoiceAmtLastYear.totalamt - getTotalDailyInvoiceAmtLastYear.totalcost) / getTotalDailyInvoiceAmtLastYear.totalamt)*100),"99.99")#</cfoutput></td>
			</tr>	
			<cfset lastYearTotal = #lastYearTotal# + #getTotalDailyInvoiceAmtLastYear.totalamt#>
			<cfset numShipmentsLastYear = #numShipmentsLastYear# + #getTotalDailyInvoiceAmtLastYear.totalinvoice#>
			<cfset totalCostTotalLastYear = #totalCostTotalLastYear# + #getTotalDailyInvoiceAmtLastYear.totalcost#>	
			<cfset grossMarginValueTotalLastYear = #grossMarginValueTotalLastYear# + (#getTotalDailyInvoiceAmtLastYear.totalamt# - #getTotalDailyInvoiceAmtLastYear.totalcost#)>	
			<cfset grossMarginTotalPercentLastYear = #grossMarginValueTotalLastYear# / #lastYearTotal# * 100>
			<cfset totalAverageDollarAmountLastYear = val(#lastYearTotal# / #numShipmentsLastYear#)>	
			<cfset lastYearIndex = #lastYearIndex# + 1>
		</cfloop>
		<!--- add totals row --->
			<tr>
				<td><strong>Totals:</strong></td>
				<td><strong><cfoutput>#numShipmentsLastYear#</cfoutput></strong></td>
				<td><strong><cfoutput>#DollarFormat(lastYearTotal)#</cfoutput></strong></td>
				<td><strong><cfoutput>#DollarFormat(totalAverageDollarAmountLastYear)#</cfoutput></strong></td>
				<td><strong><cfoutput>#DollarFormat(totalCostTotalLastYear)#</cfoutput></strong></td>
				<td><strong><cfoutput>#DollarFormat(grossMarginValueTotalLastYear)#</cfoutput></strong></td>
				<td><strong><cfoutput>#numberformat(grossMarginTotalPercentLastYear,"99.99")#</cfoutput></strong></td>	
			</tr>
		</table>
	</td>
	<td valign="top">	
			<!--- 2 years ago table --->	
			<cfset TotalDailyInvoiceAmtArray2YearsAgo=arraynew(2)>
			<table id="BookedOrdersAllTable3" border="1" align="top" cellpadding="3" cellspacing="0">
				<tr>
					<td colspan="7"><strong><cfoutput>#startdate2YearsAgo#</cfoutput> to <cfoutput>#today2YearsAgo#</cfoutput></strong></td>
				</tr>
				<tr>
					<td><strong>Date</strong></td>
					<td><strong>Num Ship.</strong></td>
					<td><strong>Total $ Amount</strong></td>
					<td><strong>Avg $ per Ship.</strong></td>
					<td><strong>Total $ Cost</strong></td>
					<td><strong>Gross Margin $</strong></td>
					<td><strong>Gross Margin %</strong></td>	
				</tr>		
			<cfset YearIndex2YearsAgo = 1>
			<cfset YearTotal2YearsAgo = 0>
			<cfset numShipments2YearsAgo = 0>
			<cfset totalCostTotal2YearsAgo = 0>
			<cfset grossMarginValueTotal2YearsAgo = 0>
			<cfset grossMarginTotalPercent2YearsAgo = 0>
			<cfset totalAverageDollarAmount2YearsAgo = 0>
			<cfloop query="#getTotalDailyInvoiceAmt2YearsAgo#">
				<cfset TotalDailyInvoiceAmtArray2YearsAgo[YearIndex2YearsAgo][1]=#getTotalDailyInvoiceAmt2YearsAgo.invoicedate#> 
				<cfset TotalDailyInvoiceAmtArray2YearsAgo[YearIndex2YearsAgo][2]=#getTotalDailyInvoiceAmt2YearsAgo.totalamt#> 
				<cfset TotalDailyInvoiceAmtArray2YearsAgo[YearIndex2YearsAgo][3]=#getTotalDailyInvoiceAmt2YearsAgo.totalcost#> 
				<cfset TotalDailyInvoiceAmtArray2YearsAgo[YearIndex2YearsAgo][4]=#getTotalDailyInvoiceAmt2YearsAgo.totalinvoice#> 
				<tr>
					<td><cfoutput>#DateFormat(getTotalDailyInvoiceAmt2YearsAgo.invoicedate)#</cfoutput></td>
					<td><cfoutput>#getTotalDailyInvoiceAmt2YearsAgo.totalinvoice#</cfoutput></td>
					<td><cfoutput>#DollarFormat(getTotalDailyInvoiceAmt2YearsAgo.totalamt)#</cfoutput></td>
					<td><cfoutput>#DollarFormat(getTotalDailyInvoiceAmt2YearsAgo.totalamt / getTotalDailyInvoiceAmt2YearsAgo.totalinvoice)#</cfoutput></td>
					<td><cfoutput>#DollarFormat(getTotalDailyInvoiceAmt2YearsAgo.totalcost)#</cfoutput></td>
					<td><cfoutput>#DollarFormat(getTotalDailyInvoiceAmt2YearsAgo.totalamt - getTotalDailyInvoiceAmt2YearsAgo.totalcost)#</cfoutput></td>
					<td><cfoutput>#numberformat(((getTotalDailyInvoiceAmt2YearsAgo.totalamt - getTotalDailyInvoiceAmt2YearsAgo.totalcost) / (getTotalDailyInvoiceAmt2YearsAgo.totalamt)*100),"99.99")#</cfoutput></td>
				</tr>		
				<cfset YearTotal2YearsAgo = #YearTotal2YearsAgo# + #getTotalDailyInvoiceAmt2YearsAgo.totalamt#>
				<cfset numShipments2YearsAgo = #numShipments2YearsAgo# + #getTotalDailyInvoiceAmt2YearsAgo.totalinvoice#>
				<cfset totalCostTotal2YearsAgo = #totalCostTotal2YearsAgo# + #getTotalDailyInvoiceAmt2YearsAgo.totalcost#>	
				<cfset grossMarginValueTotal2YearsAgo = #grossMarginValueTotal2YearsAgo# + (#getTotalDailyInvoiceAmt2YearsAgo.totalamt# - #getTotalDailyInvoiceAmt2YearsAgo.totalcost#)>	
				<cfset grossMarginTotalPercent2YearsAgo = #grossMarginValueTotal2YearsAgo# / #YearTotal2YearsAgo# * 100>
				<cfset totalAverageDollarAmount2YearsAgo = val(#YearTotal2YearsAgo# / #numShipments2YearsAgo#)>	
				<cfset YearIndex2YearsAgo = #YearIndex2YearsAgo# + 1>
			</cfloop>
			<!--- add totals row --->
				<tr>
					<td><strong>Totals:</strong></td>
					<td><strong><cfoutput>#numShipments2YearsAgo#</cfoutput></strong></td>
					<td><strong><cfoutput>#DollarFormat(YearTotal2YearsAgo)#</cfoutput></strong></td>
					<td><strong><cfoutput>#DollarFormat(totalAverageDollarAmount2YearsAgo)#</cfoutput></strong></td>
					<td><strong><cfoutput>#DollarFormat(totalCostTotal2YearsAgo)#</cfoutput></strong></td>
					<td><strong><cfoutput>#DollarFormat(grossMarginValueTotal2YearsAgo)#</cfoutput></strong></td>
					<td><strong><cfoutput>#numberformat(grossMarginTotalPercent2YearsAgo, "99.99")#</cfoutput></strong></td>
				</tr>	
			</table>		
		</td>
	</tr>
</table>
	<br>
	<table border="1" align="center">
		<tr>
			<td colspan="7" align="center"><strong><font size="+1">Totals - <cfoutput>#MonthAsString(Month(startDate))#</cfoutput> <cfoutput>#Day(startDate)#</cfoutput> to <cfoutput>#MonthAsString(Month(today))#</cfoutput> <cfoutput>#Day(today)#</cfoutput></font></strong></td>	
		</tr>
		<tr>
			<td><strong>Year</strong></td>
			<td><strong>Num Shipments</strong></td>
			<td><strong>Total $ Amount</strong></td>
			<td><strong>Avg $ Per Ship</strong></td>
			<td><strong>Total $ Cost</strong></td>
			<td><strong>Gross Margin $</strong></td>
			<td><strong>Gross Margin %</strong></td>
		</tr>
		<tr>
			<td><strong><cfoutput>#theYear#</cfoutput></strong></td>
			<td><cfoutput>#numShipments#</cfoutput></td>
			<td><cfoutput>#DollarFormat(thisYearTotal)#</cfoutput></td>
			<td><cfoutput>#DollarFormat(totalAverageDollarAmount)#</cfoutput></td>
			<td><cfoutput>#DollarFormat(totalCostTotal)#</cfoutput></td>
			<td><cfoutput>#DollarFormat(grossMarginValueTotal)#</cfoutput></td>
			<td><cfoutput>#numberformat(grossMarginTotalPercent, "99.99")#</cfoutput></td>
		</tr>
		<tr>
			<td><strong><cfoutput>#theYear-1#</cfoutput></strong></td>
			<td><cfoutput>#numShipmentsLastYear#</cfoutput></td>
			<td><cfoutput>#DollarFormat(lastYearTotal)#</cfoutput></td>
			<td><cfoutput>#DollarFormat(totalAverageDollarAmountLastYear)#</cfoutput></td>
			<td><cfoutput>#DollarFormat(totalCostTotalLastYear)#</cfoutput></td>
			<td><cfoutput>#DollarFormat(grossMarginValueTotalLastYear)#</cfoutput></td>
			<td><cfoutput>#numberformat(grossMarginTotalPercentLastYear, "99.99")#</cfoutput></td>
		</tr>
		<tr>	
			<td><strong><cfoutput>#theYear-2#</cfoutput></strong></td>
			<td><cfoutput>#numShipments2YearsAgo#</cfoutput></td>
			<td><cfoutput>#DollarFormat(YearTotal2YearsAgo)#</cfoutput></td>
			<td><cfoutput>#DollarFormat(totalAverageDollarAmount2YearsAgo)#</cfoutput></td>
			<td><cfoutput>#DollarFormat(totalCostTotal2YearsAgo)#</cfoutput></td>
			<td><cfoutput>#DollarFormat(grossMarginValueTotal2YearsAgo)#</cfoutput></td>
			<td><cfoutput>#numberformat(grossMarginTotalPercent2YearsAgo, "99.99")#</cfoutput></td>
		</tr>	
	</table>
</p>
</body>
</html>
<cfcatch type="any"><cfdump var="#cfcatch#"></cfcatch>
</cftry>




   