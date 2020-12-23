#INCLUDE wwBusinessPro.h

* See wwBusinesPro.prg for full change log details.
* Version 5.3.1			2020-12-23	 (No changes here)	
* Version 5.3.0			2020-05-26	


*---------------------------------------------------------------------------------------
Define Class wwBusinessProSql as wwSql of wwSql.prg

	cExecuteLogFile = ''
	lLogExecuteCalls = .f. && Only logs if you set cExecuteLogFile property
	nLogExecuteTime = 0
	nExecuteCounter = 0
	nDataSessionID = 1
	nSeconds = 0
	lMapVarChar = .t.
	
	*---------------------------------------------------------------------------------------
	Procedure Init(lcConnectString, llAsynch)
	
		DoDefault(lcConnectString, llAsynch)

		If This.lMapVarChar
			*-- This setting will cause VFP to honor the varchar settings on a table in Sql Server,
			*-- and prevents VFP from padding the end of the field with spaces.
			*-- http://www.ml-consult.co.uk/foxst-36.htm
			CursorSetProp("MapVarchar", .T., 0)
		Endif

	Endproc
	
	*---------------------------------------------------------------------------------------
	Procedure cErrorMsg_Assign(tcErrorMsg)
		
		If !Empty(tcErrorMsg)
			?"oSql.cErrorMsg assigned: " + tcErrorMsg
		Endif
	
		This.cErrorMsg = tcErrorMsg
	
	Endproc
	
	*---------------------------------------------------------------------------------------
	Procedure Execute(tcSQL, tcResultCursor, tlStoredProcedure)
	
		Local lnReturn

		Set Datasession To (This.nDataSessionID)
		
		lnReturn = DoDefault(tcSql, tcResultCursor, tlStoredProcedure)
		
		Return lnReturn
	
	Endproc

	*---------------------------------------------------------------------------------------
	Procedure ExecuteStoredProcedure(tcSQL, tlNoCursorReturned)

		Local llResult

		Set Datasession To (This.nDataSessionID)

		llResult = DoDefault(tcSql, tlNoCursorReturned)
		
		Return llResult 
	
 	EndProc
 

 	*---------------------------------------------------------------------------------------
 	*-- Note: I added a call in wwSql.Execute() to call this method.
 	*-- To enable this, set lLogExecuteCalls = .t. and set cExecuteLogFile
 	*-- All writes to the log file are appended to the file (file is not overwritten)
 	Procedure LogExecuteCall(tcSql, tnExecuteTime, tlForceLog)

		Local lcText, lnTimeSinceLastLogCall

		If This.nLogExecuteTime > 0 and ;
			tnExecuteTime < This.nLogExecuteTime and;
			!tlForceLog
			Return
		EndIf
		
		*-- Record the amount of time since the last call to this method
		lnTimeSinceLastLogCall = Seconds() - This.nSeconds
		
		If This.lLogExecuteCalls and !Empty(This.cExecuteLogFile)
		
			This.nExecuteCounter = This.nExecuteCounter + 1

			*-- Record the times time and sql statement of this call
			lcText = This.GetExecuteLogString(tcSql, lnTimeSinceLastLogCall, tnExecuteTime)
			StrToFile(lcText, This.cExecuteLogFile, 1)
			
		Endif	
		
		This.nSeconds = Seconds()
		
 	EndProc
 	
 	*-------------------------------------------------------------------------------
 	*-- You can override this method to control what text gets written to the log file.
 	Procedure GetExecuteLogString(tcSql, tnTimeSinceLastCall, tnCurrentTime)
 	
		Local lcText, lcCR, lcCurrentBOClass, lcTimeSinceLastCall, lcCurrentTime
		Local loAppObject as wwBusinessProAppObject of wwBusinessAppObject.prg
		
		lcCR = Chr(13) + Chr(10)
		
		loAppObject = WWBUSINESSPRO_APPLICATION_OBJECT
		lcCurrentBOClass = Padr(loAppObject.cCurrentBOClass, 25)
		lcTimeSinceLastCall = Transform(tnTimeSinceLastCall, "999.###")
		lcCurrentTime = Transform(tnCurrentTime, "999.###")

		Text To lcText TextMerge NoShow PreText 7
	
			<<This.nExecuteCounter>>:<<lcTimeSinceLastCall>>:<<lcCurrentBOClass)>>:<<lcCurrentTime>>:<<tcSql>><<lcCR>>

		EndText
		
		Return lcText
 	
 	Endproc

Enddefine     