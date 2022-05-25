IF OBJECT_ID('dbo.sp_ExtendedPropertyEditor') IS NULL
  EXEC ('CREATE PROCEDURE dbo.sp_ExtendedPropertyEditor AS RETURN 0;');
GO

ALTER PROCEDURE [dbo].[sp_ExtendedPropertyEditor]
    @Help TINYINT = 0,
	@PropertyName NVARCHAR(256) = 'MS_Description',
	@PropertyValue NVARCHAR(MAX) = NULL,
	@ObjectName VARCHAR (128) = NULL

WITH RECOMPILE
AS 
    SET NOCOUNT ON;
	SET STATISTICS XML OFF;
	--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF @Help = 1
	BEGIN
	PRINT
	'
	/*
		Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.

	Instructions:
	1) Execution with no parameters will show you a list of all extended properties in the current database.
		- You can use the outputted columns as inputs to this stored procedure. 
		  The last column contains code to update the data.
		  Copy > Paste > Modify Value > Execute
	2) TODO: Finish
	*/
	'
	END /* End Help section */
	ELSE IF @PropertyValue IS NULL
	BEGIN
		SELECT 
		       Class
			  ,Class_Desc
			  ,major_id
			  ,minor_id
			  ,PropertyName
			  ,PropertyValue
			  ,ObjectName
			  ,SchemaName
			  ,ParentName
		FROM
		  (
		    Values
		        ( 0, 'DATABASE', 0, 0, 'MS_Description', '-EXAMPLE DATABASE DESCRIPTION-', '-EXAMPLE DATABASE NAME-', NULL, NULL  ),
		        ( 1, '', 0, 0, 'MS_Description', '-EXAMPLE DESCRIPTION-', '-EXAMPLENAME-', '-EXAMPLESCHEMANAME-', '-EXAMPLEPARENTNAME-'  ),
		        ( 0, '', 0, 0, 'MS_Description', '-EXAMPLE DESCRIPTION-', '-EXAMPLENAME-', '-EXAMPLESCHEMANAME-', '-EXAMPLEPARENTNAME-'  ),
		        ( 0, '', 0, 0, 'MS_Description', '-EXAMPLE DESCRIPTION-', '-EXAMPLENAME-', '-EXAMPLESCHEMANAME-', '-EXAMPLEPARENTNAME-'  ),
		        ( 0, '', 0, 0, 'MS_Description', '-EXAMPLE DESCRIPTION-', '-EXAMPLENAME-', '-EXAMPLESCHEMANAME-', '-EXAMPLEPARENTNAME-'  ),
				( 0, '', 0, 0, 'MS_Description', '-EXAMPLE DESCRIPTION-', '-EXAMPLENAME-', '-EXAMPLESCHEMANAME-', '-EXAMPLEPARENTNAME-'  ),
				( 0, '', 0, 0, 'MS_Description', '-EXAMPLE DESCRIPTION-', '-EXAMPLENAME-', '-EXAMPLESCHEMANAME-', '-EXAMPLEPARENTNAME-'  ),
				( 0, '', 0, 0, 'MS_Description', '-EXAMPLE DESCRIPTION-', '-EXAMPLENAME-', '-EXAMPLESCHEMANAME-', '-EXAMPLEPARENTNAME-'  ),
				( 0, '', 0, 0, 'MS_Description', '-EXAMPLE DESCRIPTION-', '-EXAMPLENAME-', '-EXAMPLESCHEMANAME-', '-EXAMPLEPARENTNAME-'  ),
				( 0, '', 0, 0, 'MS_Description', '-EXAMPLE DESCRIPTION-', '-EXAMPLENAME-', '-EXAMPLESCHEMANAME-', '-EXAMPLEPARENTNAME-'  ),
				( 0, '', 0, 0, 'MS_Description', '-EXAMPLE DESCRIPTION-', '-EXAMPLENAME-', '-EXAMPLESCHEMANAME-', '-EXAMPLEPARENTNAME-'  ),
				( 0, '', 0, 0, 'MS_Description', '-EXAMPLE DESCRIPTION-', '-EXAMPLENAME-', '-EXAMPLESCHEMANAME-', '-EXAMPLEPARENTNAME-'  ),
				( 0, '', 0, 0, 'MS_Description', '-EXAMPLE DESCRIPTION-', '-EXAMPLENAME-', '-EXAMPLESCHEMANAME-', '-EXAMPLEPARENTNAME-'  ),
				( 0, '', 0, 0, 'MS_Description', '-EXAMPLE DESCRIPTION-', '-EXAMPLENAME-', '-EXAMPLESCHEMANAME-', '-EXAMPLEPARENTNAME-'  ),
				( 0, '', 0, 0, 'MS_Description', '-EXAMPLE DESCRIPTION-', '-EXAMPLENAME-', '-EXAMPLESCHEMANAME-', '-EXAMPLEPARENTNAME-'  ),
				( 0, '', 0, 0, 'MS_Description', '-EXAMPLE DESCRIPTION-', '-EXAMPLENAME-', '-EXAMPLESCHEMANAME-', '-EXAMPLEPARENTNAME-'  ),
				( 0, '', 0, 0, 'MS_Description', '-EXAMPLE DESCRIPTION-', '-EXAMPLENAME-', '-EXAMPLESCHEMANAME-', '-EXAMPLEPARENTNAME-'  ),
				( 0, '', 0, 0, 'MS_Description', '-EXAMPLE DESCRIPTION-', '-EXAMPLENAME-', '-EXAMPLESCHEMANAME-', '-EXAMPLEPARENTNAME-'  ),
				( 0, '', 0, 0, 'MS_Description', '-EXAMPLE DESCRIPTION-', '-EXAMPLENAME-', '-EXAMPLESCHEMANAME-', '-EXAMPLEPARENTNAME-'  )
		  ) AS Examples ( Class, Class_Desc, major_id, minor_id, PropertyName, PropertyValue, ObjectName, SchemaName, ParentName )

	SELECT 
		Class				= ep.[class]
		,Class_Desc			= ep.[class_desc]
		,ep.[major_id]
		,ep.[minor_id]
		,PropertyName		= ep.[name]
		,PropertyValue		= ep.[Value]
		,ObjectName			= CASE 
								WHEN ep.[class] = 0												THEN DB_NAME()
								WHEN (ep.[class] = 1 
									 AND ep.[minor_id] = 0 
									 AND o.[object_id] IS NULL)									THEN en.[Name] /* Ridiculous edge case for Event Notifications */
								WHEN ep.[class] = 1	AND ep.[minor_id] = 0						THEN o.[Name]
								WHEN ep.[class] = 1	AND ep.[minor_id] <> 0						THEN c.[Name]
								WHEN ep.[class] = 2												THEN pr.[Name]
								WHEN ep.[class] = 3												THEN sch.[Name]
								WHEN ep.[class] = 4												THEN dp.[Name]
								WHEN ep.[class] = 5												THEN a.[Name]
								WHEN ep.[class] = 6												THEN t.[Name]
								WHEN ep.[class] = 7												THEN i.[Name]
								WHEN ep.[class] = 8												THEN tc.[Name]
								WHEN ep.[class] = 10											THEN x.[Name]
								WHEN ep.[class] = 15 											THEN smt.[Name] 
								WHEN ep.[class] = 16											THEN sc.[Name]
								WHEN ep.[class] = 17											THEN s.[Name]
								WHEN ep.[class] = 18											THEN rsb.[Name]
								WHEN ep.[class] = 19											THEN r.[Name]
								WHEN ep.[class] = 20											THEN fg.[Name]
								WHEN ep.[class] = 21											THEN pf.[Name]
								WHEN ep.[class] = 22											THEN df.[Name]
								WHEN ep.[class] = 27											THEN pg.[Name]
								ELSE en.[Name]
							 END COLLATE DATABASE_DEFAULT
		--,ObjectType			= o.[type]
		--,ObjectTypeDesc		= o.[type_desc]
		,SchemaName	= CASE
								WHEN ep.[class] = 1 AND o.[object_id] IS NOT NULL				THEN os.[Name]
								WHEN ep.[class] = 1 AND ep.[minor_id] = 0						THEN pos.[Name]
								WHEN ep.[class] = 1 AND ep.[minor_id] <> 0						THEN cpos.[Name]
								WHEN ep.[class] = 2												THEN prs.[Name]
								WHEN ep.[class] = 6												THEN ts.[Name]
								WHEN ep.[class] = 7												THEN ips.[Name]
								WHEN ep.[class] = 8												THEN tts.[Name]
								WHEN ep.[class] = 10											THEN xs.[Name]
								WHEN ep.[class] = 22											THEN dfg.[Name]
								ELSE NULL
							  END
		,ParentName	= CASE
								 WHEN ep.[class] = 1 AND ep.[minor_id] = 0						THEN po.[Name]
								 WHEN ep.[class] = 1 AND ep.[minor_id] <> 0						THEN cpo.[Name]
								 WHEN ep.[class] = 2											THEN pro.[Name]
								 WHEN ep.[class] = 7											THEN ipo.[Name]
								 ELSE NULL
							  END
	FROM 
		sys.extended_properties				ep
	LEFT JOIN		/* If class is 1, AND minor_id = 0, THEN OBJECT and major_id is object_id */
		sys.objects							o 
		ON  ep.[major_id] = CASE
								WHEN (ep.[class] = 1		
									 AND ep.[minor_id] = 0) THEN o.[object_id]
								ELSE NULL
							END
	LEFT JOIN		/* If class = 1, AND minor_id <> 0, THEN COLUMN */
		sys.columns							c
		ON  ep.[major_id] = c.[object_id]
		AND ep.[minor_id] = CASE
								WHEN (ep.[class] = 1 
									 AND ep.[minor_id] <> 0) THEN c.[column_id]
								ELSE NULL
							END
	LEFT JOIN		/* Special case when class = 1 but the object can't be found it's an EVENT_NOTIFICATION (Microsoft undocumented feature) */
		sys.event_notifications				en
		ON ep.[major_id] = en.[object_id]
	LEFT JOIN		/* If class = 2, minor_id is the parameter_id. . */
		sys.parameters						pr
		ON  ep.[major_id] = pr.[object_id]
		AND ep.[minor_id] =	CASE
								WHEN ep.[class] = 2			THEN pr.[parameter_id]
								ELSE NULL
							END
	LEFT JOIN		/* if class = 3, then it's a SCHEMA */
		sys.schemas							sch
		ON  ep.[major_id] = CASE
								WHEN ep.[class] = 3			THEN sch.[schema_id]
								ELSE NULL
							END
	LEFT JOIN		/* If class = 4, then it's a DATABASE_PRINCIPAL */
		sys.database_principals				dp
		ON  ep.[major_id] = CASE
								WHEN ep.[class] = 4			THEN dp.[principal_id]
								ELSE NULL
							END
	LEFT JOIN		/* If class = 5, then it's an ASSEMBLY */
		sys.assemblies						a
		ON  ep.[major_id] = CASE
								WHEN ep.[class] = 5			THEN a.[assembly_id]
								ELSE NULL
							END
	LEFT JOIN		/* If class = 6, then it's a TYPE */
		sys.types							t
		ON  ep.[major_id] = CASE
								WHEN ep.[class] = 6			THEN t.[user_type_id]
								ELSE NULL
							END
	LEFT JOIN		/* If class = 7, then it's an INDEX, minor_id is the index_id */
		sys.indexes							i
		ON  ep.[major_id] = i.[object_id]
		AND ep.[minor_id] = CASE
								WHEN ep.[class] = 7			THEN i.[index_id]
								ELSE NULL
							END
	LEFT JOIN		/* If class = 8, then it's a TYPE_COLUMN i.e. COLUMN of a TABLE TYPE */
		sys.table_types						tt
		ON  ep.[major_id] = tt.[user_type_id]
	LEFT JOIN
		sys.columns							tc
		ON  tt.[type_table_object_id] = tc.[object_id]
		AND ep.[minor_id] = CASE 
								WHEN ep.[class] = 8			THEN tc.[column_id]
								ELSE NULL
							END
	LEFT JOIN		/* If class = 10, then it's an XML_SCHEMA_COLLECTION */
		sys.xml_schema_collections			x
		ON  ep.[major_id] = CASE
								WHEN ep.[class] = 10		THEN x.[xml_collection_id]
								ELSE NULL
							END
	LEFT JOIN		/* If class = 15, then it's a MESSAGE_TYPE */
		sys.service_message_types			smt
		ON  ep.[major_id] = CASE
								WHEN ep.[class] = 15		THEN smt.[message_type_id]
								ELSE NULL
							END 
	LEFT JOIN		/* If class = 16, then it's a SERVICE_CONTRACT */
		sys.service_contracts				sc
		ON  ep.[major_id] = CASE
								WHEN ep.[class] = 16		THEN sc.[service_contract_id]
								ELSE NULL
							END
	LEFT JOIN		/* If class = 17, then it's a SERVICE */
		sys.services						s
		ON  ep.[major_id] = CASE
								WHEN ep.[class] = 17		THEN s.[service_id]
								ELSE NULL
							END
	LEFT JOIN		/* If class = 18, then it's a REMOVE_SERVICE_BROKER */
		sys.remote_service_bindings			rsb
		ON  ep.[major_id] = CASE
								WHEN ep.[class] = 18		THEN rsb.[remote_service_binding_id]
								ELSE NULL
							END
	LEFT JOIN		/* If class = 19, then it's a ROUTE */
		sys.routes							r
		ON  ep.[major_id] = CASE
								WHEN ep.[class] = 19		THEN r.[route_id]
								ELSE NULL
							END
	LEFT JOIN		/* If class = 20, then it's a DATASPACE (filegroup) */
		sys.filegroups						fg
		ON  ep.[major_id] = CASE
								WHEN ep.[class] = 20		THEN fg.[data_space_id]
								ELSE NULL
							END
	LEFT JOIN		/* If class = 21, then it's a PARTITION_FUNCTION */
		sys.partition_functions				pf
		ON  ep.[major_id] = CASE
								WHEN ep.[class] = 21		THEN pf.[function_id]
								ELSE NULL
							END
	LEFT JOIN		/* If class = 22, then it's a DATABASE_FILE */
		sys.database_files					df
		ON ep.[major_id] = CASE
								WHEN ep.[class] = 22		THEN df.[file_id]
								ELSE NULL
							END
	LEFT JOIN		/* If class = 27, then it's a PLAN_GUIDE */
		sys.plan_guides						pg
		ON ep.[major_id] = CASE
								WHEN ep.[class] = 27		THEN pg.[plan_guide_id]
								ELSE NULL
							END
	LEFT JOIN		/* Parent Objects */
		sys.objects							po
		ON o.[parent_object_id] = po.[object_id]
	LEFT JOIN		/* Parent Object Schema */
		sys.schemas							pos
		ON po.[schema_id] = pos.[schema_id]
	LEFT JOIN		/* Column Parent Objects */
		sys.objects							cpo
		ON c.[object_id] = cpo.[object_id]
	LEFT JOIN		/* Column Parent Object Schema */
		sys.schemas							cpos
		ON cpo.[schema_id] = cpos.[schema_id]
	LEFT JOIN		/* Other Schema */
		sys.schemas							os 
		ON o.[schema_id] = os.[schema_id]
	LEFT JOIN		/* Parameter Object */ 
		sys.objects							pro
		ON pr.[object_id] = pro.[object_id]
	LEFT JOIN		/* Parameter Schema */
		sys.schemas							prs
		ON pro.[schema_id] = prs.[schema_id]
	LEFT JOIN		/* Type Schema */
		sys.schemas							ts
		ON t.[schema_id] = ts.[schema_id]
	LEFT JOIN		/* Index Parent Object */
		sys.objects							ipo
		ON i.[object_id] = ipo.[object_id]
	LEFT JOIN		/* Index Parent Schema */
		sys.schemas							ips
		ON ipo.[schema_id] = ips.[schema_id]
	LEFT JOIN		/* Table Type Schema */
		sys.schemas							tts
		ON tt.[schema_id] = tts.[schema_id]
	LEFT JOIN		/* XML Schema Collection Schema */
		sys.schemas							xs
		ON x.[schema_id] = xs.[schema_id]
	LEFT JOIN		/* Database File "Schema" aka DataSpace aka Filegroup */
		sys.filegroups						dfg
		ON df.[data_space_id] = dfg.[data_space_id]
	WHERE 1=1
		AND ep.[Name] = @PropertyName
	ORDER BY 
		ep.[class], ep.[Value]
	END /* End Informational Section */
	ELSE
	BEGIN /* Processing section */
	PRINT 'TODO Updates etc.'
	
