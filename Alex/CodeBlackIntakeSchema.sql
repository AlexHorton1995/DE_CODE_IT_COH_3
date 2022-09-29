USE CodeBlack;
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PersonalDesc]') AND type in (N'U'))
	BEGIN
		CREATE TABLE [dbo].[PersonalDesc]
		(
			desc_key INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
			desc_selection varchar(100) Not Null	
		)
	END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LvlExperience]') AND type in (N'U'))
	BEGIN
		CREATE TABLE [dbo].[LvlExperience]
		(
			Lexp_key INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
			Lexp_Level varchar(100) Not Null
		)
	END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[gender]') AND type in (N'U'))
	BEGIN
		CREATE TABLE [dbo].[gender] 
		(
			gen_ID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
			gen_value varchar(100) NOT NULL
		)
	END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Occupations]') AND type in (N'U'))
	BEGIN
		CREATE TABLE [dbo].[Occupations]
		(
			occ_key INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
			occ_selection varchar(100) Not Null	
		)
	END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OutreachType]') AND type in (N'U'))
	BEGIN
		CREATE TABLE [dbo].[OutreachType]
		(
			out_key INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
			out_selection varchar(100) Not Null	
		)
	END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tshirt_size]') AND type in (N'U'))
	BEGIN
		CREATE TABLE [dbo].[tshirt_size] (	
			t_id int IDENTITY (1,1) PRIMARY KEY NOT NULL,
			t_size varchar(100) NOT NULL
		)
	END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TechAreas]') AND type in (N'U'))
	BEGIN
		CREATE TABLE [dbo].[TechAreas] (	
			tech_id int IDENTITY (1,1) PRIMARY KEY NOT NULL,
			tech_area varchar(100) NOT NULL
		)
	END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProgLanguages]') AND type in (N'U'))
	BEGIN
		CREATE TABLE [dbo].[ProgLanguages] (	
			programming_id int IDENTITY (1,1) PRIMARY KEY NOT NULL,
			prog_language varchar(100) NOT NULL
		)
	END
GO

