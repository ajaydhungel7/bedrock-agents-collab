

# 1. Network Security Policy — Allow Bedrock service to reach the collection
resource "aws_opensearchserverless_security_policy" "bedrock_network_policy" {
  name        = "bedrock-kb-network-policy-${var.environment}"
  type        = "network"
  description = "Allow public access to OpenSearch collection (for Bedrock testing)"

  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "collection",
          Resource     = ["collection/bedrock-kb-${var.environment}"]
        }
      ],
      AllowFromPublic = true,
      #SourceVPCEs     = []  # Must be present, even if AllowFromPublic is true
    }
  ])
}

resource "aws_opensearchserverless_security_policy" "bedrock_encryption_policy" {
  name        = "bedrock-kb-encryption-policy-${var.environment}"
  type        = "encryption"
  description = "Encryption policy for OpenSearch Serverless collection"

  policy = jsonencode({
    Rules = [
      {
        ResourceType = "collection",
        Resource     = ["collection/bedrock-kb-${var.environment}"]
      }
    ],
    AWSOwnedKey = true
  })
}

# 2. Data Access Policy — Allow IAM role to perform operations on the collection
resource "aws_opensearchserverless_access_policy" "bedrock_data_policy" {
  name        = "bedrock-kb-data-policy-${var.environment}"
  type        = "data"
  description = "Allow Bedrock agent and Ajay Dhungel IAM user full access to all collections and their indexes"

  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "collection",
          Resource     = ["collection/*"],
          Permission   = [
            "aoss:DescribeCollectionItems",
            "aoss:CreateCollectionItems",
            "aoss:UpdateCollectionItems",
            "aoss:DeleteCollectionItems",
            "aoss:RestoreSnapshot",
            "aoss:DescribeSnapshot"
          ]
        },
        {
          ResourceType = "index",
          Resource     = ["index/*/*"],
          Permission   = [
            "aoss:ReadDocument",
            "aoss:WriteDocument",
            "aoss:CreateIndex",
            "aoss:DeleteIndex",
            "aoss:UpdateIndex",
            "aoss:DescribeIndex"
          ]
        }
      ],
      Principal = [
        aws_iam_role.bedrock_agent_role.arn,
        "arn:aws:iam::544234170512:user/ajay.dhungel"
      ]
    }
  ])
}

# 3. OpenSearch Vector Collection
resource "aws_opensearchserverless_collection" "bedrock_kb_collection" {
  name = "bedrock-kb-${var.environment}"
  type = "VECTORSEARCH"

  depends_on = [
    aws_opensearchserverless_security_policy.bedrock_network_policy,
    aws_opensearchserverless_access_policy.bedrock_data_policy,
    aws_opensearchserverless_security_policy.bedrock_encryption_policy
  ]
}



resource "opensearch_index" "bedrock-knowledge-base-default-index" {
  provider                       = opensearch
  name                           = "bedrock-knowledge-base-default-index"
  number_of_shards               = "2"
  number_of_replicas             = "0"
  index_knn                      = true
  index_knn_algo_param_ef_search = "512"
  mappings                       = <<-EOF
    {
      "properties": {
        "bedrock-knowledge-base-default-vector": {
          "type": "knn_vector",
          "dimension": 512,
          "method": {
            "name": "hnsw",
            "engine": "faiss",
            "parameters": {
              "m": 16,
              "ef_construction": 512
            },
            "space_type": "l2"
          }
        },
        "AMAZON_BEDROCK_METADATA": {
          "type": "text",
          "index": "false"
        },
        "AMAZON_BEDROCK_TEXT_CHUNK": {
          "type": "text",
          "index": "true"
        }
      }
    }
  EOF
  force_destroy                  = true
  depends_on                     = [aws_opensearchserverless_collection.bedrock_kb_collection]
}

resource "opensearch_index" "bedrock_kb_fitness_index" {
  provider                       = opensearch
  name                           = "bedrock-kb-fitness-index"
  number_of_shards               = "2"
  number_of_replicas             = "0"
  index_knn                      = true
  index_knn_algo_param_ef_search = "512"
  mappings                       = <<-EOF
    {
      "properties": {
        "bedrock-knowledge-base-default-vector": {
          "type": "knn_vector",
          "dimension": 512,
          "method": {
            "name": "hnsw",
            "engine": "faiss",
            "parameters": {
              "m": 16,
              "ef_construction": 512
            },
            "space_type": "l2"
          }
        },
        "AMAZON_BEDROCK_METADATA": {
          "type": "text",
          "index": "false"
        },
        "AMAZON_BEDROCK_TEXT_CHUNK": {
          "type": "text",
          "index": "true"
        }
      }
    }
  EOF
  force_destroy = true
  depends_on    = [aws_opensearchserverless_collection.bedrock_kb_collection]
}

resource "opensearch_index" "bedrock_kb_strategy_index" {
  provider                       = opensearch
  name                           = "bedrock-kb-strategy-index"
  number_of_shards               = "2"
  number_of_replicas             = "0"
  index_knn                      = true
  index_knn_algo_param_ef_search = "512"
  mappings                       = <<-EOF
    {
      "properties": {
        "bedrock-knowledge-base-default-vector": {
          "type": "knn_vector",
          "dimension": 512,
          "method": {
            "name": "hnsw",
            "engine": "faiss",
            "parameters": {
              "m": 16,
              "ef_construction": 512
            },
            "space_type": "l2"
          }
        },
        "AMAZON_BEDROCK_METADATA": {
          "type": "text",
          "index": "false"
        },
        "AMAZON_BEDROCK_TEXT_CHUNK": {
          "type": "text",
          "index": "true"
        }
      }
    }
  EOF
  force_destroy = true
  depends_on    = [aws_opensearchserverless_collection.bedrock_kb_collection]
}
