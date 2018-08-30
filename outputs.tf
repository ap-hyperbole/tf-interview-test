output "web_domain" {
  value = "${module.web_instance.load_balancer_dns_name}"
}
