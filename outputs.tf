output "us_domain" {
  value = "${module.us_web_instance.load_balancer_dns_name}"
}

output "ireland_domain" {
  value = "${module.ireland_web_instance.load_balancer_dns_name}"
}
