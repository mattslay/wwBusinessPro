#INCLUDE wwBusinessPro.h

*=======================================================================================
Define Class wwBusinessProAppObject As Custom

	lExe = .f.
	lDevMode = .f.
	lRemoteDesktop = .f. 				&& See lRemoteDesktop_Access method
	cMessageClass = "AsyncMessaging"	&& Used by NewMessage() method.
	
	oActiveForm = .null.	&& You Form base class should set this property in its Activate() event.

	oConfig = .null.	&& You must assign this from the outside during bootup, and it
						&& needs to be based off of wwBusinessProAppConfig class, or if you
						&& use another class, you must implement all of the same properties and
						&& methods that are present in wwBusinessProAppConfig even if you don't
						&& need them in your app certin methods in wwBusinessPro may reference them.

	oSql = .null.		&& This needs to be assigned from the outside so you can have an application-wide
						&& reference to a common oSql object that you should use in all your Business Objects
						&& to avoid creating many difference connections to Sql Server
	
	oSql_wws_id = .null.&& This needs to be assigned from the outside so wwBusinessPro.CreateNewID() can use a 
						&& dedicated wwSql instance when creating new ID values. This is needed because if the main oSql
						&& is in the middle of a Transaction (as is the case when wwBusinessPro.Save() is called) when
						&& CreateNewID() is called, local record(s) can get a PK from the DB, but if the Transaction is rolled back
						&& then the wws_id table is also rolled back, but you still have the PK locally, and that leads to a big mess!
						&& This dedicated oSql_wws_id prevents that because wwBusinessPro uses this instance when CreateNewID() is called, 
						&& and this instance will be outside the scope of the main oSql (and any SQL Transcations) used by the
						&& BOs in your app.
	

	*-- These are stub properties to be assigned from your code, subclassing, or other bootstrapping process.
	*-- These properties are not used by wwBusinessPro, but you can use them throughout your app code
	*-- to reference and use as needed.
	cAppName = ""
	cCurrentModule = "" && Used to store the current module running in your app. Set this somewhere in your app/bo code.
	cActiveForm = ""	&& Used to store the current UI form running in your app. Set this in your form class Active() event.
	cCurrentBOClass = "" 
	cCurrentVersion = ""
	cTempFilesPath = "C:\Temp\"
	cDefaultPrinter = ""
	cUserFolder =  Sys(2023)
	
	*-- These are stub object reference to be assigned from your code or bootstrapping process.
	*-- These objects are not used by wwBusinessPro, but you can use them throughout your app code
	*-- to reference and use as needed.
	oSql = .null.
	oUser   = .null.
	oTracker = .null.
	oBO = .null.
	
	oBO_def = "{wwBusinessPro, wwBusinessPro.prg}"

	oForms = .null.

	*---------------------------------------------------------------------------------------
	Procedure Init

		*-- In your override of this method, or by some other external pattern, you'd wire up
		*-- any of these objects and properties on this class for use throughout your app code
		*-- to reference and use as needed.
		
		*-- Example setup work displayed below. Every app is different, so do whatever you need to 
		*-- get this global goApp object for use by your application.
		*---------------------------------------------------------------------------------------
		
		* This.oConfig = NewObject("LmConfig", "LmConfig.prg")
		* This.oValues = NewObject("Values", "Values.prg")
		
		* lcRunningFilename = JustFname(_vfp.ServerName)
		* This.cCurrentVersion = lcRunningFilename
		
		* If This.lDevMode and This.lUseTestData
		*	This.oConfig.Connstring = Strtran(This.oConfig.Connstring, "LMDB", "LMDB_TEST",1,99,1)
		* Endif
		
		This.cDefaultPrinter = SET("PRINTER", 2)
		
		This.oForms = CreateObject("Collection")

	EndProc
	
	*---------------------------------------------------------------------------------------
	Procedure LogError(tcErrorMessage)
	
		*-- Again, in your override, handle any calls to LogError() however you need to.
		*-- If you assign This.oBO in the Init() method, then you can use the wwBusinessPro.LogError() method
		*-- as shown below. If not, then override and do whatever magic you need or want to do to handle these calls.

		If Type("This.oBO") = "O"
			This.oBO.LogError(tcErrorMessage)
		Endif
	
	Endproc

	*---------------------------------------------------------------------------------------
	Procedure LogInfo(tcMessage)
	
		This.oBO.LogMessage(tcMessage)
	
	Endproc


	*---------------------------------------------------------------------------------------
	Procedure lExe_Access
		
		Local lcApp, llExe

		lcApp = Sys(16,1)
		llExe = '.EXE' $ Upper(lcApp)
		
		Return llExe
	
	Endproc
	
	*---------------------------------------------------------------------------------------
	Procedure lDevMode_Access
	
		Return !This.lExe		
	
	Endproc

	*---------------------------------------------------------------------------------------
	Procedure lRemoteDesktop_Access
	
		Local lcSessionName

		lcSessionName = Upper(Getenv('SESSIONNAME'))
		
		Return StartsWith(lcSessionName, 'RDP-')
			
	Endproc
	

	*---------------------------------------------------------------------------------------
	*- This handy method gives you a simple and common way to setup Classlibs and Procedure files
	*-- into your app setup calls.
	Procedure Require(tcAsset)
	
		DO CASE
			CASE ".vcx" $ Lower(tcAsset)	
				Set Classlib To (tcAsset) Additive
				
			Case ".fll" $ Lower(tcAsset)
				Set Library To (tcAsset) Additive

			Otherwise && Assumes .prg or no extension
				Set Procedure To (tcAsset) Additive
		ENDCASE

	EndProc
	

	*---------------------------------------------------------------------------------------
	* From: https://www.berezniker.com/content/pages/visual-foxpro/changing-windows-default-printer
	*---------------------------------------------------------------------------------------
	Procedure SetDefaultPrinter(tcPrinterName)
	
		Local lcPrinterName
		
		lcPrinterName = Evl(tcPrinterName, This.cDefaultPrinter)
		
		* Windows API
		Declare Long GetLastError In WIN32API
		Declare Long SetDefaultPrinter In WINSPOOL.DRV String pPrinterName
		
		If SetDefaultPrinter(lcPrinterName) = 0
		* Error
		*? WinApiErrMsg(GetLastError())
			Return .F.
		Else
			Return .T.
		Endif
	
	Endproc
	

	*---------------------------------------------------------------------------------------
	*-- Returns an instance of the Async Messaging class AsyncMessaging, used to submit messages
	*-- to the QueueMessageItems table. See AsyncMessaging.prg for more details.
	Procedure NewMessage(tcAction, tcQueueName)
		
		Local loAsync
		
		loAsync = CreateWWBO(This.cMessageClass)
		loAsync.CreateNewMessage(tcQueueName)
		
		loAsync.oMessage.Action = Evl(tcAction, "")
	
		Return loAsync
		
	Endproc
	

	*---------------------------------------------------------------------------------------
	*-- Display a quick Browse window showing the last <<tnCount>> error messages from BusObjLog
	Procedure BrowseRecentErrors(tnCount)
	
		Local lcCursor, lcSql, lnResult, lnCount, lnSelect
		
		lnSelect = Select()

		lnCount = Evl(tnCount, 100)
		
		Text To lcSql TextMerge NoShow PreText 15
		
				Select Top <<lnCount>> [id],
				               log_date,
				               user_id,
				               class as object_class,
				               mod_name as module_name,
				               Cast(msg as varchar(225)) as [message],
				               Cast(sql as varchar(225)) as [sql]
				From BusObjLog
				Where log_type = 'ERROR'
				Order By Log_date Desc

		EndText

		lcCursor = GetTempCursor()
		lnResult = This.oBO.Query(lcSql, lcCursor)
		
		If lnResult >= 0
			Browse Fields ;
				id :15, ;
				log_date :30, ;
				user_id :25, ;
				object_class :20, ;
				module_name :20, ;
				message :100, ;
				sql :100
		Else
			MessageBox("Error getting recent errors.")
		EndIf
		
		If Used(lcCursor)
			Use in (lcCursor)
		EndIf
		
		Select(lnSelect)
		
	Endproc

	*---------------------------------------------------------------------------------------
	Procedure SendAdminEmail(tcSubject, tcMessage, tlPlainText, tcRecipient)

		Local loSMTP

		loSMTP = This.GetAdminEmailer()
		
		If !IsObject(loSMTP)
			Return .f.
		EndIf
		
		loSMTP.cSubject = Evl(tcSubject, "")
		loSMTP.cMessage = Evl(tcMessage, "")
		loSMTP.cRecipient = Evl(tcRecipient, This.oConfig.AdminEmail)

		If tlPlainText
			loSMTP.cContentType = "text/plain"
		Endif

		llResult = loSMTP.SendMail()

		Return llResult

	EndProc
	
	*---------------------------------------------------------------------------------------
	Procedure GetAdminEmailer

		Local loSMTP as wwSmtp of wwSmtp.prg
		Local loAppConfigObjecto

		*-- See: http://www.west-wind.com/webconnection/docs/_2ql0tv6k4.htm for class details
		loSMTP = Createobject("wwSmtp")
		loAppConfigObject = WWBUSINESSPRO_APP_CONFIG_OBJECT
		
		loSMTP.cContentType = "text/html" && For text only used "text/plain"

		loSMTP.cMailServer = loAppConfigObject.SmtpServer
		loSMTP.cSenderEmail =  ""	&& Example: "notify@yourcompany.com"
		loSMTP.cSenderName = ""		&& Example: "John Smith"

		loSMTP.nMailMode = 2 && 0 = .NET wwSmtp, 2 = FoxPro wwIPStuff mode (Win32)

		loSMTP.cUsername = loAppConfigObject.SmtpUser
		loSMTP.cPassword = loAppConfigObject.SmtpPass

		Return loSMTP

	EndProc
	

	*---------------------------------------------------------------------------------------
	Procedure HideAllForms

		Local lnX, loForm
		
		For lnX = This.oForms.Count To 1 Step -1
			loForm = This.oForms(lnX)
			Try
				loForm.Hide()
			Catch
			Endtry
		Endfor

	Endproc		

	*---------------------------------------------------------------------------------------
	Procedure ReleaseAllForms

		Local lnX, loForm
		
		loForms = This.oForms

		For lnX = This.oForms.Count To 1 Step -1
			loForm = This.oForms(lnX)
			Try
				loForm.lDoNotCloseForm = .f.
			Catch
			EndTry
			Try
				If Type("loForm.lAddOrEditMode") = "L"
					If loForm.lAddOrEditMode = .F.
						loForm.Release()
						This.oForms.Remove(lnX)
					Endif
				Else
					loForm.Release()
					This.oForms.Remove(lnX)
				Endif
			Catch
			Endtry
		Endfor

	EndProc
	
	

		
EndDefine