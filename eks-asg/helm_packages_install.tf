# auto-scaling
resource "helm_release" "cluster_autoscaler" {
  depends_on = [
    module.eks
  ]

  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = "0.12.2"

  set {
    name  = "autoDiscovery.enabled"
    value = "true"
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "cloudProvider"
    value = "aws"
  }

  set {
    name  = "awsRegion"
    value = var.aws_region
  }

  set {
    name  = "rbac.create"
    value = "true"
  }
  /*
  set {
    name  = "sslCertPath"
    value = "/etc/ssl/certs/ca-bundle.crt"
  }
*/
}


/*
resource "helm_release" "cluster_autoscaler" {
  repository       = "https://kubernetes.github.io/autoscaler"
  name             = "cluster-autoscaler"
  namespace        = "kube-system"
  create_namespace = false
  chart            = "cluster-autoscaler"
  version          = "1.6.4"
  set {
    name  = "registry"
    value = local.ecr_registry
  }
  wait = false
}
*/


# helm argocd

resource "kubernetes_namespace" "argocd" {
  depends_on = [
    module.eks
  ]
  metadata {
    name = var.kubernetes_argocd_namespace
  }
}

resource "helm_release" "argocd" {
  depends_on = [kubernetes_namespace.argocd]

  name       = "argocd"
  repository = var.argo
  chart      = "argo-cd"
  namespace  = var.kubernetes_argocd_namespace
  version    = var.argocd_helm_chart_version == "" ? null : var.argocd_helm_chart_version

  values = [
    templatefile(
      "${path.module}/templates/values.yaml.tpl",
      {
        "argocd_server_host"          = var.argocd_server_host
        "eks_iam_argocd_role_arn"     = var.eks_iam_argocd_role_name
        "argocd_github_client_id"     = var.argocd_github_client_id
        "argocd_github_client_secret" = var.argocd_github_client_secret
        "argocd_github_org_name"      = var.argocd_github_org_name

        "argocd_ingress_enabled"                 = var.argocd_ingress_enabled
        "argocd_ingress_tls_acme_enabled"        = var.argocd_ingress_tls_acme_enabled
        "argocd_ingress_ssl_passthrough_enabled" = var.argocd_ingress_ssl_passthrough_enabled
        "argocd_ingress_class"                   = var.argocd_ingress_class
        "argocd_ingress_tls_secret_name"         = var.argocd_ingress_tls_secret_name
      }
    )
  ]
}


# Node Termination Handler



resource "helm_release" "aws-node-termination-handler" {
  depends_on = [
    module.eks
  ]


  name             = "aws-node-termination-handler"
  namespace        = "kube-system"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-node-termination-handler"
  create_namespace = false

  set {
    name  = "enableSpotInterruptionDraining"
    value = true
  }

  set {
    name  = "awsRegion"
    value = var.aws_region
  }



}
