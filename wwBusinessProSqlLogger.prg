Define Class wwBusinessProSqlLogger as wwBusinessPro of wwBusinessPro.prg

	cAlias    = "BusObjLog"
	cFilename = "BusObjLog"
	cPkField  = "id"
 	cSkipFieldsForUpdates = 'id' && Uses Identity column in Sql Server, so do not assign PK
 	lPreAssignPK = .f.
 	cIdTable = ""
	
	*---------------------------------------------------------------------------------------
	Procedure Log(tcMessage, tcType, tcSql)
		
			DoDefault(tcMessage, tcType, tcSql)
		
	EndProc
	
	*-------------------------------------------------------------------------------
	Procedure Save()
	
		Local lcTransactionName, llReturn

		If IsNullOrEmpty(This.oData.log_date)
			This.oData.log_date =  Datetime()
		Endif
		
		*-- Create a new oSql because we need an isolated Sql connection so we can 
		*-- insert a record outside of any Transaction that may be in place from
		*-- Save() method(s) of other Business Objects which may have caused this method to be called.
		This.oSql = CreateWWBO("wwBusinessProSql")
		This.oSql.Connect(This.cConnectString)
		
		*llReturn = DoDefault()
		llReturn = This.SaveBase()
		
		Return llReturn
	
	EndProc
	
	
	*=======================================================================================
	*== Use this SQL Script to create BusObjLog table in Sql Server ========================
	*=======================================================================================
	*!* 	/****** Table [dbo].[busobjlog]    for use by wwBusinessPro wwBusinessProSqlLogger class
	*!* 	CREATE TABLE [dbo].[BusObjLog](
	*!* 		[id] [int] IDENTITY(1,1) NOT NULL,
	*!* 		[log_date] [datetime] NULL,
	*!* 		[log_type] [char](10) NULL,
	*!* 		[user_id] [char](20) NULL,
	*!* 		[class] [char](20) NULL,
	*!* 		[obj_name] [char](20) NULL,
	*!* 		[error_code] [int] NULL,
	*!* 		[app_name] [char](30) NULL,
	*!* 		[mod_name] [char](30) NULL,
	*!* 		[msg] [varchar](max) NULL,
	*!* 		[sql] [varchar](max) NULL,
	*!* 	 CONSTRAINT [PK_busobjlog] PRIMARY KEY CLUSTERED 
	*!* 	(
	*!* 		[id] ASC
	*!* 	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	*!* 	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]	
		
	
EndDefine
  