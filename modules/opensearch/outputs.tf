output "opensearch_collection_arn" {
  description = "The name of the collection for the Knowledge Base Open Source Software (OSS) content"
  value       = aws_opensearchserverless_collection.sample_kb.arn
}


output "opensearch_index_name" {
  description = "The name of the OpenSearch index"
  value       = opensearch_index.sample_kb.name
}