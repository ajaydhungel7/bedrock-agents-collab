output "head_coach_agent_id" {
  description = "ID of the Head Coach (Supervisor) Agent"
  value       = aws_bedrockagent_agent.head_coach.agent_id
}

output "transfer_agent_id" {
  description = "ID of the Transfer Market Agent"
  value       = aws_bedrockagent_agent.transfer_agent.agent_id
}

output "strategy_agent_id" {
  description = "ID of the Strategy/Scouting Agent"
  value       = aws_bedrockagent_agent.strategy_agent.agent_id
}

output "fitness_agent_id" {
  description = "ID of the Injury and Fitness Agent"
  value       = aws_bedrockagent_agent.fitness_agent.agent_id
}

output "opensearch_collection_arn" {
  description = "ARN of the OpenSearch Serverless collection used by all KBs"
  value       = aws_opensearchserverless_collection.bedrock_kb_collection.arn
}

output "knowledge_base_ids" {
  description = "IDs of all created knowledge bases"
  value = {
    transfer = aws_bedrockagent_knowledge_base.transfer_kb.id
    strategy = aws_bedrockagent_knowledge_base.strategy_kb.id
    fitness  = aws_bedrockagent_knowledge_base.fitness_kb.id
  }
}