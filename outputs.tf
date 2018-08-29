output "web_domain" {
  value = "${module.web_instance.public_dns}"
}
