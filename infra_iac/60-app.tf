################################################################################
# Деплой приложения


# -------------------------------------------------
# Файл для импорта логина и пароля к аккаунту Докера
# в Jenkins Credentials
data "template_file" "app_deployment" {
  template = file("${path.module}/templates/app-deployment.tpl")

  vars = {
    login = "${var.dockerhub_login}"
  }

}

# -------------------------------------------------
# Сохранение рендера креденшелов в файл
resource "null_resource" "app_deployment" {

  provisioner "local-exec" {
    command = format("cat <<\"EOF\" > \"%s\"\n%s\nEOF", "../02-app/jenkins-docker-maven-java-webapp/manifests/00-deployment.yml", data.template_file.app_deployment.rendered)
  }

  triggers = {
    template = data.template_file.app_deployment.rendered
  }
}

# -------------------------------------------------
# Деплой приложения в кластер
resource "null_resource" "app" {
  provisioner "local-exec" {
    command = <<EOF
      kubectl --kubeconfig=./kubeconfig/config-${terraform.workspace} apply -f ../02-app/jenkins-docker-maven-java-webapp/manifests/
    EOF
  }


  depends_on = [
    null_resource.app_deployment
  ]

  triggers = {
    cluster_instance_ids = join(",", [join(",", yandex_compute_instance.control.*.id), join(",", yandex_compute_instance.worker.*.id)])
  }
}