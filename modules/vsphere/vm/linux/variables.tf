variable "vm" {
  description = "Map of VMs to create. Each key is the VM name prefix (e.g. 'PSBD'), and the value is the VM configuration."
  type = map(object({

    # ── vSphere placement ───────────────────────────────────────────
    datacenter        = string           # vSphere datacenter name
    resource_pool     = string           # Resource pool full path (e.g. "cluster/Resources/pool")
    datastore_cluster = optional(string, "") # Datastore cluster name; leave empty to skip
    vmfolder          = optional(string)    # VM folder path relative to datacenter
    datastore         = optional(string, "") # Specific datastore name; used when not using a datastore cluster
    vsphere_cluster   = optional(string)    # vSphere cluster name (informational; used for resource pool resolution in some setups)

    # ── Template ────────────────────────────────────────────────────
    template = string # Name of the VM template to clone from

    # ── Naming ──────────────────────────────────────────────────────
    instances    = number           # Number of VMs to create from this entry
    vmstartcount = optional(number, 1) # Index of the first VM (e.g. 1 → PSBD01)
    staticvmname = optional(string)    # Override generated name with a fixed name (single VM only)

    # ── Credentials & provisioning ─────────────────────────────────
    local_adminpass = optional(string)  # Guest OS admin password (passed to customization and provisioners)
    distro          = optional(string)  # Linux distro identifier (e.g. "alma", "rhel") used by provisioning scripts

    # ── Compute ─────────────────────────────────────────────────────
    cpu    = number # Number of vCPUs
    memory = number # Memory in MB

    cpu_hot_add_enabled    = optional(bool, false)
    memory_hot_add_enabled = optional(bool, false)

    # ── Networking ──────────────────────────────────────────────────
    # Map of network-name → list of "ip/prefix" strings, one per instance.
    # Example:
    #   network = {
    #     "VM Network" = ["10.0.0.11/24", "10.0.0.12/24"]
    #   }
    network = map(list(string))

    # Optional list of adapter types, one per network interface.
    # Falls back to the template's adapter type when omitted.
    network_type = optional(list(string))

    # Explicit interface order by network name. Controls which interface gets
    # the default gateway (always the first entry). Required when using multiple
    # interfaces to avoid relying on unpredictable lexicographic key ordering.
    # Example: ["PG_Gaia_Kubestag", "PG_Gaia_Storage"]
    network_if_order = optional(list(string))

    # Subnet mask(s). Used only when the IP string has no prefix length.
    # Supply a single value to apply to all interfaces, or one per interface.
    mask = list(string)

    gateway         = string        # Default IPv4 gateway
    dns_server_list = optional(list(string), [])
    dns_suffix_list = optional(list(string), [])

    # ── Guest customization ─────────────────────────────────────────
    domain       = string           # DNS domain for the VM hostname
    hw_clock_utc = optional(bool, true)

    # ── Additional data disks ───────────────────────────────────────
    # Map of disk-label → disk attributes. Omit or set to {} for no extra disks.
    # Supported per-disk keys:
    #   size_gb                  (number, required)
    #   thin_provisioned         (bool,   default true)
    #   eagerly_scrub            (bool,   default false)
    #   unit_number              (number, default auto)
    #   data_disk_scsi_controller (number, default 0)
    #   datastore_id             (string, default null)
    #   storage_policy_id        (string, default null)
    #   io_share_level           (string, default "normal")
    #   io_share_count           (number, required when io_share_level = "custom")
    #   disk_mode                (string, default null)
    data_disk = optional(map(map(string)), {})

    # ── Miscellaneous ───────────────────────────────────────────────
    annotation = optional(string)

    # Map of tag category → tag name. Both must already exist in vSphere.
    # Example: { "Ambiente" = "Lab", "Aplicacao" = "Apache" }
    tags = optional(map(string))

    wait_for_guest_net_routable = optional(bool, true)
    wait_for_guest_ip_timeout   = optional(number, 0)
    wait_for_guest_net_timeout  = optional(number, 5)

    timeout               = optional(number, 30) # Clone timeout in minutes
    shutdown_wait_timeout = optional(number, 3)
    force_power_off       = optional(bool, false)
  }))
}
