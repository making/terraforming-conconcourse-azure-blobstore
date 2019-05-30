provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  environment     = "${var.cloud_name}"

  version = "~> 1.22"
}

terraform {
  required_version = "< 0.12.0"
}


resource "azurerm_resource_group" "concourse" {
  name     = "${var.env_name}-concourse"
  location = "${var.location}"
}

resource random_string "concourse_storage_account_name" {
  length  = 20
  special = false
  upper   = false
}

resource "azurerm_storage_account" "concourse_root_storage_account" {
  name                     = "${random_string.concourse_storage_account_name.result}"
  resource_group_name      = "${azurerm_resource_group.concourse.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.env_name}"
    account_for = "concourse"
  }
}

resource "azurerm_storage_container" "concourse_storage_container" {
  name                  = "concourse"
  depends_on            = ["azurerm_storage_account.concourse_root_storage_account"]
  resource_group_name   = "${azurerm_resource_group.concourse.name}"
  storage_account_name  = "${azurerm_storage_account.concourse_root_storage_account.name}"
  container_access_type = "blob"
}

variable "cloud_name" {
  description = "The Azure cloud environment to use. Available values at https://www.terraform.io/docs/providers/azurerm/#environment"
  default     = "public"
}

variable "env_name" {}

variable "subscription_id" {}

variable "tenant_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "location" {}


output "storage_account_name" {
  value = "${azurerm_storage_account.concourse_root_storage_account.name}"
}
output "storage_access_key" {
  value = "${azurerm_storage_account.concourse_root_storage_account.primary_access_key}"
}

