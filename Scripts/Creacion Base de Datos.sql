USE [GD2C2016]
GO
/****** Object:  Schema [CHAMBA]    Script Date: 10/10/2016 1:16:36 a. m. ******/
CREATE SCHEMA [CHAMBA]
GO
/****** Object:  StoredProcedure [CHAMBA].[CargarAfiliados]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CHAMBA].[CargarAfiliados] (@Afiliado varchar(18), @Nombre varchar(255), @Apellido varchar(255), @Documento varchar(18))
AS
BEGIN
SELECT Paci_Numero AS 'Nro. Afiliado', Usua_Nombre AS 'Nombre', Usua_Apellido AS 'Apellido', Usua_DNI AS 'Documento', Usua_Telefono AS 'Telefono', Usua_Mail AS 'Email'
FROM CHAMBA.Pacientes JOIN CHAMBA.Usuarios ON Paci_Usuario = Usua_Id
WHERE CONVERT(varchar(18), Paci_Numero) LIKE '%'+ISNULL(@Afiliado, '')+'%' 
AND Usua_Nombre LIKE '%'+ISNULL(@Nombre, '')+'%' 
AND Usua_Apellido LIKE '%'+ISNULL(@Apellido, '')+'%' 
AND CONVERT(varchar(18), Usua_DNI) LIKE '%'+ISNULL(@Documento, '')+'%'
AND Paci_Fecha_Baja IS NULL ORDER BY Paci_Numero
RETURN
END



GO
/****** Object:  StoredProcedure [CHAMBA].[ComprarBonos]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CHAMBA].[ComprarBonos] (@Afiliado varchar(18), @Cantidad INT, @Fecha datetime)
AS
BEGIN
	DECLARE @Usuario numeric(18,0), @Plan numeric(18,0), @Compra numeric(18,0), @Valor numeric(18,0), @i INT = 0, @Numero numeric(18,0)
	SELECT @Usuario = Paci_Usuario, @Plan = Paci_Plan FROM CHAMBA.Pacientes WHERE Paci_Numero = @Afiliado

	INSERT INTO Compra_Bonos (Comp_Bono_Fecha, Comp_Bono_Paciente, Comp_Bono_Plan) VALUES (@Fecha, @Usuario, @Plan)

	SET @Compra = @@IDENTITY

	SELECT @Valor = Plan_Precio_Bono_Consulta FROM Planes WHERE Plan_Codigo = @Plan

	WHILE (@i < @Cantidad)
		BEGIN

		EXEC CHAMBA.ObtenerNuevoIdBono @Numero OUT

		INSERT INTO Bonos (Bono_Numero, Bono_Compra, Bono_Valor) VALUES (@Numero, @Compra, @Valor)

		SET @i = @i + 1
		
		END
END
GO
/****** Object:  StoredProcedure [CHAMBA].[EliminarAfiliado]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CHAMBA].[EliminarAfiliado](@Afiliado numeric(18, 0), @Fecha datetime)

AS
BEGIN

UPDATE CHAMBA.Pacientes SET Paci_Fecha_Baja = @Fecha WHERE Paci_Numero = @Afiliado

END


GO
/****** Object:  StoredProcedure [CHAMBA].[EsAfiliado]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CHAMBA].[EsAfiliado] (@Usuario numeric(18, 0), @Rol numeric(18,0), @Resultado INT OUT)
AS
BEGIN
	DECLARE @Nombre varchar(255)
	SELECT @Nombre = Rol_Nombre FROM CHAMBA.Rol_X_Usuario JOIN CHAMBA.Roles ON Rol_X_Usua_Rol = Rol_Id WHERE Rol_X_Usua_Usuario = @Usuario AND Rol_X_Usua_Rol = @Rol

	IF (@Nombre = 'Afiliado')
		SET @Resultado = 1
	ELSE
		SET @Resultado = 0
END
GO
/****** Object:  StoredProcedure [CHAMBA].[EspecialidadesCanceladas]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CHAMBA].[EspecialidadesCanceladas] (@De varchar(255), @Semestre int, @Año int)
AS
BEGIN

IF (@De = 'Afiliado') 
	IF (@Semestre = 1)

		SELECT TOP 5 Espe_Descripcion AS  'Especialidad', COUNT(*) AS 'Cantidad' 

		FROM CHAMBA.Turnos 
			JOIN CHAMBA.Pacientes ON Turn_Paciente = Paci_Usuario 
			JOIN CHAMBA.Tipo_Especialidad ON Turn_Tipo_Especialidad = Tipo_Espe_Codigo 
			JOIN CHAMBA.Especialidades ON Espe_Codigo = Tipo_Espe_Especialidad 
		WHERE Turn_Canelado IS NOT NULL 
			AND YEAR(Turn_Fecha) = @Año
			AND MONTH(Turn_Fecha) <= 6
		GROUP BY Espe_Descripcion 
		ORDER BY COUNT(*)

	ELSE

		SELECT TOP 5 Espe_Descripcion AS  'Especialidad', COUNT(*) AS 'Cantidad' 

		FROM CHAMBA.Turnos 
			JOIN CHAMBA.Pacientes ON Turn_Paciente = Paci_Usuario 
			JOIN CHAMBA.Tipo_Especialidad ON Turn_Tipo_Especialidad = Tipo_Espe_Codigo 
			JOIN CHAMBA.Especialidades ON Espe_Codigo = Tipo_Espe_Especialidad 
		WHERE Turn_Canelado IS NOT NULL 
			AND YEAR(Turn_Fecha) = @Año
			AND MONTH(Turn_Fecha) > 6
		GROUP BY Espe_Descripcion 
		ORDER BY COUNT(*)
ELSE
	IF (@Semestre = 1)
		SELECT TOP 5 Espe_Descripcion AS  'Especialidad', COUNT(*) AS 'Cantidad' 

		FROM CHAMBA.Ausencia
			JOIN CHAMBA.Profesionales ON Ause_Profesional = Prof_Usuario
			JOIN CHAMBA.Tipo_Especialidad ON Ause_Tipo_Especialidad = Tipo_Espe_Codigo 
			JOIN CHAMBA.Especialidades ON Espe_Codigo = Tipo_Espe_Especialidad 
		WHERE YEAR(Ause_Fecha_Desde) = @Año
			AND MONTH(Ause_Fecha_Desde) <= 6
		GROUP BY Espe_Descripcion 
		ORDER BY COUNT(*)
	ELSE
		SELECT TOP 5 Espe_Descripcion AS  'Especialidad', COUNT(*) AS 'Cantidad' 

		FROM CHAMBA.Ausencia
			JOIN CHAMBA.Profesionales ON Ause_Profesional = Prof_Usuario
			JOIN CHAMBA.Tipo_Especialidad ON Ause_Tipo_Especialidad = Tipo_Espe_Codigo 
			JOIN CHAMBA.Especialidades ON Espe_Codigo = Tipo_Espe_Especialidad 
		WHERE YEAR(Ause_Fecha_Desde) = @Año
			AND MONTH(Ause_Fecha_Desde) > 6
		GROUP BY Espe_Descripcion 
		ORDER BY COUNT(*)
END
GO
/****** Object:  StoredProcedure [CHAMBA].[HistorialCambiosPlan]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CHAMBA].[HistorialCambiosPlan] (@Afiliado numeric(18, 0))
AS
BEGIN

DECLARE @IdUsuario numeric(18,0)

SELECT @IdUsuario = Paci_Usuario FROM CHAMBA.Pacientes WHERE Paci_Numero = @Afiliado

SELECT Camb_Plan_Fecha AS 'Fecha', (SELECT Plan_Descripcion FROM CHAMBA.Planes WHERE Plan_Codigo = Camb_Plan_Plan_Anterior) AS 'Plan anterior', (SELECT Plan_Descripcion FROM CHAMBA.Planes WHERE Plan_Codigo = Camb_Plan_Plan_Nuevo) AS 'Plan nuevo', Camb_Plan_Razon AS 'Razon' FROM CHAMBA.Cambio_Plan WHERE Camb_Plan_Paciente = @IdUsuario
RETURN 
END
GO
/****** Object:  StoredProcedure [CHAMBA].[ModificarAfiliado]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CHAMBA].[ModificarAfiliado](@Afiliado numeric(18, 0), @Nombre varchar(255), 
@Apellido varchar(255), @TipoDocumento numeric(3,0), @Documento numeric(18,0), 
@Domicilio varchar(255), @Telefono numeric(18,0), @Email varchar(255), @FechaNac datetime, 
@Sexo char(1), @EstadoCivil numeric(2,0), @CantHijos numeric(3,0), @Plan numeric(18,0))

AS
BEGIN

DECLARE @Existe INT

SELECT @Existe = COUNT(*) FROM CHAMBA.Pacientes WHERE Paci_Numero = @Afiliado

IF (@Existe = 0) 
BEGIN
	INSERT INTO CHAMBA.Usuarios (Usua_Nombre, Usua_Apellido, Usua_TipoDNI, Usua_DNI, Usua_Direccion, 
	Usua_Telefono, Usua_Mail, Usua_Fecha_Nac, Usua_Sexo, Usua_Usuario, Usua_Clave, Usua_Intentos) VALUES (@Nombre, @Apellido, @TipoDocumento, 
	@Documento, @Domicilio, @Telefono, @Email, @FechaNac, @Sexo, @Email, HASHBYTES('SHA2_256', CAST(@Documento AS VARCHAR(18))), 0)

	INSERT INTO CHAMBA.Pacientes (Paci_Usuario, Paci_Numero, Paci_Estado_Civil, Paci_Cant_Hijos, Paci_Plan) VALUES (@@IDENTITY, @Afiliado, @EstadoCivil, @CantHijos, @Plan)
END
ELSE
BEGIN
	DECLARE @IdUsuario numeric(18,0)
	SELECT @IdUsuario = Paci_Usuario FROM CHAMBA.Pacientes WHERE Paci_Numero = @Afiliado

	UPDATE CHAMBA.Usuarios SET Usua_Direccion = @Domicilio, Usua_Telefono = @Telefono, Usua_Mail = @Email,
	Usua_Fecha_Nac = @FechaNac, Usua_Sexo = @Sexo, Usua_Usuario = @Email WHERE Usua_Id = @IdUsuario

	UPDATE CHAMBA.Pacientes SET Paci_Estado_Civil = @EstadoCivil, Paci_Cant_Hijos = @CantHijos, Paci_Plan = @Plan WHERE Paci_Numero = @Afiliado
END




END


GO
/****** Object:  StoredProcedure [CHAMBA].[ModificarPlan]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CHAMBA].[ModificarPlan](@Afiliado numeric(18, 0), @NuevoPlan numeric(18,0), @Fecha datetime, @Razon varchar(255))
AS
BEGIN

DECLARE @IdUsuario numeric(18,0), @PlanAnterior numeric(18,0)
SELECT @IdUsuario = Paci_Usuario, @PlanAnterior = Paci_Plan FROM CHAMBA.Pacientes WHERE Paci_Numero = @Afiliado

IF (@PlanAnterior <> @NuevoPlan)
	INSERT INTO CHAMBA.Cambio_Plan (Camb_Plan_Paciente, Camb_Plan_Plan_Anterior, Camb_Plan_Plan_Nuevo, Camb_Plan_Fecha, Camb_Plan_Razon) VALUES (@IdUsuario, @PlanAnterior, @NuevoPlan, @Fecha, @Razon)

END
GO
/****** Object:  StoredProcedure [CHAMBA].[ObtenerNuevoIdBono]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CHAMBA].[ObtenerNuevoIdBono] (@id numeric(18, 0) OUT)
AS BEGIN
	DECLARE @Existe INT = 1

	SELECT @id = MAX(Bono_Numero) FROM CHAMBA.Bonos

	WHILE(@Existe <> 0)
		BEGIN
			SET @id = @id + 1
			SELECT @Existe = COUNT(*) FROM CHAMBA.Bonos WHERE Bono_Numero = @id
		END
END
GO
/****** Object:  StoredProcedure [CHAMBA].[ObtenerNuevoIdPaciente]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CHAMBA].[ObtenerNuevoIdPaciente] (@id numeric(18, 0) OUT)
AS BEGIN
	DECLARE @Existe INT = 1

	DECLARE @ultimo numeric(18, 0), @cadena varchar(18)

	SELECT @ultimo = MAX(Paci_Numero) FROM CHAMBA.Pacientes
	SET @cadena = CAST(@ultimo AS varchar(18))

	SET @ultimo = CAST(SUBSTRING(@cadena, 1, LEN(@cadena) - 2) AS numeric(16, 0))


	WHILE(@Existe <> 0)
		BEGIN
			SET @ultimo = @ultimo + 1
			SET @id = CAST(CAST(@ultimo AS varchar(16)) + '01' AS numeric(18, 0))
			SELECT @Existe = COUNT(*) FROM CHAMBA.Pacientes WHERE Paci_Numero = @id
		END

END

GO
/****** Object:  StoredProcedure [CHAMBA].[ObtenerPrecioDeBono]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CHAMBA].[ObtenerPrecioDeBono] (@Afiliado numeric(18, 0), @AfiliadoNombre varchar(510) OUT, @Cantidad INT, @Unitario NUMERIC(18,0) OUT, @Total NUMERIC(18,0) OUT)
AS
BEGIN

	SELECT @Unitario = Plan_Precio_Bono_Consulta, @AfiliadoNombre = Usua_Nombre + ' ' + Usua_Apellido FROM CHAMBA.Planes JOIN CHAMBA.Pacientes ON Plan_Codigo = Paci_Plan JOIN CHAMBA.Usuarios ON Paci_Usuario = Usua_Id WHERE Paci_Numero = @Afiliado

	SET @Total = @Cantidad * @Unitario

END
GO
/****** Object:  StoredProcedure [CHAMBA].[ObtenerProximoIdFamiliar]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CHAMBA].[ObtenerProximoIdFamiliar](@Afiliado numeric(16, 0), @id int OUT)
AS
BEGIN
	DECLARE @Existe INT = 1
	SET @id = 2 /* Tiene que empezar a buscar en 3 pero como despues hago un incremento empieza en 2 */

	WHILE(@Existe <> 0)
	BEGIN
		SET @id = @id + 1
		SELECT @Existe = COUNT(*) FROM CHAMBA.Pacientes WHERE Paci_Numero = CAST(CAST(@Afiliado as varchar(16)) + FORMAT(@id,'0#') AS numeric(18, 0))	
	END
