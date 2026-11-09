terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
  required_version = ">1.12.0" /*Многострочный комментарий.
 Требуемая версия terraform */
}
provider "docker" {
  context = "yandex"
}

resource "random_password" "random_string" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "random_string_root" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}


resource "docker_image" "nginx" {
  name         = "mysql:8"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "hello_world"
  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.random_string_root.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.random_string.result}",
    "MYSQL_ROOT_HOST=%"
  ]


  ports {
    ip       = "127.0.0.1"
    internal = 3306
    external = 3306
  }
}

