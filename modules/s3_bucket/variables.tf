variable "name_prefix" {
  default = ""
}

variable "cors_allowed_origins" {
  description = "Browser origins allowed to upload/download directly via presigned PUT/GET. Empty list disables CORS (no configuration is created)."
  type        = list(string)
  default     = []
}