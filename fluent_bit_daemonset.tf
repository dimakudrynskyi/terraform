resource "kubernetes_namespace" "fluent_bit" {
  metadata {
    name = "fluent-bit"

    labels = {
      "app.kubernetes.io/name" = "fluent-bit"
    }
  }

  depends_on = [var.cluster_endpoint]
}

resource "kubernetes_service_account" "fluent_bit" {
  metadata {
    name      = "fluent-bit"
    namespace = kubernetes_namespace.fluent_bit.metadata[0].name
  }
}

resource "kubernetes_cluster_role" "fluent_bit" {
  metadata {
    name = "fluent-bit"
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "namespaces"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "fluent_bit" {
  metadata {
    name = "fluent-bit"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.fluent_bit.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.fluent_bit.metadata[0].name
    namespace = kubernetes_namespace.fluent_bit.metadata[0].name
  }
}

resource "kubernetes_daemon_set" "fluent_bit" {
  metadata {
    name      = "fluent-bit"
    namespace = kubernetes_namespace.fluent_bit.metadata[0].name

    labels = {
      "app.kubernetes.io/name" = "fluent-bit"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "fluent-bit"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "fluent-bit"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.fluent_bit.metadata[0].name

        container {
          name  = "fluent-bit"
          image = "amazon/aws-for-fluent-bit:latest"

          resources {
            limits = {
              cpu    = "200m"
              memory = "256Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }

          volume_mount {
            name       = "varlog"
            mount_path = "/var/log"
            read_only  = true
          }

          volume_mount {
            name       = "varlibdockercontainers"
            mount_path = "/var/lib/docker/containers"
            read_only  = true
          }

          volume_mount {
            name       = "fluent-bit-config"
            mount_path = "/fluent-bit/etc/"
          }

          env {
            name  = "AWS_REGION"
            value = var.aws_region
          }

          env {
            name  = "CLOUDWATCH_LOG_GROUP"
            value = aws_cloudwatch_log_group.fluent_bit.name
          }

          env {
            name  = "CLOUDWATCH_LOG_STREAM"
            value = aws_cloudwatch_log_stream.fluent_bit.name
          }
        }

        volume {
          name = "varlog"
          host_path {
            path = "/var/log"
          }
        }

        volume {
          name = "varlibdockercontainers"
          host_path {
            path = "/var/lib/docker/containers"
          }
        }

        volume {
          name = "fluent-bit-config"
          config_map {
            name = kubernetes_config_map.fluent_bit.metadata[0].name
          }
        }

        host_network = true
      }
    }
  }
}

resource "kubernetes_config_map" "fluent_bit" {
  metadata {
    name      = "fluent-bit-config"
    namespace = kubernetes_namespace.fluent_bit.metadata[0].name
  }

  data = {
    "fluent-bit.conf" = file("${path.module}/fluent-bit.conf")
  }
}

output "fluent_bit_namespace" {
  description = "Kubernetes namespace for Fluent Bit"
  value       = kubernetes_namespace.fluent_bit.metadata[0].name
}

output "fluent_bit_daemonset" {
  description = "Name of the Fluent Bit DaemonSet"
  value       = kubernetes_daemon_set.fluent_bit.metadata[0].name
}