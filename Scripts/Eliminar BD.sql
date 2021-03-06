DROP TABLE CHAMBA.Bonos
DROP TABLE CHAMBA.Cambio_Plan
DROP TABLE CHAMBA.Compra_Bonos
DROP TABLE CHAMBA.Consultas
DROP TABLE CHAMBA.Funcionalidad_X_Rol
DROP TABLE CHAMBA.Funcionalidades
DROP TABLE CHAMBA.Rol_X_Usuario
DROP TABLE CHAMBA.Roles
DROP TABLE CHAMBA.Tipo_Especialidad_X_Profesional
DROP TABLE CHAMBA.Turnos
DROP TABLE CHAMBA.Agenda
DROP TABLE CHAMBA.Cancelaciones
DROP TABLE CHAMBA.Pacientes
DROP TABLE CHAMBA.Profesionales
DROP TABLE CHAMBA.Planes
DROP TABLE CHAMBA.Usuarios
DROP TABLE CHAMBA.Tipo_Especialidad
DROP TABLE CHAMBA.Especialidades

DROP PROCEDURE CHAMBA.AfiliadosBonos
DROP PROCEDURE CHAMBA.AsignarFuncionalidad
DROP PROCEDURE CHAMBA.CargarAfiliados
DROP PROCEDURE CHAMBA.CargarTurnos
DROP PROCEDURE CHAMBA.ComprarBonos
DROP PROCEDURE CHAMBA.CargarBonosParaTurno
DROP PROCEDURE CHAMBA.CargarFuncionalidades
DROP PROCEDURE CHAMBA.CargarRoles
DROP PROCEDURE CHAMBA.CargarRolesHabilitados
DROP PROCEDURE CHAMBA.CrearRolNuevo
DROP PROCEDURE CHAMBA.EliminarAfiliado
DROP PROCEDURE CHAMBA.EliminarFuncionalidades
DROP PROCEDURE CHAMBA.EspecialidadesBonos
DROP PROCEDURE CHAMBA.EspecialidadesCanceladas
DROP PROCEDURE CHAMBA.EsAfiliado
DROP PROCEDURE CHAMBA.ExisteRol
DROP PROCEDURE CHAMBA.FuncionalidadesPorRol
DROP PROCEDURE CHAMBA.HabilitarRol
DROP PROCEDURE CHAMBA.HistorialCambiosPlan
DROP PROCEDURE CHAMBA.InhabilitarRol
DROP PROCEDURE CHAMBA.InhabilitarRolPorUsuario
DROP PROCEDURE CHAMBA.ModificarAfiliado
DROP PROCEDURE CHAMBA.ModificarPlan
DROP PROCEDURE CHAMBA.ModificarNombreRol
DROP PROCEDURE CHAMBA.ObtenerFuncionalidadId
DROP PROCEDURE CHAMBA.ObtenerNuevoIdBono
DROP PROCEDURE CHAMBA.ObtenerNuevoIdPaciente
DROP PROCEDURE CHAMBA.ObtenerPrecioDeBono
DROP PROCEDURE CHAMBA.ObtenerProximoIdFamiliar
DROP PROCEDURE CHAMBA.ObtenerRolId
DROP PROCEDURE CHAMBA.ProfesionalesConsultados
DROP PROCEDURE CHAMBA.ProfesionalesHoras
DROP PROCEDURE CHAMBA.RegistrarLlegada
DROP PROCEDURE CHAMBa.RolHabilitado
DROP PROCEDURE CHAMBA.TieneConyuge
DROP PROCEDURE CHAMBA.VerificarLogin


DROP PROCEDURE CHAMBA.AGREGAR_DISPONIBILIDAD_EN_AGENDA
DROP PROCEDURE CHAMBA.PROFESIONALES_POR_ESPECIALIDAD
DROP PROCEDURE CHAMBA.DIAS_DISPONIBLES_PROFESIONAL_POR_ESPECIALIDAD
DROP PROCEDURE CHAMBA.HORARIOS_DISPONIBLES_EN_AGENDA_PROFESIONAL
DROP PROCEDURE CHAMBA.RESERVA_DE_TURNO
DROP PROCEDURE CHAMBA.OBTENER_NUEVO_ID_TURNO

DROP PROCEDURE CHAMBA.TurnosCancelablesPorPaciente
DROP PROCEDURE CHAMBA.PacienteCancelaTurno
DROP PROCEDURE CHAMBA.PosiblesPacientes
DROP PROCEDURE CHAMBA.RegistrarAtencion
DROP PROCEDURE CHAMBA.ProfesionalCancelaTurno

DROP FUNCTION CHAMBA.RolesActivos

DROP PROCEDURE CHAMBA.Migracion

DROP SCHEMA CHAMBA