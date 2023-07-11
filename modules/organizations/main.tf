data "aws_iam_policy_document" "test-policy-data" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${var.account_id}:role/*"]

    condition {
      variable = "aws:username"
      values   = var.account_owner
    }
  }
}

resource "aws_organizations_policy" "test-policy" {
  name    = "roles-restriction"
  content = data.aws_iam_policy_document.test-policy-data.json
}

resource "aws_organizations_policy_attachment" "account" {
  policy_id = aws_organizations_policy.test-policy.id
  target_id = var.account_id
}