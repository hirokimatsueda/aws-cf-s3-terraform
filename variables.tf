variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "parent_domain_name" {
  type = string
}

variable "sub_domain_name_prefix" {
  type    = string
  default = "www"
}

variable "index_html_file_path" {
  type    = string
  default = "index.html"
}
