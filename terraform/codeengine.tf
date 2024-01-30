data "ibm_resource_group" "pg_resource_group" {
  name = "Default"
}

resource "ibm_code_engine_project" "pgadmin_code_engine" {
  name = "pgadmin-code-engine-project10"
  resource_group_id = data.ibm_resource_group.pg_resource_group.id
}


resource "ibm_code_engine_app" "pgadmin_app" {
  project_id      = ibm_code_engine_project.pgadmin_code_engine.project_id
  name            = "pgadmin-app"
  image_reference = "dpage/pgadmin4:latest"
  scale_min_instances = 1
  scale_max_instances = 1

  run_env_variables {
    type  = "literal"
    name  = "PGADMIN_DEFAULT_EMAIL"
    value = var.pg_admin_username
  }
  run_env_variables {
    type  = "literal"
    name  = "PGADMIN_DEFAULT_PASSWORD"
    value = var.pg_admin_password
  }
    run_env_variables {
    type  = "literal"
    name  = "PGADMIN_LISTEN_PORT"
    value = "8080"
  }

    run_env_variables {
    type  = "literal"
    name  = "PGADMIN_CONFIG_CONFIG_DATABASE_URI"
    value = "'postgresql://${var.pg_user}:${var.pg_password}@${var.pg_host}:${var.pg_port}/ibmclouddb?sslmode=allow'"
  }
}

output "endpoint" {

  value = ibm_code_engine_app.pgadmin_app.endpoint

}