--Table Inserts for foreign key tables(run only once)
/*
	truncate table gender
	truncate table lvlexperience
	truncate table occupations
	truncate table outreachtype
	truncate table personaldesc
	truncate table techareas
	truncate table tshirt_size

	INSERT INTO PersonalDesc(desc_selection) VALUES('I am a person of color NOT working in or adjacent to tech.')
	INSERT INTO PersonalDesc(desc_selection) VALUES('I am a person of color working in or adjacent to tech.')
	INSERT INTO PersonalDesc(desc_selection) VALUES('I am interested in learning more and want to stay informed')
	INSERT INTO LvlExperience(Lexp_Level) VALUES('Beginner')
	INSERT INTO LvlExperience(Lexp_Level) VALUES('Intermediate')
	INSERT INTO LvlExperience(Lexp_Level) VALUES('Advanced')
	INSERT INTO gender(gen_value) VALUES ('Female')
	INSERT INTO gender(gen_value) VALUES ('Male')
	INSERT INTO gender(gen_value) VALUES ('Non-binary')
	INSERT INTO gender(gen_value) VALUES ('Rather not say')
	INSERT INTO gender(gen_value) VALUES ('Third Female')
	INSERT INTO Occupations(occ_selection) VALUES('Coding / Computer Science Instructor')
	INSERT INTO Occupations(occ_selection) VALUES('College Student (non-tech)')
	INSERT INTO Occupations(occ_selection) VALUES('Computer Science Student')
	INSERT INTO Occupations(occ_selection) VALUES('Entry Level Tech')
	INSERT INTO Occupations(occ_selection) VALUES('Other')
	INSERT INTO Occupations(occ_selection) VALUES('Project / Product Manager')
	INSERT INTO Occupations(occ_selection) VALUES('Software Developer / QA Tester / Dev Ops')
	INSERT INTO Occupations(occ_selection) VALUES('Tech Manager / Architect')
	INSERT INTO OutreachType(out_selection) VALUES('Friend/ Word of mouth')
	INSERT INTO OutreachType(out_selection) VALUES('Social media')
	INSERT INTO OutreachType(out_selection) VALUES('Traditional media (radio, email, T.V.)')
	INSERT INTO tshirt_size(t_size) VALUES ('L')
	INSERT INTO tshirt_size(t_size) VALUES ('M')
	INSERT INTO tshirt_size(t_size) VALUES ('S')
	INSERT INTO tshirt_size(t_size) VALUES ('XL')
	INSERT INTO tshirt_size(t_size) VALUES ('XXL')
	INSERT INTO tshirt_size(t_size) VALUES ('XXXL')
	INSERT INTO TechAreas(tech_area) VALUES('Artificial Intelligence')
	INSERT INTO TechAreas(tech_area) VALUES('Cybersecurity')
	INSERT INTO TechAreas(tech_area) VALUES('Devices and Gadgets')
	INSERT INTO TechAreas(tech_area) VALUES('Hardware Development')
	INSERT INTO TechAreas(tech_area) VALUES('New Technology')
	INSERT INTO TechAreas(tech_area) VALUES('Other')
	INSERT INTO TechAreas(tech_area) VALUES('Software Development')
	INSERT INTO TechAreas(tech_area) VALUES('Web Design/Building')
	INSERT INTO TechAreas(tech_area) VALUES('All')
	INSERT INTO ProgLanguages (prog_language) VALUES('VFP')
	INSERT INTO ProgLanguages (prog_language) VALUES('Enterprise script')
	INSERT INTO ProgLanguages (prog_language) VALUES('4D')
	INSERT INTO ProgLanguages (prog_language) VALUES('ABAP')
	INSERT INTO ProgLanguages (prog_language) VALUES('ABC')
	INSERT INTO ProgLanguages (prog_language) VALUES('ActionScript')
	INSERT INTO ProgLanguages (prog_language) VALUES('Ada')
	INSERT INTO ProgLanguages (prog_language) VALUES('Agilent VEE')
	INSERT INTO ProgLanguages (prog_language) VALUES('Algol')
	INSERT INTO ProgLanguages (prog_language) VALUES('Alice')
	INSERT INTO ProgLanguages (prog_language) VALUES('Angelscript')
	INSERT INTO ProgLanguages (prog_language) VALUES('Apex')
	INSERT INTO ProgLanguages (prog_language) VALUES('APL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Applescript')
	INSERT INTO ProgLanguages (prog_language) VALUES('Arc')
	INSERT INTO ProgLanguages (prog_language) VALUES('AspectJ')
	INSERT INTO ProgLanguages (prog_language) VALUES('Assembly')
	INSERT INTO ProgLanguages (prog_language) VALUES('ATLAS')
	INSERT INTO ProgLanguages (prog_language) VALUES('AHK')
	INSERT INTO ProgLanguages (prog_language) VALUES('AutoIt')
	INSERT INTO ProgLanguages (prog_language) VALUES('AutoLISP')
	INSERT INTO ProgLanguages (prog_language) VALUES('Automator')
	INSERT INTO ProgLanguages (prog_language) VALUES('Avenue')
	INSERT INTO ProgLanguages (prog_language) VALUES('Awk')
	INSERT INTO ProgLanguages (prog_language) VALUES('B4X')
	INSERT INTO ProgLanguages (prog_language) VALUES('Ballerina')
	INSERT INTO ProgLanguages (prog_language) VALUES('Bash')
	INSERT INTO ProgLanguages (prog_language) VALUES('Basic')
	INSERT INTO ProgLanguages (prog_language) VALUES('BBC BASIC')
	INSERT INTO ProgLanguages (prog_language) VALUES('bc')
	INSERT INTO ProgLanguages (prog_language) VALUES('BCPL')
	INSERT INTO ProgLanguages (prog_language) VALUES('BETA')
	INSERT INTO ProgLanguages (prog_language) VALUES('BlitzMax')
	INSERT INTO ProgLanguages (prog_language) VALUES('BlitzBasic')
	INSERT INTO ProgLanguages (prog_language) VALUES('Boo')
	INSERT INTO ProgLanguages (prog_language) VALUES('Bourne shell')
	INSERT INTO ProgLanguages (prog_language) VALUES('sh')
	INSERT INTO ProgLanguages (prog_language) VALUES('Csh')
	INSERT INTO ProgLanguages (prog_language) VALUES('C#')
	INSERT INTO ProgLanguages (prog_language) VALUES('C++')
	INSERT INTO ProgLanguages (prog_language) VALUES('C++/CLI')
	INSERT INTO ProgLanguages (prog_language) VALUES('C-Omega')
	INSERT INTO ProgLanguages (prog_language) VALUES('C')
	INSERT INTO ProgLanguages (prog_language) VALUES('Caml')
	INSERT INTO ProgLanguages (prog_language) VALUES('Carbon')
	INSERT INTO ProgLanguages (prog_language) VALUES('Ceylon')
	INSERT INTO ProgLanguages (prog_language) VALUES('ColdFusion')
	INSERT INTO ProgLanguages (prog_language) VALUES('cg')
	INSERT INTO ProgLanguages (prog_language) VALUES('Ch')
	INSERT INTO ProgLanguages (prog_language) VALUES('Chapel')
	INSERT INTO ProgLanguages (prog_language) VALUES('CHILL')
	INSERT INTO ProgLanguages (prog_language) VALUES('CIL')
	INSERT INTO ProgLanguages (prog_language) VALUES('OS/400')
	INSERT INTO ProgLanguages (prog_language) VALUES('CLLE')
	INSERT INTO ProgLanguages (prog_language) VALUES('Clarion')
	INSERT INTO ProgLanguages (prog_language) VALUES('VBA')
	INSERT INTO ProgLanguages (prog_language) VALUES('VB6')
	INSERT INTO ProgLanguages (prog_language) VALUES('Clean')
	INSERT INTO ProgLanguages (prog_language) VALUES('Clipper')
	INSERT INTO ProgLanguages (prog_language) VALUES('CLIPS')
	INSERT INTO ProgLanguages (prog_language) VALUES('Clojure')
	INSERT INTO ProgLanguages (prog_language) VALUES('ClojureScript')
	INSERT INTO ProgLanguages (prog_language) VALUES('CLU')
	INSERT INTO ProgLanguages (prog_language) VALUES('COBOL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Cobra')
	INSERT INTO ProgLanguages (prog_language) VALUES('CoffeeScript')
	INSERT INTO ProgLanguages (prog_language) VALUES('COMAL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Common Lisp')
	INSERT INTO ProgLanguages (prog_language) VALUES('Crystal ')
	INSERT INTO ProgLanguages (prog_language) VALUES('cT')
	INSERT INTO ProgLanguages (prog_language) VALUES('Curl')
	INSERT INTO ProgLanguages (prog_language) VALUES('D')
	INSERT INTO ProgLanguages (prog_language) VALUES('Dart')
	INSERT INTO ProgLanguages (prog_language) VALUES('DCL')
	INSERT INTO ProgLanguages (prog_language) VALUES('DwScript')
	INSERT INTO ProgLanguages (prog_language) VALUES('Object Pascal')
	INSERT INTO ProgLanguages (prog_language) VALUES('Delphi.NET')
	INSERT INTO ProgLanguages (prog_language) VALUES('Pascal')
	INSERT INTO ProgLanguages (prog_language) VALUES('DBL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Synergy/DE')
	INSERT INTO ProgLanguages (prog_language) VALUES('DIBOL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Dylan')
	INSERT INTO ProgLanguages (prog_language) VALUES('E')
	INSERT INTO ProgLanguages (prog_language) VALUES('ECMAScript')
	INSERT INTO ProgLanguages (prog_language) VALUES('EGL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Eiffel')
	INSERT INTO ProgLanguages (prog_language) VALUES('Elixir')
	INSERT INTO ProgLanguages (prog_language) VALUES('Elm')
	INSERT INTO ProgLanguages (prog_language) VALUES('Emacs Lisp')
	INSERT INTO ProgLanguages (prog_language) VALUES('Elisp')
	INSERT INTO ProgLanguages (prog_language) VALUES('Emerald')
	INSERT INTO ProgLanguages (prog_language) VALUES('Erlang')
	INSERT INTO ProgLanguages (prog_language) VALUES('Etoys')
	INSERT INTO ProgLanguages (prog_language) VALUES('Euphoria')
	INSERT INTO ProgLanguages (prog_language) VALUES('EXEC')
	INSERT INTO ProgLanguages (prog_language) VALUES('F#')
	INSERT INTO ProgLanguages (prog_language) VALUES('Factor')
	INSERT INTO ProgLanguages (prog_language) VALUES('Falcon')
	INSERT INTO ProgLanguages (prog_language) VALUES('Fantom')
	INSERT INTO ProgLanguages (prog_language) VALUES('Felix')
	INSERT INTO ProgLanguages (prog_language) VALUES('Forth')
	INSERT INTO ProgLanguages (prog_language) VALUES('Fortran')
	INSERT INTO ProgLanguages (prog_language) VALUES('Fortress')
	INSERT INTO ProgLanguages (prog_language) VALUES('FreeBASIC')
	INSERT INTO ProgLanguages (prog_language) VALUES('Gambas')
	INSERT INTO ProgLanguages (prog_language) VALUES('GAMS')
	INSERT INTO ProgLanguages (prog_language) VALUES('GLSL')
	INSERT INTO ProgLanguages (prog_language) VALUES('GML')
	INSERT INTO ProgLanguages (prog_language) VALUES('GNU Octave')
	INSERT INTO ProgLanguages (prog_language) VALUES('Go')
	INSERT INTO ProgLanguages (prog_language) VALUES('Gosu')
	INSERT INTO ProgLanguages (prog_language) VALUES('Groovy')
	INSERT INTO ProgLanguages (prog_language) VALUES('GPATH')
	INSERT INTO ProgLanguages (prog_language) VALUES('GSQL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Groovy++')
	INSERT INTO ProgLanguages (prog_language) VALUES('HTML')
	INSERT INTO ProgLanguages (prog_language) VALUES('Hack')
	INSERT INTO ProgLanguages (prog_language) VALUES('Harbour')
	INSERT INTO ProgLanguages (prog_language) VALUES('Haskell')
	INSERT INTO ProgLanguages (prog_language) VALUES('Haxe')
	INSERT INTO ProgLanguages (prog_language) VALUES('Heron')
	INSERT INTO ProgLanguages (prog_language) VALUES('HPL')
	INSERT INTO ProgLanguages (prog_language) VALUES('HyperTalk')
	INSERT INTO ProgLanguages (prog_language) VALUES('Icon')
	INSERT INTO ProgLanguages (prog_language) VALUES('IDL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Idris')
	INSERT INTO ProgLanguages (prog_language) VALUES('Inform')
	INSERT INTO ProgLanguages (prog_language) VALUES('Informix-4GL')
	INSERT INTO ProgLanguages (prog_language) VALUES('INTERCAL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Io')
	INSERT INTO ProgLanguages (prog_language) VALUES('Ioke')
	INSERT INTO ProgLanguages (prog_language) VALUES('J#')
	INSERT INTO ProgLanguages (prog_language) VALUES('J')
	INSERT INTO ProgLanguages (prog_language) VALUES('JADE')
	INSERT INTO ProgLanguages (prog_language) VALUES('Java')
	INSERT INTO ProgLanguages (prog_language) VALUES('JavaFX Script')
	INSERT INTO ProgLanguages (prog_language) VALUES('JavaScript')
	INSERT INTO ProgLanguages (prog_language) VALUES('JScript')
	INSERT INTO ProgLanguages (prog_language) VALUES('JScript.NET')
	INSERT INTO ProgLanguages (prog_language) VALUES('Julia')
	INSERT INTO ProgLanguages (prog_language) VALUES('Julialang')
	INSERT INTO ProgLanguages (prog_language) VALUES('julia-lang')
	INSERT INTO ProgLanguages (prog_language) VALUES('Korn shell')
	INSERT INTO ProgLanguages (prog_language) VALUES('ksh')
	INSERT INTO ProgLanguages (prog_language) VALUES('Kotlin')
	INSERT INTO ProgLanguages (prog_language) VALUES('LabVIEW')
	INSERT INTO ProgLanguages (prog_language) VALUES('Ladder Logic')
	INSERT INTO ProgLanguages (prog_language) VALUES('Lasso')
	INSERT INTO ProgLanguages (prog_language) VALUES('Limbo')
	INSERT INTO ProgLanguages (prog_language) VALUES('Lingo')
	INSERT INTO ProgLanguages (prog_language) VALUES('Lisp')
	INSERT INTO ProgLanguages (prog_language) VALUES('Revolution')
	INSERT INTO ProgLanguages (prog_language) VALUES('LiveCode')
	INSERT INTO ProgLanguages (prog_language) VALUES('Logo')
	INSERT INTO ProgLanguages (prog_language) VALUES('LotusScript')
	INSERT INTO ProgLanguages (prog_language) VALUES('LPC')
	INSERT INTO ProgLanguages (prog_language) VALUES('Lua')
	INSERT INTO ProgLanguages (prog_language) VALUES('LuaJIT')
	INSERT INTO ProgLanguages (prog_language) VALUES('Lustre')
	INSERT INTO ProgLanguages (prog_language) VALUES('M4')
	INSERT INTO ProgLanguages (prog_language) VALUES('MAD')
	INSERT INTO ProgLanguages (prog_language) VALUES('Magic')
	INSERT INTO ProgLanguages (prog_language) VALUES('Magik')
	INSERT INTO ProgLanguages (prog_language) VALUES('Malbolge')
	INSERT INTO ProgLanguages (prog_language) VALUES('MANTIS')
	INSERT INTO ProgLanguages (prog_language) VALUES('Maple')
	INSERT INTO ProgLanguages (prog_language) VALUES('MATLAB')
	INSERT INTO ProgLanguages (prog_language) VALUES('Max/MSP')
	INSERT INTO ProgLanguages (prog_language) VALUES('MAXScript')
	INSERT INTO ProgLanguages (prog_language) VALUES('MDX')
	INSERT INTO ProgLanguages (prog_language) VALUES('MEL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Mercury')
	INSERT INTO ProgLanguages (prog_language) VALUES('Miva')
	INSERT INTO ProgLanguages (prog_language) VALUES('ML')
	INSERT INTO ProgLanguages (prog_language) VALUES('Modula-2')
	INSERT INTO ProgLanguages (prog_language) VALUES('Modula-3')
	INSERT INTO ProgLanguages (prog_language) VALUES('Monkey')
	INSERT INTO ProgLanguages (prog_language) VALUES('MOO')
	INSERT INTO ProgLanguages (prog_language) VALUES('Moto')
	INSERT INTO ProgLanguages (prog_language) VALUES('MQL4')
	INSERT INTO ProgLanguages (prog_language) VALUES('MQL5')
	INSERT INTO ProgLanguages (prog_language) VALUES('MS-DOS batch')
	INSERT INTO ProgLanguages (prog_language) VALUES('MUMPS')
	INSERT INTO ProgLanguages (prog_language) VALUES('NATURAL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Nemerle')
	INSERT INTO ProgLanguages (prog_language) VALUES('NetLogo')
	INSERT INTO ProgLanguages (prog_language) VALUES('Nim')
	INSERT INTO ProgLanguages (prog_language) VALUES('Nimrod')
	INSERT INTO ProgLanguages (prog_language) VALUES('NQC')
	INSERT INTO ProgLanguages (prog_language) VALUES('NSIS')
	INSERT INTO ProgLanguages (prog_language) VALUES('NXT-G')
	INSERT INTO ProgLanguages (prog_language) VALUES('Oberon')
	INSERT INTO ProgLanguages (prog_language) VALUES('Object Rexx')
	INSERT INTO ProgLanguages (prog_language) VALUES('Objective-C')
	INSERT INTO ProgLanguages (prog_language) VALUES('OCaml')
	INSERT INTO ProgLanguages (prog_language) VALUES('Occam')
	INSERT INTO ProgLanguages (prog_language) VALUES('OpenCL')
	INSERT INTO ProgLanguages (prog_language) VALUES('OpenEdge ABL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Progress')
	INSERT INTO ProgLanguages (prog_language) VALUES('Progress 4GL')
	INSERT INTO ProgLanguages (prog_language) VALUES('ABL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Advanced Business Language')
	INSERT INTO ProgLanguages (prog_language) VALUES('OpenEdge')
	INSERT INTO ProgLanguages (prog_language) VALUES('OPL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Oxygene')
	INSERT INTO ProgLanguages (prog_language) VALUES('Oz')
	INSERT INTO ProgLanguages (prog_language) VALUES('Paradox')
	INSERT INTO ProgLanguages (prog_language) VALUES('Pascal')
	INSERT INTO ProgLanguages (prog_language) VALUES('Perl')
	INSERT INTO ProgLanguages (prog_language) VALUES('PHP')
	INSERT INTO ProgLanguages (prog_language) VALUES('Pike')
	INSERT INTO ProgLanguages (prog_language) VALUES('PILOT')
	INSERT INTO ProgLanguages (prog_language) VALUES('PL/1')
	INSERT INTO ProgLanguages (prog_language) VALUES('PL/I')
	INSERT INTO ProgLanguages (prog_language) VALUES('PL/SQL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Pliant')
	INSERT INTO ProgLanguages (prog_language) VALUES('Pony')
	INSERT INTO ProgLanguages (prog_language) VALUES('PostScript')
	INSERT INTO ProgLanguages (prog_language) VALUES('PS')
	INSERT INTO ProgLanguages (prog_language) VALUES('POV-Ray')
	INSERT INTO ProgLanguages (prog_language) VALUES('PowerBasic')
	INSERT INTO ProgLanguages (prog_language) VALUES('PowerScript')
	INSERT INTO ProgLanguages (prog_language) VALUES('PowerShell')
	INSERT INTO ProgLanguages (prog_language) VALUES('Prolog')
	INSERT INTO ProgLanguages (prog_language) VALUES('PD')
	INSERT INTO ProgLanguages (prog_language) VALUES('PureBasic')
	INSERT INTO ProgLanguages (prog_language) VALUES('Python')
	INSERT INTO ProgLanguages (prog_language) VALUES('Q')
	INSERT INTO ProgLanguages (prog_language) VALUES('R')
	INSERT INTO ProgLanguages (prog_language) VALUES('Racket')
	INSERT INTO ProgLanguages (prog_language) VALUES('Perl 6')
	INSERT INTO ProgLanguages (prog_language) VALUES('Raku')
	INSERT INTO ProgLanguages (prog_language) VALUES('REBOL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Red')
	INSERT INTO ProgLanguages (prog_language) VALUES('REXX')
	INSERT INTO ProgLanguages (prog_language) VALUES('Ring')
	INSERT INTO ProgLanguages (prog_language) VALUES('RPG')
	INSERT INTO ProgLanguages (prog_language) VALUES('RPGLE')
	INSERT INTO ProgLanguages (prog_language) VALUES('ILERPG')
	INSERT INTO ProgLanguages (prog_language) VALUES('RPGIV')
	INSERT INTO ProgLanguages (prog_language) VALUES('RPGIII')
	INSERT INTO ProgLanguages (prog_language) VALUES('RPG400')
	INSERT INTO ProgLanguages (prog_language) VALUES('RPGII')
	INSERT INTO ProgLanguages (prog_language) VALUES('RPG4')
	INSERT INTO ProgLanguages (prog_language) VALUES('Ruby')
	INSERT INTO ProgLanguages (prog_language) VALUES('Rust')
	INSERT INTO ProgLanguages (prog_language) VALUES('Rustlang')
	INSERT INTO ProgLanguages (prog_language) VALUES('S-PLUS')
	INSERT INTO ProgLanguages (prog_language) VALUES('S')
	INSERT INTO ProgLanguages (prog_language) VALUES('SAS')
	INSERT INTO ProgLanguages (prog_language) VALUES('Sather')
	INSERT INTO ProgLanguages (prog_language) VALUES('Scala')
	INSERT INTO ProgLanguages (prog_language) VALUES('Scheme')
	INSERT INTO ProgLanguages (prog_language) VALUES('Scratch')
	INSERT INTO ProgLanguages (prog_language) VALUES('sed')
	INSERT INTO ProgLanguages (prog_language) VALUES('Seed7')
	INSERT INTO ProgLanguages (prog_language) VALUES('SIGNAL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Simula')
	INSERT INTO ProgLanguages (prog_language) VALUES('Simulink')
	INSERT INTO ProgLanguages (prog_language) VALUES('Slate')
	INSERT INTO ProgLanguages (prog_language) VALUES('Small Basic')
	INSERT INTO ProgLanguages (prog_language) VALUES('Smalltalk')
	INSERT INTO ProgLanguages (prog_language) VALUES('Smarty')
	INSERT INTO ProgLanguages (prog_language) VALUES('Snap!')
	INSERT INTO ProgLanguages (prog_language) VALUES('SNOBOL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Solidity')
	INSERT INTO ProgLanguages (prog_language) VALUES('SPARK')
	INSERT INTO ProgLanguages (prog_language) VALUES('SPSS')
	INSERT INTO ProgLanguages (prog_language) VALUES('SQL')
	INSERT INTO ProgLanguages (prog_language) VALUES('SQR')
	INSERT INTO ProgLanguages (prog_language) VALUES('Squeak')
	INSERT INTO ProgLanguages (prog_language) VALUES('Squirrel')
	INSERT INTO ProgLanguages (prog_language) VALUES('Standard ML')
	INSERT INTO ProgLanguages (prog_language) VALUES('Stata')
	INSERT INTO ProgLanguages (prog_language) VALUES('Structured Text')
	INSERT INTO ProgLanguages (prog_language) VALUES('Suneido')
	INSERT INTO ProgLanguages (prog_language) VALUES('SuperCollider')
	INSERT INTO ProgLanguages (prog_language) VALUES('Swift')
	INSERT INTO ProgLanguages (prog_language) VALUES('TACL')
	INSERT INTO ProgLanguages (prog_language) VALUES('Tcl/Tk')
	INSERT INTO ProgLanguages (prog_language) VALUES('Tcl')
	INSERT INTO ProgLanguages (prog_language) VALUES('tcsh')
	INSERT INTO ProgLanguages (prog_language) VALUES('Tex')
	INSERT INTO ProgLanguages (prog_language) VALUES('thinBasic')
	INSERT INTO ProgLanguages (prog_language) VALUES('TOM')
	INSERT INTO ProgLanguages (prog_language) VALUES('T-SQL')
	INSERT INTO ProgLanguages (prog_language) VALUES('TypeScript')
	INSERT INTO ProgLanguages (prog_language) VALUES('Uniface')
	INSERT INTO ProgLanguages (prog_language) VALUES('Vala')
	INSERT INTO ProgLanguages (prog_language) VALUES('Genie')
	INSERT INTO ProgLanguages (prog_language) VALUES('VBScript')
	INSERT INTO ProgLanguages (prog_language) VALUES('Verilog')
	INSERT INTO ProgLanguages (prog_language) VALUES('VHDL')
	INSERT INTO ProgLanguages (prog_language) VALUES('VB')
	INSERT INTO ProgLanguages (prog_language) VALUES('VB.NET')
	INSERT INTO ProgLanguages (prog_language) VALUES('WASM ')
	INSERT INTO ProgLanguages (prog_language) VALUES('WebAssembly')
	INSERT INTO ProgLanguages (prog_language) VALUES('WebDNA')
	INSERT INTO ProgLanguages (prog_language) VALUES('Whitespace')
	INSERT INTO ProgLanguages (prog_language) VALUES('Wolfram')
	INSERT INTO ProgLanguages (prog_language) VALUES('X++')
	INSERT INTO ProgLanguages (prog_language) VALUES('X10')
	INSERT INTO ProgLanguages (prog_language) VALUES('xBase')
	INSERT INTO ProgLanguages (prog_language) VALUES('XBase++')
	INSERT INTO ProgLanguages (prog_language) VALUES('XC')
	INSERT INTO ProgLanguages (prog_language) VALUES('Xen')
	INSERT INTO ProgLanguages (prog_language) VALUES('REALbasic')
	INSERT INTO ProgLanguages (prog_language) VALUES('Xojo')
	INSERT INTO ProgLanguages (prog_language) VALUES('XPL')
	INSERT INTO ProgLanguages (prog_language) VALUES('XQuery')
	INSERT INTO ProgLanguages (prog_language) VALUES('XSLT')
	INSERT INTO ProgLanguages (prog_language) VALUES('Xtend')
	INSERT INTO ProgLanguages (prog_language) VALUES('yacc')
	INSERT INTO ProgLanguages (prog_language) VALUES('Yorick')
	INSERT INTO ProgLanguages (prog_language) VALUES('Z shell')
	INSERT INTO ProgLanguages (prog_language) VALUES('zsh')
	INSERT INTO ProgLanguages (prog_language) VALUES('Zig')
	INSERT INTO ProgLanguages (prog_language) VALUES('zlang')
	INSERT INTO ProgLanguages (prog_language) VALUES('OTHER')
*/


