resource "aws_bedrockagent_agent_collaborator" "transfer_collab" {
  agent_id                   = aws_bedrockagent_agent.head_coach.agent_id
  collaboration_instruction  = "Use this agent for transfer market questions."
  collaborator_name          = "transfer-agent-collab"
  relay_conversation_history = "TO_COLLABORATOR"

  agent_descriptor {
    alias_arn = aws_bedrockagent_agent_alias.transfer_alias.agent_alias_arn
  }

  depends_on = [aws_bedrockagent_agent_alias.transfer_alias]
}

resource "aws_bedrockagent_agent_collaborator" "strategy_collab" {
  agent_id                   = aws_bedrockagent_agent.head_coach.agent_id
  collaboration_instruction  = "Use this agent to discuss formations, tactics, and scouting."
  collaborator_name          = "strategy-agent-collab"
  relay_conversation_history = "TO_COLLABORATOR"

  agent_descriptor {
    alias_arn = aws_bedrockagent_agent_alias.strategy_alias.agent_alias_arn
  }

  depends_on = [aws_bedrockagent_agent_alias.strategy_alias]
}

resource "aws_bedrockagent_agent_collaborator" "fitness_collab" {
  agent_id                   = aws_bedrockagent_agent.head_coach.agent_id
  collaboration_instruction  = "Use this agent to analyze player injuries, fatigue, and fitness planning."
  collaborator_name          = "fitness-agent-collab"
  relay_conversation_history = "TO_COLLABORATOR"

  agent_descriptor {
    alias_arn = aws_bedrockagent_agent_alias.fitness_alias.agent_alias_arn
  }

  depends_on = [aws_bedrockagent_agent_alias.fitness_alias]
}