
locals {
    s3_origin_id = "s3-cloudfront"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
    count = var.is_web_static_page == true ? 0 : 1
    origin {
        domain_name = var.bucket_regional_domain_name
        origin_id   = local.s3_origin_id
        s3_origin_config {
            origin_access_identity = var.cloudfront_access_identity_path
        }
    }
    aliases             = var.alternate_domain_names
    tags = {
      Environment = var.env
    }
    enabled             = true
    is_ipv6_enabled     = true
    default_root_object = "index.html"
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
        viewer_protocol_policy = "allow-all"
        min_ttl                = 0
        default_ttl            = 86400
        max_ttl                = 31536000
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
}

resource "aws_cloudfront_distribution" "web_cloudfront_distribution" {
  count = var.is_web_static_page == true ? 1 : 0
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