/****** Object:  Table [dbo].[PersonalDesc]    Script Date: 9/28/2022 12:52:04 PM ******/
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CBRosterInfo]') AND type in (N'U'))
	BEGIN
	CREATE TABLE [dbo].[CBRosterInfo](
		[member_key] [int] IDENTITY(1,1) NOT NULL,
		[member_date] date NOT NULL,
		[first_name] [varchar](30) NOT NULL,
		[last_name] [varchar](30) NOT NULL,
		[email] [varchar](60) NULL,
		[phone] [varchar](15) NULL,
		[address1] [varchar](35) NOT NULL,
		[address2] [varchar](35) NULL,
		[city] [varchar](23) NOT NULL,
		[state] [varchar](35) NOT NULL,
		[zip] [varchar](6) NOT NULL,
		[country] [char](3) DEFAULT('USA') NOT NULL,
		[dob] [date] NOT NULL,
		[self_identify] int DEFAULT(1) NOT NULL,
		[self_description] int DEFAULT(1) NOT NULL,
		[outreach_type] int DEFAULT(1) NOT NULL,
		[occupation] int DEFAULT(1) NOT NULL,		
		[occupation_other] varchar(500) NULL,
		[job_seeking] bit DEFAULT(0) NOT NULL,
		[exp_level] int DEFAULT(1) NOT NULL,		
		[interest_area] int DEFAULT(9) NOT NULL,
		[interest_other] varchar(500) NULL,
		[programming_lang] int DEFAULT(319) NOT NULL,
		[programming_other] varchar(500) NULL,
		[shirt_size] int DEFAULT(1) NOT NULL
	PRIMARY KEY CLUSTERED 
	(
		[member_key] ASC,
		[member_date] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
	END
GO



