# Locals shared by several files (the <name_prefix>-<env> name)

locals {
  # Every resource name is built from this, so dev and prod never collide.
  name = "${var.name_prefix}-${var.env}"

  # The three services. vote and result are web-facing; worker has no port.
  services = ["vote", "result", "worker"]
}
