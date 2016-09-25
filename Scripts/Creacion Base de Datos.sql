USE [GD2C2016]
GO
/****** Object:  Schema [CHAMBA]    Script Date: 25/9/2016 12:18:12 a. m. ******/
CREATE SCHEMA [CHAMBA]
GO
/****** Object:  Table [CHAMBA].[Agenda]    Script Date: 25/9/2016 12:18:12 a. m. ******/
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
	[Agen_Estado] [numeric](3, 0) NULL,
	[Agen_Cancelado] [numeric](18, 0) NULL,
 CONSTRAINT [PK_Rango_Horario] PRIMARY KEY CLUSTERED 
(
	[Agen_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [CHAMBA].[Bonos]    Script Date: 25/9/2016 12:18:12 a. m. ******/
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
/****** Object:  Table [CHAMBA].[Cambio_Plan]    Script Date: 25/9/2016 12:18:12 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CHAMBA].[Cambio_Plan](
	[Camb_Plan_Id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[Camb_Plan_Paciente] [numeric](18, 0) NOT NULL,
	[Camb_Plan_Plan_Anterior] [numeric](18, 0) NOT NULL,
	[Camb_Plan_Plan_Nuevo] [numeric](18, 0) NOT NULL,
	[Camb_Plan_Fecha] [datetime] NULL,
 CONSTRAINT [PK_Cambio_Plan] PRIMARY KEY CLUSTERED 
(
	[Camb_Plan_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [CHAMBA].[Cancelaciones]    Script Date: 25/9/2016 12:18:12 a. m. ******/
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
/****** Object:  Table [CHAMBA].[Compra_Bonos]    Script Date: 25/9/2016 12:18:12 a. m. ******/
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
/****** Object:  Table [CHAMBA].[Consultas]    Script Date: 25/9/2016 12:18:12 a. m. ******/
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
/****** Object:  Table [CHAMBA].[Especialidades]    Script Date: 25/9/2016 12:18:12 a. m. ******/
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
/****** Object:  Table [CHAMBA].[Funcionalidad_X_Rol]    Script Date: 25/9/2016 12:18:12 a. m. ******/
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
/****** Object:  Table [CHAMBA].[Funcionalidades]    Script Date: 25/9/2016 12:18:12 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CHAMBA].[Funcionalidades](
	[Func_Id] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[Func_Descripcion] [varchar](255) NULL,
 CONSTRAINT [PK_Funcionalidades] PRIMARY KEY CLUSTERED 
(
	[Func_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CHAMBA].[Pacientes]    Script Date: 25/9/2016 12:18:12 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [CHAMBA].[Pacientes](
	[Paci_Usuario] [numeric](18, 0) NOT NULL,
	[Paci_Numero] [numeric](18, 0) NULL,
	[Paci_Estado_Civil] [varchar](50) NULL,
	[Paci_Cant_Hijos] [numeric](3, 0) NULL,
	[Paci_Plan] [numeric](18, 0) NOT NULL,
	[Paci_Fecha_Baja] [datetime] NULL,
	[Paci_Rol] [numeric](18, 0) NULL,
 CONSTRAINT [PK_Pacientes] PRIMARY KEY CLUSTERED 
(
	[Paci_Usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [CHAMBA].[Planes]    Script Date: 25/9/2016 12:18:12 a. m. ******/
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
/****** Object:  Table [CHAMBA].[Profesionales]    Script Date: 25/9/2016 12:18:12 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CHAMBA].[Profesionales](
	[Prof_Usuario] [numeric](18, 0) NOT NULL,
	[Prof_Matricula] [numeric](18, 0) NULL,
	[Prof_Rol] [numeric](18, 0) NULL,
 CONSTRAINT [PK_Profesionales] PRIMARY KEY CLUSTERED 
(
	[Prof_Usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [CHAMBA].[Rol_X_Usuario]    Script Date: 25/9/2016 12:18:12 a. m. ******/
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
/****** Object:  Table [CHAMBA].[Roles]    Script Date: 25/9/2016 12:18:12 a. m. ******/
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
/****** Object:  Table [CHAMBA].[Tipo_Especialidad]    Script Date: 25/9/2016 12:18:12 a. m. ******/
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
/****** Object:  Table [CHAMBA].[Tipo_Especialidad_X_Profesional]    Script Date: 25/9/2016 12:18:12 a. m. ******/
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
/****** Object:  Table [CHAMBA].[Turnos]    Script Date: 25/9/2016 12:18:12 a. m. ******/
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
 CONSTRAINT [PK_Turnos] PRIMARY KEY CLUSTERED 
(
	[Turn_Numero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [CHAMBA].[Usuarios]    Script Date: 25/9/2016 12:18:12 a. m. ******/
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
ALTER TABLE [CHAMBA].[Agenda]  WITH CHECK ADD  CONSTRAINT [FK_Agenda_Cancelaciones] FOREIGN KEY([Agen_Cancelado])
REFERENCES [CHAMBA].[Cancelaciones] ([Canc_Id])
GO
ALTER TABLE [CHAMBA].[Agenda] CHECK CONSTRAINT [FK_Agenda_Cancelaciones]
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
ALTER TABLE [CHAMBA].[Pacientes]  WITH CHECK ADD  CONSTRAINT [FK_Pacientes_Roles] FOREIGN KEY([Paci_Rol])
REFERENCES [CHAMBA].[Roles] ([Rol_Id])
GO
ALTER TABLE [CHAMBA].[Pacientes] CHECK CONSTRAINT [FK_Pacientes_Roles]
GO
ALTER TABLE [CHAMBA].[Pacientes]  WITH CHECK ADD  CONSTRAINT [FK_Pacientes_Usuarios] FOREIGN KEY([Paci_Usuario])
REFERENCES [CHAMBA].[Usuarios] ([Usua_Id])
GO
ALTER TABLE [CHAMBA].[Pacientes] CHECK CONSTRAINT [FK_Pacientes_Usuarios]
GO
ALTER TABLE [CHAMBA].[Profesionales]  WITH CHECK ADD  CONSTRAINT [FK_Profesionales_Roles] FOREIGN KEY([Prof_Rol])
REFERENCES [CHAMBA].[Roles] ([Rol_Id])
GO
ALTER TABLE [CHAMBA].[Profesionales] CHECK CONSTRAINT [FK_Profesionales_Roles]
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
