output "key_pair_name" {
  description = "Key pair name."
  value       = aws_key_pair.this.key_name
}

output "key_pair_id" {
  description = "Key pair ID."
  value       = aws_key_pair.this.key_pair_id
}
