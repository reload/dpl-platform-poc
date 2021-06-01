resource "dnsimple_record" "aks_ingress" {
  domain = "reload.dk"
  name   = "*.poc01.dplpoc"
  value  = azurerm_public_ip.aks_ingress.ip_address
  type   = "A"
  ttl    = 60
}
