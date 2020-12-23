*-- These are stub/sample class names. Each of these can be referred to in the wwBusinessObjects.dbf
*-- Add methods to these class as needed to handle business transactions in the app.

*---------------------------------------------------------------------------------------
DEFINE CLASS Job AS wwBusinessProParent of wwBusinessProParent.prg

	cFilename = "Jobs" && The DBF name or Sql Server table name
	Name = "Job"
	
	*---------------------------------------------------------------------------------------
	Procedure CalculateShippingWeight
	
		Local lnShippingWeight
		
		lnShippingWeight = 0
		
		* Add logic code here...
		
		Return lnShippingWeight
	
	Endproc

ENDDEFINE


*=== Classes below are carious "Child Items" relative to the Parent Job:

*---------------------------------------------------------------------------------------
DEFINE CLASS JobFileItems AS wwBusinessProItemList of wwBusinessProItemList.prg

	cFilename = "JobFiles"
	Name = "JobFileItems"

ENDDEFINE


*---------------------------------------------------------------------------------------
DEFINE CLASS JobLaborItems AS wwBusinessProItemList of wwBusinessProItemList.prg

	cFilename = "TimeRecords"
	Name = "JobLaborItems"

ENDDEFINE


*---------------------------------------------------------------------------------------
DEFINE CLASS JobLineItems AS wwBusinessProItemList of wwBusinessProItemList.prg

	cFilename = "JobItems"
	Name = "JobLineItems"

ENDDEFINE


*---------------------------------------------------------------------------------------
DEFINE CLASS JobMtlItems AS wwBusinessProItemList of wwBusinessProItemList.prg

	cFilename = "PurchaseOrderItems"
	Name = "JobMtlItems"

ENDDEFINE
