resource "aws_ecr_repository" "main" {
  name                 = "${var.project_name}-${var.env}-ecr"
  image_tag_mutability = var.image_tag_mutability
  force_delete = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  tags = {
    Name        = "${var.project_name}-ecr"
    Environment = var.env
  }
}

resource "aws_ecr_lifecycle_policy" "keep_tag" {
  count      = var.keep_tag_image_count > 0 ? 1 : 0
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last ${var.keep_tag_image_count} images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus     = "tagged"
        tagPrefixList = var.keep_tag_prefix_list
        countType     = "imageCountMoreThan"
        countNumber   = var.keep_tag_image_count
      }
    }]
  })
}

resource "aws_ecr_lifecycle_policy" "keep_untag" {
  count      = var.expired_image_days > 0 ? 1 : 0
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [{
      rulePriority = 2
      description  = "Expire images older than ${var.expired_image_days} days"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "untagged"
        countType   = "sinceImagePushed"
        countUnit   = "days"
        countNumber = var.expired_image_days
      }
    }]
  })
}