--    WHILE @TableName IS NOT NULL 

--    BEGIN 

--        IF EXISTS (
--            SELECT *
--            FROM sys.[fn_listextendedproperty](
--                    N'MS_Description',
--                    N'SCHEMA',
--                    @SchemaName,
--                    N'TABLE',
--                    @TableName,
--                    N'COLUMN',
--                    @ColumnName
--                    )
--        ) 

--        BEGIN 
--            EXECUTE sys.[sp_updateextendedproperty] 
--                        @name = N'MS_Description',
--                        @value = @Description,
--                        @level0type = N'SCHEMA',
--                        @level0name = @SchemaName,
--                        @level1type = N'TABLE',
--                        @level1name = @TableName,
--                        @level2type = N'COLUMN',
--                        @level2name = @ColumnName;
--        END
--        ELSE 
--        BEGIN 
--            EXECUTE sys.[sp_addextendedproperty] @name = 'MS_Description',
--                        @value = @Description,
--                        @level0type = N'SCHEMA',
--                        @level0name = @SchemaName,
--                        @level1type = N'TABLE',
--                        @level1name = @TableName,
--                        @level2type = N'COLUMN',
--                        @level2name = @ColumnName;
--        END

--SET @TableName = (
--            SELECT TOP 1 t.[name]
--              FROM sys.[tables]  AS t
--        INNER JOIN sys.[schemas] AS s ON t.[schema_id] = s.[schema_id]
--        INNER JOIN sys.[columns] AS c ON c.[object_id] = t.[object_id]
--             WHERE t.[type] = 'U'
--               AND s.[name] = @SchemaName
--               AND c.[name] = @ColumnName
--               AND t.[name] > @TableName
--          ORDER BY t.[name] ASC
--    );
--    END
END

RETURN 


