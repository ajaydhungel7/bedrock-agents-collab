data "aws_region" "current" {}

locals {
  embedding_model_arn         = "arn:aws:bedrock:${data.aws_region.current.name}::foundation-model/amazon.titan-embed-text-v2:0"
  base_s3_uri                 = "s3://${var.existing_kb_bucket_name}"
  opensearch_collection_arn  = aws_opensearchserverless_collection.bedrock_kb_collection.arn
}

resource "aws_bedrockagent_knowledge_base" "transfer_kb" {
  name     = "transfer-kb-${var.environment}"
  role_arn = aws_iam_role.bedrock_agent_role.arn

  #ADD Data source for the knowledge base
  

  knowledge_base_configuration {
    type = "VECTOR"
    vector_knowledge_base_configuration {
      embedding_model_arn = local.embedding_model_arn

      embedding_model_configuration {
        bedrock_embedding_model_configuration {
          dimensions          = 512
          embedding_data_type = "FLOAT32"
        }
      }

      supplemental_data_storage_configuration {
        storage_location {
          type = "S3"
          s3_location {
            uri = "${local.base_s3_uri}"
          }
        }
      }
    }
  }

  storage_configuration {
    type = "OPENSEARCH_SERVERLESS"
    opensearch_serverless_configuration {
      collection_arn    = local.opensearch_collection_arn
      vector_index_name = "bedrock-knowledge-base-default-index"
      field_mapping {
        vector_field   = "bedrock-knowledge-base-default-vector"
        text_field     = "AMAZON_BEDROCK_TEXT_CHUNK"
        metadata_field = "AMAZON_BEDROCK_METADATA"
      }
    }
  }

  depends_on = [aws_opensearchserverless_collection.bedrock_kb_collection]
}

resource "aws_bedrockagent_knowledge_base" "strategy_kb" {
  name     = "strategy-kb-${var.environment}"
  role_arn = aws_iam_role.bedrock_agent_role.arn

  knowledge_base_configuration {
    type = "VECTOR"
    vector_knowledge_base_configuration {
      embedding_model_arn = local.embedding_model_arn

      embedding_model_configuration {
        bedrock_embedding_model_configuration {
          dimensions          = 512
          embedding_data_type = "FLOAT32"
        }
      }

      supplemental_data_storage_configuration {
        storage_location {
          type = "S3"
          s3_location {
            uri = "${local.base_s3_uri}"
          }
        }
      }
    }
  }

  storage_configuration {
    type = "OPENSEARCH_SERVERLESS"
    opensearch_serverless_configuration {
      collection_arn    = local.opensearch_collection_arn
      vector_index_name = "bedrock-kb-strategy-index"
      field_mapping {
        vector_field   = "bedrock-knowledge-base-default-vector"
        text_field     = "AMAZON_BEDROCK_TEXT_CHUNK"
        metadata_field = "AMAZON_BEDROCK_METADATA"
      }
    }
  }

  depends_on = [aws_opensearchserverless_collection.bedrock_kb_collection]
}

resource "aws_bedrockagent_knowledge_base" "fitness_kb" {
  name     = "fitness-kb-${var.environment}"
  role_arn = aws_iam_role.bedrock_agent_role.arn

  knowledge_base_configuration {
    type = "VECTOR"
    vector_knowledge_base_configuration {
      embedding_model_arn = local.embedding_model_arn

      embedding_model_configuration {
        bedrock_embedding_model_configuration {
          dimensions          = 512
          embedding_data_type = "FLOAT32"
        }
      }

      supplemental_data_storage_configuration {
        storage_location {
          type = "S3"
          s3_location {
            uri = "${local.base_s3_uri}"
          }
        }
      }
    }
  }

  storage_configuration {
    type = "OPENSEARCH_SERVERLESS"
    opensearch_serverless_configuration {
      collection_arn    = local.opensearch_collection_arn
      vector_index_name = "bedrock-kb-fitness-index"
      field_mapping {
        vector_field   = "bedrock-knowledge-base-default-vector"
        text_field     = "AMAZON_BEDROCK_TEXT_CHUNK"
        metadata_field = "AMAZON_BEDROCK_METADATA"
      }
    }
  }

  depends_on = [aws_opensearchserverless_collection.bedrock_kb_collection]
}

resource "aws_bedrockagent_data_source" "transfer_kb_data_source" {
  name              = "transfer-kb-ds-${var.environment}"
  knowledge_base_id = aws_bedrockagent_knowledge_base.transfer_kb.id

  data_source_configuration {
    type = "S3"

    s3_configuration {
      bucket_arn         = "arn:aws:s3:::${var.existing_kb_bucket_name}"
      inclusion_prefixes = ["chunk-processor/transfer/"]
    }
  }

  description          = "Transfer market documents from chunk-processor/transfer/"
  data_deletion_policy = "RETAIN"
}

resource "aws_bedrockagent_data_source" "strategy_kb_data_source" {
  name              = "strategy-kb-ds-${var.environment}"
  knowledge_base_id = aws_bedrockagent_knowledge_base.strategy_kb.id

  data_source_configuration {
    type = "S3"

    s3_configuration {
      bucket_arn         = "arn:aws:s3:::${var.existing_kb_bucket_name}"
      inclusion_prefixes = ["chunk-processor/strategy/"]
    }
  }

  description          = "Strategy documents from chunk-processor/strategy/"
  data_deletion_policy = "RETAIN"
}

resource "aws_bedrockagent_data_source" "fitness_kb_data_source" {
  name              = "fitness-kb-ds-${var.environment}"
  knowledge_base_id = aws_bedrockagent_knowledge_base.fitness_kb.id

  data_source_configuration {
    type = "S3"

    s3_configuration {
      bucket_arn         = "arn:aws:s3:::${var.existing_kb_bucket_name}"
      inclusion_prefixes = ["chunk-processor/fitness/"]
    }
  }

  description          = "Injury and Fitness documents from chunk-processor/fitness/"
  data_deletion_policy = "RETAIN"
}