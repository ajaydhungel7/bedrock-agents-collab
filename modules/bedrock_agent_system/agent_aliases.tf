resource "aws_bedrockagent_agent_alias" "head_coach_alias" {
  agent_alias_name = "head-coach-alias"
  agent_id         = aws_bedrockagent_agent.head_coach.agent_id
  description      = "Alias for the main supervising AI Head Coach"
  depends_on       = [aws_bedrockagent_agent.head_coach]
}

resource "aws_bedrockagent_agent_alias" "transfer_alias" {
  agent_alias_name = "transfer-agent-alias"
  agent_id         = aws_bedrockagent_agent.transfer_agent.agent_id
  description      = "Alias for the Transfer Market Agent"
  depends_on       = [aws_bedrockagent_agent.transfer_agent]
}

resource "aws_bedrockagent_agent_alias" "strategy_alias" {
  agent_alias_name = "strategy-agent-alias-v2"
  agent_id         = aws_bedrockagent_agent.strategy_agent.agent_id
  description      = "Alias for the Strategy/Scout Agent"
  depends_on       = [aws_bedrockagent_agent.strategy_agent]
}

resource "aws_bedrockagent_agent_alias" "fitness_alias" {
  agent_alias_name = "fitness-agent-alias-v2"
  agent_id         = aws_bedrockagent_agent.fitness_agent.agent_id
  description      = "Alias for the Injury and Fitness Agent"
  depends_on       = [aws_bedrockagent_agent.fitness_agent]
}