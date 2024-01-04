resource "aws_sqs_queue" "fifo_queue" {
    name                        = "${var.queue_name}.fifo"
    fifo_queue                  = true
    content_based_deduplication = true
    tags = {
        Name = var.queue_name
    }
}