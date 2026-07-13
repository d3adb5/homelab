resource "aws_iam_user" "smtp" {
  for_each = var.smtp_users
  name     = "ses-smtp-${each.key}"
}

resource "aws_iam_user_policy" "send_email" {
  for_each = var.smtp_users

  name = "send-email"
  user = aws_iam_user.smtp[each.key].name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [merge(
      {
        Effect = "Allow"
        Action = "ses:SendRawEmail"

        # While in the SES sandbox, sends are also authorized against the
        # verified recipient identities, not just the sending domain.
        Resource = concat(
          [aws_sesv2_email_identity.domain.arn],
          [for recipient in aws_sesv2_email_identity.recipients : recipient.arn],
        )
      },
      each.value.from_addresses == null ? {} : {
        Condition = {
          StringLike = { "ses:FromAddress" = each.value.from_addresses }
        }
      },
    )]
  })
}

resource "aws_iam_access_key" "smtp" {
  for_each = var.smtp_users
  user     = aws_iam_user.smtp[each.key].name
}
