# This module creates a set of Bedrock agents for a football management system.
# The agents are designed to handle various aspects of football management, including transfers, strategy, and fitness.
# The agents are associated with a knowledge base that contains the data for the system.

resource "aws_bedrockagent_agent" "head_coach" {
  agent_name                  = "ai-head-coach"
  agent_resource_role_arn     = aws_iam_role.bedrock_agent_role.arn
  agent_collaboration         = "SUPERVISOR_ROUTER"
  idle_session_ttl_in_seconds = 600
  foundation_model            =  "amazon.nova-lite-v1:0"
  instruction                 = "You are the AI Head Coach. Coordinate with assistant agents to answer questions related to football strategy, transfers, and fitness. Route tasks accordingly."
  prepare_agent               = false
  depends_on = [  ]
}

# this is the transfer market agent
resource "aws_bedrockagent_agent" "transfer_agent" {
  agent_name                  = "transfer-market-agent"
  agent_resource_role_arn     = aws_iam_role.bedrock_agent_role.arn
  idle_session_ttl_in_seconds = 600
  foundation_model            = "amazon.nova-lite-v1:0"
  instruction                 = "You are a football transfer market expert. Provide insights into player transfers, contract statuses, rumors, and market values.Always answer based on the knowledge retreival from knowledge base. Do not give generic answer ever."
  prepare_agent               = true
}

#this is the strategy/scouting agent
resource "aws_bedrockagent_agent" "strategy_agent" {
  agent_name                  = "strategy-scout-agent"
  agent_resource_role_arn     = aws_iam_role.bedrock_agent_role.arn
  idle_session_ttl_in_seconds = 600
  foundation_model            = "amazon.nova-lite-v1:0"
  instruction                 = "You specialize in team tactics, formations, and player scouting. Offer strategic football insights and evaluate player roles.Always answer based on the knowledge retreival from knowledge base. Do not give generic answer ever."
  prepare_agent               = true
}

# this is the injury/fitness agent
resource "aws_bedrockagent_agent" "fitness_agent" {
  agent_name                  = "injury-fitness-agent"
  agent_resource_role_arn     = aws_iam_role.bedrock_agent_role.arn
  idle_session_ttl_in_seconds = 600
  foundation_model            = "amazon.nova-lite-v1:0"
  instruction                 = "You analyze player injuries, fitness levels, and recovery plans. Advise on rotations, workloads, and injury risks.Always answer based on the knowledge retreival from knowledge base. Do not give generic answer ever."
  prepare_agent               = true
}

# Associate Knowledge Base to Agents

resource "aws_bedrockagent_agent_knowledge_base_association" "transfer_kb_assoc" {
  agent_id             = aws_bedrockagent_agent.transfer_agent.agent_id
  knowledge_base_id    = aws_bedrockagent_knowledge_base.transfer_kb.id
  knowledge_base_state = "ENABLED"
  description          = "Transfer Market Knowledge Base"
}

resource "aws_bedrockagent_agent_knowledge_base_association" "strategy_kb_assoc" {
  agent_id             = aws_bedrockagent_agent.strategy_agent.agent_id
  knowledge_base_id    = aws_bedrockagent_knowledge_base.strategy_kb.id
  knowledge_base_state = "ENABLED"
  description          = "Strategy & Scouting Knowledge Base"
}

resource "aws_bedrockagent_agent_knowledge_base_association" "fitness_kb_assoc" {
  agent_id             = aws_bedrockagent_agent.fitness_agent.agent_id
  knowledge_base_id    = aws_bedrockagent_knowledge_base.fitness_kb.id
  knowledge_base_state = "ENABLED"
  description          = "Injury & Fitness Knowledge Base"
}