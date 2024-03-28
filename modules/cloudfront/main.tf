
locals {
  target_origin_group = "target_origin_group"
  s3_origin_id = "s3_origin_id"
}

data "aws_lambda_function_url" "main" {
  count = var.lambda_function_name != "" ? 1 : 0
  function_name = var.lambda_function_name
}

data "aws_cloudfront_function" "main" {
  count = var.cloudfront_function_name != "" ? 1 : 0
  name = var.cloudfront_function_name
  stage = var.cloudfront_function_stage
}

resource "aws_cloudfront_distribution" "s3_distribution" {
    count = var.is_webapp_distribution == true ? 0 : 1

    origin_group {
      origin_id = local.target_origin_group

      failover_criteria {
        status_codes = [403, 404, 500, 502]
      }

      member {
        origin_id = "primaryS3"
      }

      member {
        origin_id = "failoverS3"
      }
    }

    origin {
        domain_name = var.bucket_regional_domain_name
        origin_id   = "primaryS3"
        s3_origin_config {
            origin_access_identity = var.cloudfront_access_identity_path
        }

        origin_shield {
          enabled = true
          origin_shield_region = var.origin_shield_region
        }

        connection_attempts = 1
        connection_timeout = 10
    }

    origin {
      domain_name = regex("https://([^/]+)/", data.aws_lambda_function_url.main[0].function_url)[0]
      origin_id   = "failoverS3"

      custom_origin_config {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2", "TLSv1.1"]
        origin_keepalive_timeout = 5
        origin_read_timeout     = 30
      }

      origin_shield {
        enabled = true
        origin_shield_region = var.origin_shield_region
      }

      custom_header {
        name = "x-origin-secret-header"
        value = var.header_secret
      }
    }

    aliases             = var.alternate_domain_names
    enabled             = true
    is_ipv6_enabled     = true
    default_root_object = "index.html"
    default_cache_behavior {
      allowed_methods  = ["GET", "HEAD", "OPTIONS"]
      cached_methods   = ["GET", "HEAD"]
      target_origin_id = local.target_origin_group
      forwarded_values {
          query_string = false
          cookies {
              forward = "none"
          }
      }
      viewer_protocol_policy = "allow-all"
      min_ttl                = 0
      default_ttl            = 86400
      max_ttl                = 31536000

      function_association {
        event_type = "viewer-request"
        function_arn = data.aws_cloudfront_function.main[0].arn
      }
    }
    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }
    viewer_certificate {
        cloudfront_default_certificate = false
        acm_certificate_arn            = var.acm_certificate_arn
        ssl_support_method             = var.ssl_support_method
        minimum_protocol_version       = "TLSv1"
    }
    tags = {
      Environment = var.env
    }
}

resource "aws_cloudfront_distribution" "webapp_distribution" {
  count = var.is_webapp_distribution == true ? 1 : 0
  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = var.cloudfront_access_identity_path
    }
  }
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = var.alternate_domain_names

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  price_class = "PriceClass_200"

  tags = {
    Environment = var.env
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.ssl_support_method
    minimum_protocol_version       = "TLSv1"
  }
}