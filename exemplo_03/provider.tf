provider "vsphere" {
  user           = "sof.intra\\user_svc_rancher"
  password       = "#4p0t1@Ranch3r#"
  vsphere_server = "pvcn01.sof.intra"
  allow_unverified_ssl = true
}
