










# argocd cd variables

variable "kubernetes_argocd_namespace" {
  description = "Namespace to release argocd into"
  type        = string
  default     = "argocd"
}

variable "argocd_helm_chart_version" {
  description = "argocd helm chart version to use"
  type        = string
  default     = ""
}

variable "argocd_server_host" {
  description = "Hostname for argocd (will be utilised in ingress if enabled)"
  type        = string
}

variable "argocd_ingress_class" {
  description = "Ingress class to use for argocd"
  type        = string
  default     = "nginx"
}

variable "argocd_ingress_enabled" {
  description = "Enable/disable argocd ingress"
  type        = bool
  default     = true
}

variable "argocd_ingress_tls_acme_enabled" {
  description = "Enable/disable acme TLS for ingress"
  type        = string
  default     = "true"
}

variable "argocd_ingress_ssl_passthrough_enabled" {
  description = "Enable/disable SSL passthrough for ingresss"
  type        = string
  default     = "true"
}

variable "argocd_ingress_tls_secret_name" {
  description = "Secret name for argocd TLS cert"
  type        = string
  default     = "argocd-cert"
}

variable "eks_iam_argocd_role_name" {
  description = "IAM EKS service account role name for Argo CD"
  type        = string
  default     = "sss"
}

variable "argocd_github_client_id" {
  description = "GitHub OAuth application client id (see Argo CD user management guide)"
  type        = string
}

variable "argocd_github_client_secret" {
  description = "GitHub OAuth application client secret (see Argo CD user management guide)"
  type        = string
}

variable "argocd_github_org_name" {
  description = "Organisation to restrict Argo CD to"
  type        = string
}



# data

variable "argo" {
  type        = string
  description = "describe your variable"
  default     = "https://argoproj.github.io/argo-helm"
}