END
GO
/****** Object:  StoredProcedure [CHAMBA].[TieneConyuge]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CHAMBA].[TieneConyuge](@Afiliado numeric(16, 0), @Existe int OUT)
AS
BEGIN
	BEGIN
		SELECT @Existe = COUNT(*) FROM CHAMBA.Pacientes WHERE Paci_Numero = CAST(CAST(@Afiliado as varchar(16)) + '02' AS numeric(18, 0))	
	END
END
GO
/****** Object:  StoredProcedure [CHAMBA].[VerificarLogin]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CHAMBA].[VerificarLogin] (@Usuario varchar(255), @Clave varchar(255), @MaxIntentos numeric(3,0), @Resultado INT OUT, @Id numeric(18,0) OUT)
AS
BEGIN
DECLARE @ClaveEncriptada varchar(255), @Intentos numeric(3,0)
SELECT @Id = Usua_Id, @ClaveEncriptada = Usua_Clave, @Intentos = Usua_Intentos FROM CHAMBA.Usuarios WHERE Usua_Usuario = @Usuario

SELECT @Resultado =
CASE 
	WHEN @Id IS NULL THEN 0
	WHEN @Intentos >= @MaxIntentos THEN 1
	WHEN @ClaveEncriptada <> HASHBYTES('SHA2_256', @Clave) THEN 2
	WHEN (SELECT COUNT(*) FROM CHAMBA.RolesActivos(@Id)) = 0 THEN 3
	ELSE 4
END


SELECT @Intentos = 
	CASE @Resultado
		WHEN 1 THEN @Intentos
		WHEN 2 THEN (@Intentos + 1)
		WHEN 3 THEN 0
		WHEN 4 THEN 0
	END

IF (@Resultado <> 0)
	UPDATE CHAMBA.Usuarios SET Usua_Intentos = @Intentos WHERE Usua_Id = @Id

RETURN
END



GO
/****** Object:  Table [CHAMBA].[Agenda]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CHAMBA].[Agenda](
	[Agen_Id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[Agen_Profesional] [numeric](18, 0) NOT NULL,
	[Agen_Dia] [numeric](1, 0) NULL,
	[Agen_Hora_Desde] [time](7) NULL,
	[Agen_Hora_Hasta] [time](7) NULL,
	[Agen_Tipo_Especialidad] [numeric](18, 0) NOT NULL,
 CONSTRAINT [PK_Rango_Horario] PRIMARY KEY CLUSTERED 
(
	[Agen_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [CHAMBA].[Ausencia]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CHAMBA].[Ausencia](
	[Ause_Id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[Ause_Profesional] [numeric](18, 0) NOT NULL,
	[Ause_Fecha_Desde] [date] NULL,
	[Ause_Fecha_Hasta] [date] NULL,
	[Ause_Razon] [varchar](255) NULL,
	[Ause_Tipo_Especialidad] [numeric](18, 0) NULL,
 CONSTRAINT [PK_Ausencia] PRIMARY KEY CLUSTERED 
(
	[Ause_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CHAMBA].[Bonos]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CHAMBA].[Bonos](
	[Bono_Numero] [numeric](18, 0) NOT NULL,
	[Bono_Estado] [numeric](3, 0) NULL,
	[Bono_Paciente_Uso] [numeric](18, 0) NULL,
	[Bono_Turno_Uso] [numeric](18, 0) NULL,
	[Bono_Compra] [numeric](18, 0) NULL,
	[Bono_Fecha_Impresion] [datetime] NULL,
	[Bono_Valor] [numeric](18, 0) NULL,
 CONSTRAINT [PK_Bono_Consulta] PRIMARY KEY CLUSTERED 
(
	[Bono_Numero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [CHAMBA].[Cambio_Plan]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CHAMBA].[Cambio_Plan](
	[Camb_Plan_Id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[Camb_Plan_Paciente] [numeric](18, 0) NOT NULL,
	[Camb_Plan_Plan_Anterior] [numeric](18, 0) NOT NULL,
	[Camb_Plan_Plan_Nuevo] [numeric](18, 0) NOT NULL,
	[Camb_Plan_Fecha] [datetime] NULL,
	[Camb_Plan_Razon] [varchar](255) NULL,
 CONSTRAINT [PK_Cambio_Plan] PRIMARY KEY CLUSTERED 
(
	[Camb_Plan_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CHAMBA].[Cancelaciones]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CHAMBA].[Cancelaciones](
	[Canc_Id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[Canc_Descripcion] [varchar](255) NULL,
	[Canc_Tipo] [numeric](1, 0) NULL,
 CONSTRAINT [PK_Cancelaciones] PRIMARY KEY CLUSTERED 
(
	[Canc_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CHAMBA].[Compra_Bonos]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CHAMBA].[Compra_Bonos](
	[Comp_Bono_Id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[Comp_Bono_Fecha] [datetime] NULL,
	[Comp_Bono_Plan] [numeric](18, 0) NOT NULL,
	[Comp_Bono_Paciente] [numeric](18, 0) NOT NULL,
 CONSTRAINT [PK_Compra_Bono] PRIMARY KEY CLUSTERED 
(
	[Comp_Bono_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [CHAMBA].[Consultas]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CHAMBA].[Consultas](
	[Cons_Turno] [numeric](18, 0) NOT NULL,
	[Cons_Sintoma] [varchar](255) NULL,
	[Cons_Diagnostico] [varchar](255) NULL,
 CONSTRAINT [PK_Consultas] PRIMARY KEY CLUSTERED 
(
	[Cons_Turno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CHAMBA].[Especialidades]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CHAMBA].[Especialidades](
	[Espe_Codigo] [numeric](18, 0) NOT NULL,
	[Espe_Descripcion] [varchar](255) NULL,
 CONSTRAINT [PK_Especialidades] PRIMARY KEY CLUSTERED 
(
	[Espe_Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CHAMBA].[Funcionalidad_X_Rol]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CHAMBA].[Funcionalidad_X_Rol](
	[Func_X_Rol_Rol] [numeric](18, 0) NOT NULL,
	[Func_X_Rol_Funcionalidad] [numeric](18, 0) NOT NULL,
 CONSTRAINT [PK_Funcionalidad_X_Rol] PRIMARY KEY CLUSTERED 
(
	[Func_X_Rol_Rol] ASC,
	[Func_X_Rol_Funcionalidad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [CHAMBA].[Funcionalidades]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CHAMBA].[Funcionalidades](
	[Func_Id] [numeric](18, 0) NOT NULL,
	[Func_Descripcion] [varchar](255) NULL,
 CONSTRAINT [PK_Funcionalidades] PRIMARY KEY CLUSTERED 
(
	[Func_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CHAMBA].[Pacientes]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CHAMBA].[Pacientes](
	[Paci_Usuario] [numeric](18, 0) NOT NULL,
	[Paci_Numero] [numeric](18, 0) NULL,
	[Paci_Estado_Civil] [numeric](2, 0) NULL,
	[Paci_Cant_Hijos] [numeric](3, 0) NULL,
	[Paci_Plan] [numeric](18, 0) NOT NULL,
	[Paci_Fecha_Baja] [datetime] NULL,
 CONSTRAINT [PK_Pacientes] PRIMARY KEY CLUSTERED 
(
	[Paci_Usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [CHAMBA].[Planes]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CHAMBA].[Planes](
	[Plan_Codigo] [numeric](18, 0) NOT NULL,
	[Plan_Descripcion] [varchar](255) NULL,
	[Plan_Precio_Bono_Consulta] [numeric](18, 0) NULL,
	[Plan_Precio_Bono_Farmacia] [numeric](18, 0) NULL,
 CONSTRAINT [PK_Planes] PRIMARY KEY CLUSTERED 
(
	[Plan_Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CHAMBA].[Profesionales]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CHAMBA].[Profesionales](
	[Prof_Usuario] [numeric](18, 0) NOT NULL,
	[Prof_Matricula] [numeric](18, 0) NULL,
 CONSTRAINT [PK_Profesionales] PRIMARY KEY CLUSTERED 
(
	[Prof_Usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [CHAMBA].[Rol_X_Usuario]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CHAMBA].[Rol_X_Usuario](
	[Rol_X_Usua_Usuario] [numeric](18, 0) NOT NULL,
	[Rol_X_Usua_Rol] [numeric](18, 0) NOT NULL,
 CONSTRAINT [PK_Rol_X_Usuario] PRIMARY KEY CLUSTERED 
(
	[Rol_X_Usua_Usuario] ASC,
	[Rol_X_Usua_Rol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [CHAMBA].[Roles]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CHAMBA].[Roles](
	[Rol_Id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[Rol_Nombre] [varchar](255) NULL,
	[Rol_Estado] [numeric](3, 0) NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[Rol_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CHAMBA].[Tipo_Especialidad]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CHAMBA].[Tipo_Especialidad](
	[Tipo_Espe_Codigo] [numeric](18, 0) NOT NULL,
	[Tipo_Espe_Descripcion] [varchar](255) NULL,
	[Tipo_Espe_Especialidad] [numeric](18, 0) NOT NULL,
 CONSTRAINT [PK_Tipo_Especialidad] PRIMARY KEY CLUSTERED 
(
	[Tipo_Espe_Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CHAMBA].[Tipo_Especialidad_X_Profesional]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CHAMBA].[Tipo_Especialidad_X_Profesional](
	[Tipo_Espec_X_Prof_Profesional] [numeric](18, 0) NOT NULL,
	[Tipo_Espec_X_Pof_Tipo_Especialidad] [numeric](18, 0) NOT NULL,
 CONSTRAINT [PK_Especialidad_X_Profesional] PRIMARY KEY CLUSTERED 
(
	[Tipo_Espec_X_Prof_Profesional] ASC,
	[Tipo_Espec_X_Pof_Tipo_Especialidad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [CHAMBA].[Turnos]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CHAMBA].[Turnos](
	[Turn_Numero] [numeric](18, 0) NOT NULL,
	[Turn_Fecha] [datetime] NULL,
	[Turn_Paciente] [numeric](18, 0) NOT NULL,
	[Turn_Profesional] [numeric](18, 0) NOT NULL,
	[Turn_Estado] [numeric](3, 0) NULL,
	[Turn_Fecha_Llegada] [datetime] NULL,
	[Turn_Canelado] [numeric](18, 0) NULL,
	[Turn_Tipo_Especialidad] [numeric](18, 0) NULL,
 CONSTRAINT [PK_Turnos] PRIMARY KEY CLUSTERED 
(
	[Turn_Numero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [CHAMBA].[Usuarios]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CHAMBA].[Usuarios](
	[Usua_Id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[Usua_DNI] [numeric](18, 0) NULL,
	[Usua_TipoDNI] [numeric](3, 0) NULL,
	[Usua_Nombre] [varchar](255) NULL,
	[Usua_Apellido] [varchar](255) NULL,
	[Usua_Direccion] [varchar](255) NULL,
	[Usua_Telefono] [numeric](18, 0) NULL,
	[Usua_Mail] [varchar](255) NULL,
	[Usua_Fecha_Nac] [datetime] NULL,
	[Usua_Sexo] [char](1) NULL,
	[Usua_Usuario] [varchar](255) NULL,
	[Usua_Clave] [varchar](255) NULL,
	[Usua_Intentos] [numeric](3, 0) NULL,
 CONSTRAINT [PK_Usuarios] PRIMARY KEY CLUSTERED 
(
	[Usua_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  UserDefinedFunction [CHAMBA].[RolesActivos]    Script Date: 10/10/2016 1:16:36 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [CHAMBA].[RolesActivos](@Id numeric(18,0))
RETURNS TABLE
AS

RETURN (SELECT Rol_Id, Rol_Nombre
FROM CHAMBA.Rol_X_Usuario JOIN CHAMBA.Pacientes ON Rol_X_Usua_Usuario = Paci_Usuario JOIN CHAMBA.Roles ON Rol_Id = Rol_X_Usua_Rol
WHERE Rol_X_Usua_Usuario = @Id AND Rol_Estado = 1 AND Paci_Fecha_Baja IS NULL

UNION 

SELECT Rol_Id, Rol_Nombre
FROM CHAMBA.Rol_X_Usuario JOIN CHAMBA.Roles ON Rol_Id = Rol_X_Usua_Rol
WHERE Rol_X_Usua_Usuario = @Id AND (SELECT COUNT(*) FROM CHAMBA.Pacientes WHERE Paci_Usuario = @Id) = 0 AND Rol_Estado = 1)



GO
ALTER TABLE [CHAMBA].[Agenda]  WITH CHECK ADD  CONSTRAINT [FK_Agenda_Profesionales] FOREIGN KEY([Agen_Profesional])
REFERENCES [CHAMBA].[Profesionales] ([Prof_Usuario])
GO
ALTER TABLE [CHAMBA].[Agenda] CHECK CONSTRAINT [FK_Agenda_Profesionales]
GO
ALTER TABLE [CHAMBA].[Agenda]  WITH CHECK ADD  CONSTRAINT [FK_Agenda_Tipo_Especialidad] FOREIGN KEY([Agen_Tipo_Especialidad])
REFERENCES [CHAMBA].[Tipo_Especialidad] ([Tipo_Espe_Codigo])
GO
ALTER TABLE [CHAMBA].[Agenda] CHECK CONSTRAINT [FK_Agenda_Tipo_Especialidad]
GO
ALTER TABLE [CHAMBA].[Ausencia]  WITH CHECK ADD  CONSTRAINT [FK_Ausencia_Profesionales] FOREIGN KEY([Ause_Profesional])
REFERENCES [CHAMBA].[Profesionales] ([Prof_Usuario])
GO
ALTER TABLE [CHAMBA].[Ausencia] CHECK CONSTRAINT [FK_Ausencia_Profesionales]
GO
ALTER TABLE [CHAMBA].[Ausencia]  WITH CHECK ADD  CONSTRAINT [FK_Ausencia_Tipo_Especialidad] FOREIGN KEY([Ause_Tipo_Especialidad])
REFERENCES [CHAMBA].[Tipo_Especialidad] ([Tipo_Espe_Codigo])
GO
ALTER TABLE [CHAMBA].[Ausencia] CHECK CONSTRAINT [FK_Ausencia_Tipo_Especialidad]
GO
ALTER TABLE [CHAMBA].[Bonos]  WITH CHECK ADD  CONSTRAINT [FK_Bonos_Compra_Bonos] FOREIGN KEY([Bono_Compra])
REFERENCES [CHAMBA].[Compra_Bonos] ([Comp_Bono_Id])
GO
ALTER TABLE [CHAMBA].[Bonos] CHECK CONSTRAINT [FK_Bonos_Compra_Bonos]
GO
ALTER TABLE [CHAMBA].[Bonos]  WITH CHECK ADD  CONSTRAINT [FK_Bonos_Consulta_Turno] FOREIGN KEY([Bono_Turno_Uso])
REFERENCES [CHAMBA].[Turnos] ([Turn_Numero])
GO
ALTER TABLE [CHAMBA].[Bonos] CHECK CONSTRAINT [FK_Bonos_Consulta_Turno]
GO
ALTER TABLE [CHAMBA].[Bonos]  WITH CHECK ADD  CONSTRAINT [FK_Bonos_Pacientes] FOREIGN KEY([Bono_Paciente_Uso])
REFERENCES [CHAMBA].[Pacientes] ([Paci_Usuario])
GO
ALTER TABLE [CHAMBA].[Bonos] CHECK CONSTRAINT [FK_Bonos_Pacientes]
GO
ALTER TABLE [CHAMBA].[Cambio_Plan]  WITH CHECK ADD  CONSTRAINT [FK_Cambio_Plan_Pacientes] FOREIGN KEY([Camb_Plan_Paciente])
REFERENCES [CHAMBA].[Pacientes] ([Paci_Usuario])
GO
ALTER TABLE [CHAMBA].[Cambio_Plan] CHECK CONSTRAINT [FK_Cambio_Plan_Pacientes]
GO
ALTER TABLE [CHAMBA].[Cambio_Plan]  WITH CHECK ADD  CONSTRAINT [FK_Cambio_Plan_Plan] FOREIGN KEY([Camb_Plan_Plan_Anterior])
REFERENCES [CHAMBA].[Planes] ([Plan_Codigo])
GO
ALTER TABLE [CHAMBA].[Cambio_Plan] CHECK CONSTRAINT [FK_Cambio_Plan_Plan]
GO
ALTER TABLE [CHAMBA].[Cambio_Plan]  WITH CHECK ADD  CONSTRAINT [FK_Cambio_Plan_Plan1] FOREIGN KEY([Camb_Plan_Plan_Nuevo])
REFERENCES [CHAMBA].[Planes] ([Plan_Codigo])
GO
ALTER TABLE [CHAMBA].[Cambio_Plan] CHECK CONSTRAINT [FK_Cambio_Plan_Plan1]
GO
ALTER TABLE [CHAMBA].[Compra_Bonos]  WITH CHECK ADD  CONSTRAINT [FK_Compra_Bono_Plan] FOREIGN KEY([Comp_Bono_Plan])
REFERENCES [CHAMBA].[Planes] ([Plan_Codigo])
GO
ALTER TABLE [CHAMBA].[Compra_Bonos] CHECK CONSTRAINT [FK_Compra_Bono_Plan]
GO
ALTER TABLE [CHAMBA].[Compra_Bonos]  WITH CHECK ADD  CONSTRAINT [FK_Compra_Bonos_Pacientes] FOREIGN KEY([Comp_Bono_Paciente])
REFERENCES [CHAMBA].[Pacientes] ([Paci_Usuario])
GO
ALTER TABLE [CHAMBA].[Compra_Bonos] CHECK CONSTRAINT [FK_Compra_Bonos_Pacientes]
GO
ALTER TABLE [CHAMBA].[Consultas]  WITH CHECK ADD  CONSTRAINT [FK_Consultas_Turnos] FOREIGN KEY([Cons_Turno])
REFERENCES [CHAMBA].[Turnos] ([Turn_Numero])
GO
ALTER TABLE [CHAMBA].[Consultas] CHECK CONSTRAINT [FK_Consultas_Turnos]
GO
ALTER TABLE [CHAMBA].[Funcionalidad_X_Rol]  WITH CHECK ADD  CONSTRAINT [FK_Funcionalidad_X_Rol_Funcionalidad] FOREIGN KEY([Func_X_Rol_Funcionalidad])
REFERENCES [CHAMBA].[Funcionalidades] ([Func_Id])
GO
ALTER TABLE [CHAMBA].[Funcionalidad_X_Rol] CHECK CONSTRAINT [FK_Funcionalidad_X_Rol_Funcionalidad]
GO
ALTER TABLE [CHAMBA].[Funcionalidad_X_Rol]  WITH CHECK ADD  CONSTRAINT [FK_Funcionalidad_X_Rol_Rol] FOREIGN KEY([Func_X_Rol_Rol])
REFERENCES [CHAMBA].[Roles] ([Rol_Id])
GO
ALTER TABLE [CHAMBA].[Funcionalidad_X_Rol] CHECK CONSTRAINT [FK_Funcionalidad_X_Rol_Rol]
GO
ALTER TABLE [CHAMBA].[Pacientes]  WITH CHECK ADD  CONSTRAINT [FK_Paciente_Plan] FOREIGN KEY([Paci_Plan])
REFERENCES [CHAMBA].[Planes] ([Plan_Codigo])
GO
ALTER TABLE [CHAMBA].[Pacientes] CHECK CONSTRAINT [FK_Paciente_Plan]
GO
ALTER TABLE [CHAMBA].[Pacientes]  WITH CHECK ADD  CONSTRAINT [FK_Pacientes_Usuarios] FOREIGN KEY([Paci_Usuario])
REFERENCES [CHAMBA].[Usuarios] ([Usua_Id])
GO
ALTER TABLE [CHAMBA].[Pacientes] CHECK CONSTRAINT [FK_Pacientes_Usuarios]
GO
ALTER TABLE [CHAMBA].[Profesionales]  WITH CHECK ADD  CONSTRAINT [FK_Profesionales_Usuarios] FOREIGN KEY([Prof_Usuario])
REFERENCES [CHAMBA].[Usuarios] ([Usua_Id])
GO
ALTER TABLE [CHAMBA].[Profesionales] CHECK CONSTRAINT [FK_Profesionales_Usuarios]
GO
ALTER TABLE [CHAMBA].[Rol_X_Usuario]  WITH CHECK ADD  CONSTRAINT [FK_Rol_X_Usuario_Rol] FOREIGN KEY([Rol_X_Usua_Rol])
REFERENCES [CHAMBA].[Roles] ([Rol_Id])
GO
ALTER TABLE [CHAMBA].[Rol_X_Usuario] CHECK CONSTRAINT [FK_Rol_X_Usuario_Rol]
GO
ALTER TABLE [CHAMBA].[Rol_X_Usuario]  WITH CHECK ADD  CONSTRAINT [FK_Rol_X_Usuario_Usuarios] FOREIGN KEY([Rol_X_Usua_Usuario])
REFERENCES [CHAMBA].[Usuarios] ([Usua_Id])
GO
ALTER TABLE [CHAMBA].[Rol_X_Usuario] CHECK CONSTRAINT [FK_Rol_X_Usuario_Usuarios]
GO
ALTER TABLE [CHAMBA].[Tipo_Especialidad]  WITH CHECK ADD  CONSTRAINT [FK_Tipo_Especialidad_Especialidad] FOREIGN KEY([Tipo_Espe_Especialidad])
REFERENCES [CHAMBA].[Especialidades] ([Espe_Codigo])
GO
ALTER TABLE [CHAMBA].[Tipo_Especialidad] CHECK CONSTRAINT [FK_Tipo_Especialidad_Especialidad]
GO
ALTER TABLE [CHAMBA].[Tipo_Especialidad_X_Profesional]  WITH CHECK ADD  CONSTRAINT [FK_Tipo_Especialidad_X_Profesional_Profesionales] FOREIGN KEY([Tipo_Espec_X_Prof_Profesional])
REFERENCES [CHAMBA].[Profesionales] ([Prof_Usuario])
GO
ALTER TABLE [CHAMBA].[Tipo_Especialidad_X_Profesional] CHECK CONSTRAINT [FK_Tipo_Especialidad_X_Profesional_Profesionales]
GO
ALTER TABLE [CHAMBA].[Tipo_Especialidad_X_Profesional]  WITH CHECK ADD  CONSTRAINT [FK_Tipo_Especialidad_X_Profesional_Tipo_Especialidad] FOREIGN KEY([Tipo_Espec_X_Pof_Tipo_Especialidad])
REFERENCES [CHAMBA].[Tipo_Especialidad] ([Tipo_Espe_Codigo])
GO
ALTER TABLE [CHAMBA].[Tipo_Especialidad_X_Profesional] CHECK CONSTRAINT [FK_Tipo_Especialidad_X_Profesional_Tipo_Especialidad]
GO
ALTER TABLE [CHAMBA].[Turnos]  WITH CHECK ADD  CONSTRAINT [FK_Turnos_Cancelaciones] FOREIGN KEY([Turn_Canelado])
REFERENCES [CHAMBA].[Cancelaciones] ([Canc_Id])
GO
ALTER TABLE [CHAMBA].[Turnos] CHECK CONSTRAINT [FK_Turnos_Cancelaciones]
GO
ALTER TABLE [CHAMBA].[Turnos]  WITH CHECK ADD  CONSTRAINT [FK_Turnos_Pacientes] FOREIGN KEY([Turn_Paciente])
REFERENCES [CHAMBA].[Pacientes] ([Paci_Usuario])
GO
ALTER TABLE [CHAMBA].[Turnos] CHECK CONSTRAINT [FK_Turnos_Pacientes]
GO
ALTER TABLE [CHAMBA].[Turnos]  WITH CHECK ADD  CONSTRAINT [FK_Turnos_Profesionales] FOREIGN KEY([Turn_Profesional])
REFERENCES [CHAMBA].[Profesionales] ([Prof_Usuario])
GO
ALTER TABLE [CHAMBA].[Turnos] CHECK CONSTRAINT [FK_Turnos_Profesionales]
GO
ALTER TABLE [CHAMBA].[Turnos]  WITH CHECK ADD  CONSTRAINT [FK_Turnos_Tipo_Especialidad1] FOREIGN KEY([Turn_Tipo_Especialidad])
REFERENCES [CHAMBA].[Tipo_Especialidad] ([Tipo_Espe_Codigo])
GO
ALTER TABLE [CHAMBA].[Turnos] CHECK CONSTRAINT [FK_Turnos_Tipo_Especialidad1]
GO
