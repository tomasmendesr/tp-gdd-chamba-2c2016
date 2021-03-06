﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ClinicaFrba.Registro_Llegada
{
    public partial class FormRegistroLlegada : Form
    {
        SqlConnection conexion;
        bool especialidadesCargadas = false;
        bool profesionalesCargados = false;
        public FormRegistroLlegada()
        {
            InitializeComponent();
            conexion = new SqlConnection(@Configuraciones.datosConexion);    
            conexion.Open();

            String query = "SELECT Espe_Descripcion, Espe_Codigo FROM CHAMBA.Especialidades ORDER BY Espe_Descripcion";

            SqlCommand listar = new SqlCommand(query, conexion);

            DataTable tabla = new DataTable();
            SqlDataAdapter adapter = new SqlDataAdapter();
            adapter.SelectCommand = listar;
            adapter.Fill(tabla);

            conexion.Close();

            cboEspecialidad.DataSource = tabla;
            cboEspecialidad.DisplayMember = "Espe_Descripcion";
            cboEspecialidad.ValueMember = "Espe_Codigo";

            especialidadesCargadas = true;
            cargarProfesionales();
        }

        private void FormRegistroLlegada_Load(object sender, EventArgs e)
        {
                    
        }

        private void cboProfesional_SelectedIndexChanged(object sender, EventArgs e)
        {
            cargarTurnos();
        }

        private void cboEspecialidad_SelectedIndexChanged(object sender, EventArgs e)
        {
            cargarProfesionales();
            
        }

        private void cargarProfesionales()
        {
            if (cboEspecialidad.Text != "" && especialidadesCargadas)
            {
                conexion.Open();

                String query = "SELECT (Usua_Nombre + ' ' + Usua_Apellido) AS Nombre, Prof_Usuario " +
                    "FROM CHAMBA.Usuarios " +
                    "JOIN CHAMBA.Profesionales ON Usua_Id = Prof_Usuario " +
                    "JOIN CHAMBA.Tipo_Especialidad_X_Profesional ON Tipo_Espe_X_Prof_Profesional = Prof_Usuario " +
                    "JOIN CHAMBA.Tipo_Especialidad ON Tipo_Espe_Codigo = Tipo_Espe_X_Prof_Tipo_Especialidad " +
                    "WHERE Tipo_Espe_Especialidad = " + cboEspecialidad.SelectedValue + " UNION SELECT 'Todos', 0";
                SqlCommand listar = new SqlCommand(query, conexion);

                DataTable tabla = new DataTable();
                SqlDataAdapter adapter = new SqlDataAdapter();
                adapter.SelectCommand = listar;
                adapter.Fill(tabla);

                conexion.Close();

                cboProfesional.DataSource = tabla;
                cboProfesional.DisplayMember = "Nombre";
                cboProfesional.ValueMember = "Prof_Usuario";

                profesionalesCargados = true;
                cargarTurnos();
            }
        }

        private void cargarTurnos()
        {
            if (profesionalesCargados && cboProfesional.Text != "")
            {
                conexion.Open();
                SqlCommand cargar = new SqlCommand("CHAMBA.CargarTurnos", conexion);
                cargar.CommandType = CommandType.StoredProcedure;
                cargar.Parameters.Add("@Profesional", SqlDbType.Decimal).Value = cboProfesional.SelectedValue;
                cargar.Parameters.Add("@Especialidad", SqlDbType.Decimal).Value = cboEspecialidad.SelectedValue;
                cargar.Parameters.Add("@Fecha", SqlDbType.DateTime).Value = Configuraciones.fecha;
                SqlDataAdapter adapter = new SqlDataAdapter(cargar);
                DataTable table = new DataTable();
                adapter.Fill(table);
                dataGridView1.DataSource = table;
                conexion.Close();
            }
        }


        private void btnRegistrar_Click(object sender, EventArgs e)
        {
            if (dataGridView1.SelectedRows.Count == 1)
            {
                FormSeleccionarBono form = new FormSeleccionarBono();
                form.cargarBonos(decimal.Parse(dataGridView1.SelectedRows[0].Cells[0].Value.ToString()));
                if (form.DialogResult == DialogResult.OK)
                    cargarTurnos();
            }
            else
            {
                MessageBox.Show("Seleccione un turno");
            }
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
        }
    }
}
